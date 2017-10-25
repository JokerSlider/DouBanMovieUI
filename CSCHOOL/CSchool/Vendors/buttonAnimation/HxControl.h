//
//  HxControl.h
//  工厂
//
//  Created by 黄鑫 on 15/9/6.
//  Copyright (c) 2015年 HxProduct. All rights reserved.
//
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HxControl : NSObject

// 单例宏(.h文件)
#define HxSingletonH + (instancetype)sharedInstance;
// 单例宏(.m文件)
#define HxSingletonM \
static hxdanli *_hxdanli; \
 \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _hxdanli = [super allocWithZone:zone]; \
    }); \
    return _hxdanli; \
} \
 \
+ (instancetype)shareHX \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _hxdanli = [[self alloc] init]; \
    }); \
    return _hxdanli; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
    return _hxdanli; \
} // 防止对象copy，引发单例失效


/**
 ********************************************** 基础控件封装 *********************************************
 */
#pragma mark - Label
+ (UILabel *)createLabelWith:(NSString *)text textColor:(UIColor *)textColor frame:(CGRect)frame font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor textAlignment:(NSTextAlignment)textAlignment userInteractionEnabled:(BOOL)userInteractionEnabled adjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth;
#pragma mark - ImageView
+ (UIImageView *)createImageViewWith:(NSString *)imageName frame:(CGRect)frame userInteractionEnabled:(BOOL)userInteractionEnabled;
#pragma mark - Button
+ (UIButton *)createButtonWith:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target sel:(SEL)sel event:(UIControlEvents)event backGroundImage:(NSString *)backGroundImage image:(NSString *)imageName backGroundColor:(UIColor *)color font:(UIFont *)font frame:(CGRect)frame setUserInteractionEnabled:(BOOL)setUserInteractionEnabled buttonWithType:(UIButtonType)buttonWithType;
#pragma mark - UITextView
+ (UITextView *)createTextViewWith:(NSString *)text textColor:(UIColor *)textColor frame:(CGRect)frame font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor keyboardType:(UIKeyboardType)keyboardType scrollEnabled:(BOOL)scrollEnabled autoresizingMask:(UIViewAutoresizing)UIViewAutoresizingFlexibleHeight textAlignment:(NSTextAlignment)textAlignment editable:(BOOL)editable;
#pragma mark - UITextField
+ (UITextField *)createTextFileWith:(UIColor *)textColor frame:(CGRect)frame font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor borderStyle:(UITextBorderStyle)borderStyle keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder secureTextEntry:(BOOL)secureTextEntry clearButtonMode:(UITextFieldViewMode)clearButtonMode autoresizingMask:(UIViewAutoresizing)autoresizingMask setEnabled:(BOOL)setEnabled;
#pragma mark - 创建UISlider
+ (UISlider *)createSliderWith:(CGRect)frame userInteractionEnabled:(BOOL)userInteractionEnabled value:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue target:(id)target sel:(SEL)sel event:(UIControlEvents)event backGroundColor:(UIColor *)backGroundColor continuous:(BOOL)continuous minimumTrackTintColor:(UIColor *)minimumTrackTintColor maximumTrackTintColor:(UIColor *)maximumTrackTintColor thumbTintColor:(UIColor *)thumbTintColor;
#pragma mark - 判断是否为电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
#pragma mark - 更新版计算产品详情uilable自适应高度,把label传过来
+ (CGSize)newLabelHeightNumber:(UILabel *)label;

/**
 ********************************************** 根据项目封装基础属性 *********************************************
 */
#pragma mark - 导航栏

+ (UIFont *)navigationBarTitleViewFont;      // 标题字体

+ (UIFont *)navigationBarItemFont;           // 左右两边字体

+ (UIFont *)navigationBarTitleColor;         // 标题颜色

#pragma mark - 详情大标题

+ (UIFont *)detailBigTitleFont;              // 详情大标题字体

+ (UIColor *)detailBigTitleColor;            // 详情大标题字体颜色

#pragma mark - 全局字号+列表标题+详情正文
+ (UIFont *)listTitleAndDetailTextFont;      // 字体

+ (UIColor *)listTitleAndDetailTextColor;    // 颜色

#pragma mark - 基本字号+标题下的辅助文字

+ (UIFont *)baseAndTitleAssociateTextFont;   // 字体

+ (UIColor *)baseAndTitleAssociateTextColor; // 颜色

#pragma mark - 主题色彩 +辅助色彩 +页面底色

+ (UIColor *)mainThemeColor;

+ (UIColor *)mainAssociateColor;

+ (UIColor *)mainBackgroundColor;

#pragma mark - 点击态

+ (UIColor *)tapHighlightColor;

#pragma mark - 分割线

+ (UIColor *)mainSeprateLineColor;

#pragma mark - 男士 女士 年龄颜色

+ (UIColor *)manAgeColor;

+ (UIColor *)womenAgeColor;

#pragma mark - 返回一个箭头view
+ (UIImageView*)accessoryIndicatorView;

#pragma mark - 判断是否为整形
+ (BOOL)isPureInt;

#pragma mark - 判断是否为浮点形
+ (BOOL)isPureFloat;


@end
