//
//  UILabel+stringFrame.m
//  CSchool
//  Created by mac on 16/6/20.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "UILabel+stringFrame.h"

@implementation UILabel (stringFrame)
//根据文字字数重设控件宽度
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    self.numberOfLines=0;
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
//计算高度
- (CGSize)boundingRectWithHeightSize:(CGSize)size
{
   
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    self.numberOfLines=0;
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attribute
                                             context:nil].size;
    return retSize;
}

@end
