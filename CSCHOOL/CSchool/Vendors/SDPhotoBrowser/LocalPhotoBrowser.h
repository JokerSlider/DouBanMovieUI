//
//  LocalPhotoBrowser.h
//  CSchool
//
//  Created by mac on 17/3/9.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDButton, LocalPhotoBrowser;
@protocol LocalPhotoBrowserDelegate <NSObject>

@required

- (NSString *)photoBrowser:(LocalPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@end
@interface LocalPhotoBrowser : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic,assign)NSInteger  currentMaxsNum;//当前页面照片数组的最大值
@property (nonatomic, strong) NSMutableArray* imageArray;
@property (nonatomic, strong) NSArray* superViewArray;

@property (nonatomic, weak) id<LocalPhotoBrowserDelegate> delegate;

- (void)show;

@end
