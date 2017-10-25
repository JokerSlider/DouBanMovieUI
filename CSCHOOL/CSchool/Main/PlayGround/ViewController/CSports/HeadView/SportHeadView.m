//
//  SportHeadView.m
//  CSchool
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SportHeadView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+UIViewController.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PECropViewController.h"

@interface  SportHeadView()<UIActionSheetDelegate,PECropViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)UIButton *allZanView;
@property (nonatomic,copy)NSString *userId;
@property (nonatomic,strong)UIButton *cupNum;//奖牌数

@end
@implementation SportHeadView
{
    UIImageView *_headView;
}
-(instancetype)initWithFrame:(CGRect)frame andUserID:(NSString *)userID
{
    if (self = [super initWithFrame:frame]) {
        self.userId= userID;
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    _headView = ({
        UIImageView *view = [UIImageView new];
        view.userInteractionEnabled= YES;
        view.image = [UIImage imageNamed:@"Sportbanner"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        //本人才可以修改
        if ([self.userId isEqualToString:[AppUserIndex GetInstance].userId]) {
            UITapGestureRecognizer *gesTure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImage:)];
            [view addGestureRecognizer:gesTure];
        }
        view.clipsToBounds = YES;
        view;
    });
    [self addSubview:_headView];
    _headView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    UIView *backView = ({
        UIView *view = [UIView new];
      
        view.backgroundColor =RGB_Alpha(255, 255, 255, 0.4);
        view;
    });
    [_headView addSubview:backView];
    backView.sd_layout.leftSpaceToView(_headView,0).rightSpaceToView(_headView,0).bottomSpaceToView(_headView,0).heightIs(41);
    self.allZanView = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"累计获赞数   0" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"sport_White"] forState:UIControlStateNormal];
        view.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -2);
        view.titleLabel.font = [UIFont systemFontOfSize:15.0];
        view;
    });
    
    self.cupNum = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"累计奖牌数   0" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"goldWhite"] forState:UIControlStateNormal];
        view.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -2);
        view.titleLabel.font = [UIFont systemFontOfSize:15.0];
        view;
    });
    [backView addSubview:self.allZanView];
    [backView addSubview:self.cupNum];
    self.allZanView.sd_layout.rightSpaceToView(backView,20).centerYIs(backView.centerY).widthIs(200).heightIs(30);
    self.cupNum.sd_layout.leftSpaceToView(backView,20).centerYIs(backView.centerY).widthIs(200).heightIs(30);


}
#pragma setModel
-(void)setModel:(SportModel *)model
{
    _model = model;
    
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.UMBIMGURL stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_headView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"Sportbanner"]];
    [self.allZanView setTitle:[NSString stringWithFormat:@"累计获赞数   %@",model.UMBPOINTSSUM?model.UMBPOINTSSUM:@"0"]  forState:UIControlStateNormal];
    [self.cupNum setTitle:[NSString stringWithFormat:@"累计奖牌数   %@",model.UMBTROPHYSUM?model.UMBPOINTSSUM:@"0"] forState:UIControlStateNormal];
    CGSize size = [self.allZanView.titleLabel boundingRectWithSize:CGSizeMake(0, 25)];
    self.allZanView.sd_layout.widthIs(self.allZanView.imageView.frame.size.width+size.width+7);
    size = [self.cupNum.titleLabel boundingRectWithSize:CGSizeMake(0, 25)];
    self.cupNum.sd_layout.widthIs(self.cupNum.imageView.frame.size.width+size.width+7);
}
#pragma mark 上传图片
-(void)uploadImage:(UIButton *)sender
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
    
    
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    self.imageView.image = croppedImage;
    
    [ProgressHUD show:@"正在上传..." Interaction:NO];
    [NetworkCore uploadPhotoImagewithParams:croppedImage WithParams:@{@"person":@"sport"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        NSString *url =[NSString stringWithFormat:@"%@",dic[@"data"][@"IRIURL"]];
        [self saveMyphotoImage:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度%@",uploadProgress);
    }];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        [self updateEditButtonEnabled];
    //    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - PECropViewControllerDelegate methods

-(void)saveMyphotoImage:(NSString *)photoImageUrl
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSDictionary *param = @{
                            @"userid":[AppUserIndex GetInstance].role_id,
                            @"rid":@"uploadSportPhotoUrl",
                            @"photourl":photoImageUrl
                            };
    [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        NSString *breakString =[NSString stringWithFormat:@"/thumb"];
        NSString *photoUrl = [photoImageUrl stringByReplacingOccurrencesOfString:breakString withString:@""];
        [_headView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"Sportbanner"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeSportMainImage" object:nil];//发送换图片的通知

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
    
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//过期的方法
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

#pragma clang diagnostic pop

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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ChangeSportMainImage" object:nil];
}
@end
