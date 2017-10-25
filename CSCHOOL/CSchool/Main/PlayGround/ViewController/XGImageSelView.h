//
//  XGImageSelView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/10/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIEW_WITH (kScreenWidth-20-10)/3 //单位视图的宽度

typedef void(^DeleteImageBlock)(NSInteger tag);
/**
 *  展示的图片（带删除按钮）
 */
@interface SelImage : UIView

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *delBtn;
@property (nonatomic, copy) DeleteImageBlock deleteBlock;

@end

/**
 *  添加图片组合视图，最多可以添加三张
 */
@interface XGImageSelView : UIView

@property (nonatomic, retain) NSMutableArray *imageListArray; //存放本地添加的图片数组

@property (nonatomic, retain) NSMutableArray *imageIdArray; //存放图片id

@property (nonatomic, retain) NSMutableArray *imageUrlArray; //存放图片URL地址（编辑）

- (void)addImageWithUrl:(NSMutableArray *)thumbLicArray; //根据URL添加图片展示（编辑）

@end
