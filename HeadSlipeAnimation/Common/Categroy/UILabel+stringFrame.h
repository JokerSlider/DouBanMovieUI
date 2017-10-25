//
//  UILabel+stringFrame.h
//  CSchool
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (stringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size;
- (CGSize)boundingRectWithHeightSize:(CGSize)size;

@end
