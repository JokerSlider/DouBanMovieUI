//
//  MyMessageInfoHeadView.m
//  CSchool
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyMessageInfoHeadView.h"
#import "MyInfoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JKImagePickerController.h"
#import "UIView+UIViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "YSHYClipViewController.h"
#import "PECropViewController.h"
#import "SDPhotoBrowser.h"
#import "UIImage+GIF.h"
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"

@interface MyMessageInfoHeadView()<PECropViewControllerDelegate,UIActionSheetDelegate>

@end
@implementation MyMessageInfoHeadView
{
    UIImageView *_bgView;
    UIImageView *_imageView;
    
    NSMutableArray *_assetsArray;
    NSMutableArray *_selImgViewArray;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"mine_my_bg"];
    _bgView.image = image;
    _bgView.contentMode =UIViewContentModeScaleToFill;
    
    //圆形头像
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2, (200-120)/2, 120, 120)];
    _imageView.image = [UIImage imageNamed:@"placdeImage"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.cornerRadius = 60;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //手势
    UITapGestureRecognizer *recongesier = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(camerAction)];
    recongesier.numberOfTapsRequired = 1; //点击次数
    recongesier.numberOfTouchesRequired = 1; //点击手指数
    [_imageView addGestureRecognizer:recongesier];
    
    UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-100)/2+70, (200-100)/2+65, 50, 50)];
    [iconBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [iconBtn addTarget:self action:@selector(camerAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgView addSubview:_imageView];
    [_bgView addSubview:iconBtn];
    [self addSubview:_bgView];
}
-(void)setModel:(MyInfoModel *)model
{
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.headimageUrl] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
    
}
#pragma mark  取照片
//取照片
-(void)camerAction
{
    [self.viewController.view endEditing:YES];
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.viewController.view];
}


#pragma mark - imagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage * originImage = info[@"UIImagePickerControllerOriginalImage"];
    
    //打开图片剪裁
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = originImage;
    
    UIImage *image = originImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    controller.keepingCropAspectRatio = YES; //保持等比例
    controller.toolbarHidden = YES; //隐藏底部工具栏
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self.viewController presentViewController:navigationController animated:YES completion:NULL];
    //    [picker pushViewController:controller animated:YES];
    
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    _imageView.image = croppedImage;
    AppUserIndex *user = [AppUserIndex GetInstance];

    [ProgressHUD show:@"正在上传头像" Interaction:NO];
    [NetworkCore uploadPhotoImagewithParams:croppedImage WithParams:@{@"person":@"1"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        user.headImageUrl =[NSString stringWithFormat:@"%@",dic[@"data"][@"IRIURL"]];
        [self saveMyphotoImage:user.headImageUrl];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度:%@",uploadProgress);
    }];
}
-(void)saveMyphotoImage:(NSString *)photoImageUrl
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSDictionary *param = @{
                            @"username":user.role_id,
                            @"rid":@"updateUserInfoByInput",
                            @"photo":photoImageUrl
                            };
    [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        MyInfoModel *model = [[MyInfoModel alloc]init];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [model yy_modelSetWithDictionary:dic];
        }
        NSString *breakString =[NSString stringWithFormat:@"/thumb"];
        NSString *photoUrl = [model.headimageUrl stringByReplacingOccurrencesOfString:breakString withString:@""];
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]];
        //然后就是添加照片语句，记得使用imageWithData:方法，不是imageWithName:。
        UIImage* resultImage = [UIImage imageWithData: imageData];
        if ([AppUserIndex GetInstance].isUseChat) {
            [self saveHeadImage:UIImageJPEGRepresentation(resultImage, 1.0f)];
        }
        user.headImageUrl =photoUrl;
        [user saveToFile];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];

}
#pragma mark 保存头像图片的到xmpp
-(void)saveHeadImage:(NSData*)data
{
    if ([AppUserIndex GetInstance].isUseChat) {
        HQXMPPManager *app=[HQXMPPManager shareXMPPManager];
        XMPPvCardTemp *temp=app.vCard.myvCardTemp;
        temp.photo=data;
        //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
        [app.vCard updateMyvCardTemp:temp];  //保存头像到服务器
    }

}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            if ([self isFrontCameraAvailable]) {
            //                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            //            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self.viewController presentViewController:controller
                                              animated:YES
                                            completion:^(void){
                                                NSLog(@"Picker View Controller is presented");
                                            }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//            controller.navigationBar.barTintColor = Base_Orange;
//            controller.navigationBar.tintColor = [UIColor whiteColor];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self.viewController presentViewController:controller
                                              animated:YES
                                            completion:^(void){
                                                NSLog(@"Picker View Controller is presented");
                                            }];
        }
    }
}


#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

@end
