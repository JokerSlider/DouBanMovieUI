//
//  AllEmployButton.m
//  CSchool
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "AllEmployButton.h"

@implementation AllEmployButton
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    titleF.origin.x = self.frame.size.width/2.5;
    self.titleLabel.frame = titleF;
    imageF.origin.x = CGRectGetMaxX(titleF);
    self.imageView.frame = imageF;
}

@end
