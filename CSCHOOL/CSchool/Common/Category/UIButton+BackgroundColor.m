//
//  UIButton+BackgroundColor.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by 符现超 on 15/5/9.
//  Copyright (c) 2015年 http://weibo.com/u/1655766025 All rights reserved.
//

#import "UIButton+BackgroundColor.h"
#import <objc/runtime.h>

static NSString *descripInfoKey = @"descripInfo";

@implementation UIButton (BackgroundColor)


-(void)setDescripInfo:(NSString *)descripInfo{
//    self.descripInfo = descripInfo;
    objc_setAssociatedObject(self, &descripInfoKey, descripInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)descripInfo{
    return objc_getAssociatedObject(self, &descripInfoKey);
}
/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
