//
//  XGButton.h
//  CSchool
//
//  Created by 左俊鑫 on 16/4/14.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XGButtonState){
    XGButtonStateNomal /**< 普通状态 */,
    XGButtonStateSelected /**< 选中状态 */,
};

typedef NS_ENUM(NSUInteger, XGButtonStyle){
    XGButtonStyleUpDown /**< 上图下文 */,
};

typedef void(^XGButtonClick)(NSInteger buttonTag);

@interface XGButton : UIView

@property (nonatomic, copy) UIImageView *imageView; /**< 图片 */
@property (nonatomic, copy) UILabel *titleLabel; /**< 标题 */

@property (nonatomic, assign) BOOL selected;

/**
 *  初始化按钮
 *
 *  @param frame
 *  @param style 样式
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame withStyle:(XGButtonStyle)style;

/**
 *  为按钮设置文字、图片和状态
 *
 *  @param title     标题
 *  @param imageName 图片名称
 *  @param state     状态
 */
- (void)setTitle:(NSString *)title image:(NSString *)imageName withXGButtonState:(XGButtonState)state;

@property (nonatomic, strong) XGButtonClick xgButtonClick;

@end
