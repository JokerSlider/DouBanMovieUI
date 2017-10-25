//
//  OAHeadView.m
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAHeadView.h"
#import "OAButtonView.h"
@implementation OAHeadView


-(instancetype)initWithButtonArry:(NSArray *)buttonArr
{
    if (self = [super init]) {
        [self createView:buttonArr];
        self.frame = CGRectMake(0, 0, kScreenWidth, 80);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
//创建视图
-(void)createView:(NSArray *)buttonArry
{
    for (int i = 0; i<buttonArry.count; i++) {
        OAButtonView *view = [[OAButtonView alloc]initWithFrame:CGRectMake(10+i*(42+35),15, 80, 60)];
        view.tag = i;
        view.model = buttonArry[i];
        [self addSubview:view];
    }
   
}
@end
