//
//  LFUIbutton.m
//  CSchool
//
//  Created by mac on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LFUIbutton.h"

@implementation LFUIbutton

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    titleF.origin.x = 0;
    self.titleLabel.frame = titleF;
    imageF.origin.x = CGRectGetMaxX(titleF);
    self.imageView.frame = imageF;
}

@end
