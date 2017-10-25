//
//  GetPhoto.m
//  CSchool
//
//  Created by 左俊鑫 on 16/11/21.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "GetPhoto.h"
#import "JKImagePickerController.h"
#import "PECropViewController.h"
#import "XGAlertView.h"

@interface GetPhoto ()<JKImagePickerControllerDelegate,PECropViewControllerDelegate>

@end

@implementation GetPhoto
{
    NSMutableArray   *_assetsArray;
    NSMutableArray *_imageArray;
}

- (void)getPhoto{
    
    [self composePicAdd];
}

#pragma Mark JKImagePikcer
- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] initWithDelegate:self];
//    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
//        imagePickerController.selectedAssetArray = _assetsArray;
    imagePickerController.filterType = JKImagePickerControllerFilterTypePhotos;
    
    imagePickerController.imagePickerCancelBlock = ^(JKImagePickerController *imagePicker){
        [imagePicker dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
    imagePickerController.imagePickerDidSelectAssetsBlock = ^(JKImagePickerController *imagePicker, NSArray *assets, BOOL isSource){
        if ([assets count]<1) {
            return;
        }
        _assetsArray = [NSMutableArray arrayWithArray:assets];
        JKAssets *selAsset = assets[0];
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:selAsset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                
                if (_crop) {
                    [self openCaijian:image];
                }else{
                    if (_getPhotoBlock) {
                        _getPhotoBlock(image);
                    }
                }
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
        [imagePicker dismissViewControllerAnimated:YES completion:^{
        }];
    };
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [_viewController presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    if ([assets count]<1) {
        return;
    }
    _assetsArray = [NSMutableArray arrayWithArray:assets];
    JKAssets *selAsset = assets[0];
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:selAsset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            
            if (_crop) {
                [self openCaijian:image];
            }else{
                if (_getPhotoBlock) {
                    _getPhotoBlock(image);
                }
            }
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)openCaijian:(UIImage *)originImage{
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
    
    controller.cropViewDidCancelBlock = ^(PECropViewController *controller){
        [controller dismissViewControllerAnimated:YES completion:NULL];
    };
    
    controller.cropViewDidFininshCroppingImageBlock = ^(PECropViewController *controller, UIImage *croppedImage, CGAffineTransform transform, CGRect cropRect){
        [controller dismissViewControllerAnimated:YES completion:NULL];
        //    self.imageView.image = croppedImage;
        if (_getPhotoBlock) {
            _getPhotoBlock(croppedImage);
        }
    };
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [_viewController presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    self.imageView.image = croppedImage;
    if (_getPhotoBlock) {
        _getPhotoBlock(croppedImage);
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        [self updateEditButtonEnabled];
    //    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
