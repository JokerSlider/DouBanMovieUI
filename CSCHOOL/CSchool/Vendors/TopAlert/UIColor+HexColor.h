//
//  UIColor+HexColor.h
//  CSchool
//
//  Created by mac on 17/6/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*)color;
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
