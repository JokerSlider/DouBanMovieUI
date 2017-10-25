//
//  NewsPhotoBroweer.m
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "NewsPhotoBroweer.h"

#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDPhotoBrowser.h"
@interface NewsPhotoBroweer ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;
@property (nonatomic ,strong)  UIImageView *LoopimageView;
@end

@implementation NewsPhotoBroweer

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 3; i++) {
        _LoopimageView = [UIImageView new];
        [self addSubview:_LoopimageView];
        _LoopimageView.userInteractionEnabled = NO;
        _LoopimageView.tag = i;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
//        [_LoopimageView addGestureRecognizer:tap];
        [temp addObject:_LoopimageView];
    }
    
    self.imageViewsArray = [temp copy];
}
-(void)setPicArray:(NSArray *)picArray
{
    _picArray = picArray;
    
    if (_picArray.count == 0) {
        self.height_sd = 0;
        self.fixedHeight = @(0);
        return;
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *dic in _picArray) {
        [arr addObject:dic];
    }
    _picArray = arr;
    for (long i = _picArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    
    //获取高度
    CGFloat itemW = [self itemWidthForPicPathArray:_picArray];
    CGFloat itemH = 0;
    if (_picArray.count == 1) {
        [self.LoopimageView sd_setImageWithURL:_picArray.firstObject placeholderImage:[UIImage imageNamed:@"placdeImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        UIImage *image =self.LoopimageView.image;
        if (image.size.width) {
            itemH =  itemW*0.51;
        }
    } else {
        itemH = itemW*0.61;
    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picArray];
    CGFloat margin = 10;
    
    [_picArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        
        NSURL *url = [NSURL URLWithString:obj];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placdeImage"]];
        imageView.frame = CGRectMake(columnIndex * (itemW + 5), rowIndex * (itemH + margin), itemW, itemH);
        if (idx>_picArray.count) {
            *stop=YES;
        }
    }];
    
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width_sd = w+10;
    self.height_sd = h+10;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w+30);
    
}
#pragma mark - private actions
//外部代理设定
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.sourceImagesContainerView = self; // 原图的父控件
//    browser.imageCount = _picArray.count; // 图片总数
//    browser.currentImageIndex = tap.view.tag;
//    browser.delegate = self;
//    [browser show];
    
    
}
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
    
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return self.picArray[index] ;
//    NSString *urlStr = [self.picArray[index] stringByReplacingOccurrencesOfString:_breakString  withString:@""];
//    return [NSURL URLWithString:urlStr];
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return kScreenWidth-30;
    } else {
        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? (kScreenWidth-50)/3 : (kScreenWidth-50)/3;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
        if (array.count <=3) {
            return array.count;
        } else if (array.count <= 4) {
            return 2;
        } else {
            return 3;
        }
//    return  array.count;
}


@end
