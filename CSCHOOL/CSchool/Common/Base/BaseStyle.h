//
//  BaseStyle.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Title_Font [UIFont systemFontOfSize:13]
#define Small_TitleFont [UIFont systemFontOfSize:11]
#define Title_Color1 RGB(165, 190, 68) //字体青色
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define Base_Color2 RGB(239, 240, 241) //背景灰色
#define Base_Color3 RGB(214, 215, 216)  //下一步不可选中灰色
#define Base_Orange RGB(237,120,14)   //主题橙色
#define Color_Black RGB(51,51,51) //字体黑色
#define Color_Gray RGB(128,128,128)  //字体灰色
#define Color_Hilighted RGB(206, 104, 10)//点击后的颜色
#define RAND_COLOR [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
//适配用到的内容
#define xScreenHeight        ([[UIScreen mainScreen] bounds].size.height)/568 //获取屏幕高度，兼容性测试
#define xScreenWidth         ([[UIScreen mainScreen] bounds].size.width)/375 //获取屏幕宽度，兼容性测试
#define x6ScreenHeight        ([[UIScreen mainScreen] bounds].size.height)/667

#define LayoutHeightCGFloat(size)  (size)*xScreenHeight
#define LayoutWidthCGFloat(size)   (size)*xScreenWidth
#define NewLayoutHeightCGFloat(size)  (size)*x6ScreenHeight

//系统的版本号
#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define kWidthGrid  (kScreenWidth/7.5)   //周课表中一个格子的宽度


//NSUserDefaults 中的Key常量
#define CURRENTYEAR   @"CURRENTYEAR"
#define CURRENTTERM   @"CURRENTTERM"
#define USERNAME      @"USERNAME"
#define CURRENTWEEK   @"CURRENTWEEK"

#define WEAKSELF   typeof(self) __weak weakSelf = self

@interface BaseStyle : NSObject







@end
