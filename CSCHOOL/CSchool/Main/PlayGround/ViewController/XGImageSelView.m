//
//  XGImageSelView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "XGImageSelView.h"
#import "SDAutoLayout.h"
#import "JKImagePickerController.h"
#import "UIView+UIViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "YSHYClipViewController.h"
#import "PECropViewController.h"
#import "SDPhotoBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JKImagePickerController.h"
#import "GetPhoto.h"

@implementation SelImage

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    _imageView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _delBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"market_del"] forState:UIControlStateNormal];
//        view.backgroundColor = [UIColor redColor];
        [view addTarget:self action:@selector(delAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [self addSubview:_imageView];
    [self addSubview:_delBtn];
    
    _imageView.sd_layout
    .leftSpaceToView(self,10)
    .rightSpaceToView(self,10)
    .topSpaceToView(self,10)
    .bottomSpaceToView(self,10);
    
    _delBtn.sd_layout
    .topSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .widthIs(20)
    .heightIs(20);
}

- (void)delAction:(UIButton *)sender{
    if (_deleteBlock) {
        _deleteBlock(self.tag);
    }
}

@end


@implementation XGImageSelView
{
    UIButton *_addButton;
    NSMutableArray *_assetsArray;
    NSMutableArray *_selImgViewArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    _addButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//        [view setImage:[UIImage imageNamed:@"market_add_pic"] forState:UIControlStateNormal];
        [view setBackgroundImage:[UIImage imageNamed:@"market_add_pic"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(addImageAction:) forControlEvents:UIControlEventTouchUpInside];
//        view.backgroundColor = [UIColor redColor];
        view;
    });
    
    [self addSubview:_addButton];
    _addButton.frame = CGRectMake(10, 10, VIEW_WITH-20, VIEW_WITH-20);
    _imageListArray = [NSMutableArray array];
    _imageIdArray = [NSMutableArray array];
}

//添加图片事件
- (void)addImageAction:(UIButton *)sender{
    [self.viewController.view endEditing:YES];

    GetPhoto *getPhoto = [[GetPhoto alloc] init];
    getPhoto.crop = YES;
    getPhoto.viewController = self.viewController;
    [getPhoto getPhoto];
    getPhoto.getPhotoBlock = ^(UIImage *image){
        WEAKSELF;
        [weakSelf finishSelImage:image];
    };
//    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
//    [choiceSheet showInView:self.viewController.view];

}

- (void)finishSelImage:(UIImage *)croppedImage{
    [ProgressHUD show:@"正在上传图片" Interaction:NO];
    [NetworkCore uploadImage:croppedImage success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //        _imageIdArray addObject:
        [ProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        [_imageIdArray addObject:[dic valueForKeyPath:@"data.IRIID"]];
        [_imageListArray addObject:croppedImage];
        [self resetImageFrame];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
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
//    self.imageView.image = croppedImage;
    
    [ProgressHUD show:@"正在上传图片" Interaction:NO];
    [NetworkCore uploadImage:croppedImage success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        _imageIdArray addObject:
        [ProgressHUD dismiss];
        NSDictionary *dic = responseObject;
        [_imageIdArray addObject:[dic valueForKeyPath:@"data.IRIID"]];
        [_imageListArray addObject:croppedImage];
        [self resetImageFrame];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [self updateEditButtonEnabled];
//    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addImageWithUrl:(NSMutableArray *)thumbLicArray{
    _imageUrlArray = thumbLicArray;
    [self resetImageFrame:thumbLicArray];
}

- (void)resetImageFrame:(NSMutableArray *)arr{
    if (!arr) {
        arr = _imageListArray;
    }
    
    int i=0;
    for (id view in self.subviews) {
            [view removeFromSuperview];
    }

//    [self.subviews respondsToSelector:@selector(removeFromSuperview)];
    
    _selImgViewArray = [NSMutableArray array];
    for (NSString *url in arr) {
        SelImage *selImage = [[SelImage alloc] initWithFrame:CGRectMake(i*(5+VIEW_WITH), 0, VIEW_WITH, VIEW_WITH)];
        selImage.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [selImage addGestureRecognizer:tap];
//        [selImage.imageView setImage:image];
        [_selImgViewArray addObject:selImage];
//        [selImage.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
//        [_imageListArray addObject:selImage.imageView.image];
        [selImage.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
               [_imageListArray addObject:image];
            }
        }];
        
        WEAKSELF;
        selImage.deleteBlock = ^(NSInteger tag){
            if (_imageListArray.count >tag && _imageIdArray.count >tag) {
                //删除图片执行操作，移除两个数组中的内容
                [_imageListArray removeObjectAtIndex:tag];
                [_imageIdArray removeObjectAtIndex:tag];
                [weakSelf resetImageFrame];
            }
            
        };
        
        [self addSubview:selImage];
        i++;
    }
    if (i>2) {
        _addButton.hidden = YES;
    }else{
        _addButton.frame = CGRectMake(i*(10+VIEW_WITH), 10, VIEW_WITH-20, VIEW_WITH-20);
        _addButton.hidden = NO;
    }
    [self addSubview:_addButton];
}
//重新布局图片位置
- (void)resetImageFrame{
    int i=0;
//    for (id view in self.subviews) {
//        if ([view isKindOfClass:[SelImage class]]) {
//            [view removeFromSuperview];
//        }
//    }
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
//    [self.subviews respondsToSelector:@selector(removeFromSuperview)];

    _selImgViewArray = [NSMutableArray array];
    for (UIImage *image in _imageListArray) {
        SelImage *selImage = [[SelImage alloc] initWithFrame:CGRectMake(i*(5+VIEW_WITH), 0, VIEW_WITH, VIEW_WITH)];
        selImage.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [selImage addGestureRecognizer:tap];
        [selImage.imageView setImage:image];
        [_selImgViewArray addObject:selImage];

        WEAKSELF;
        selImage.deleteBlock = ^(NSInteger tag){
            if (_imageListArray.count >tag && _imageIdArray.count >tag) {
                //删除图片执行操作，移除两个数组中的内容
                [_imageListArray removeObjectAtIndex:tag];
                [_imageIdArray removeObjectAtIndex:tag];
                [weakSelf resetImageFrame];
            }
            
        };
        
        [self addSubview:selImage];
        i++;
    }
    if (i>2) {
        _addButton.hidden = YES;
    }else{
        _addButton.frame = CGRectMake(i*(10+VIEW_WITH), 10, VIEW_WITH-20, VIEW_WITH-20);
        _addButton.hidden = NO;
    }
    [self addSubview:_addButton];
}

//外部代理设定
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    SelImage *view = _selImgViewArray[tap.view.tag];
    NSLog(@"%ld",tap.view.tag);
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.isHiddenSave = YES;
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = _imageListArray.count; // 图片总数
    browser.currentImageIndex = tap.view.tag;
    browser.delegate = self;
    [browser show];
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return _imageListArray[index];
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
