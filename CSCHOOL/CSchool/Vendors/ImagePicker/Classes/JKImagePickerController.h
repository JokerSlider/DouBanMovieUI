//
//  JKImagePickerController.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/9.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKAssets.h"
#import "JKAssetsViewCell.h"
#import <AVFoundation/AVFoundation.h>

@class JKImagePickerController;

typedef void(^ImagePickerCancelBlock)(JKImagePickerController *imagePicker);
typedef void(^ImagePickerDidSelectAssetsBlock)(JKImagePickerController *imagePicker, NSArray *assets, BOOL isSource);

typedef NS_ENUM(NSUInteger, JKImagePickerControllerFilterType) {
    JKImagePickerControllerFilterTypeNone,
    JKImagePickerControllerFilterTypePhotos,
    JKImagePickerControllerFilterTypeVideos
};

UIKIT_EXTERN ALAssetsFilter * ALAssetsFilterFromJKImagePickerControllerFilterType(JKImagePickerControllerFilterType type);

@class JKImagePickerController;

@protocol JKImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source;
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source;
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker;

@end

@interface JKImagePickerController : UIViewController

- (instancetype)initWithDelegate:(id)delegate;

@property (nonatomic, weak) id<JKImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) JKImagePickerControllerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, strong) NSMutableArray     *selectedAssetArray;
@property (nonatomic, strong) ALAssetsGroup *selectAssetsGroup;
@property (assign,nonatomic)BOOL isXaingJi;

@property (nonatomic, copy) ImagePickerCancelBlock imagePickerCancelBlock;
@property (nonatomic, copy) ImagePickerDidSelectAssetsBlock imagePickerDidSelectAssetsBlock;

- (void)startPhotoAssetsViewCell:(JKAssetsViewCell *)assetsCell;
@end
