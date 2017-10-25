//
//  OAPushFooterView.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAPushFooterView.h"
#import "UIView+SDAutoLayout.h"
@implementation OAPushFooterView
{
    UILabel *_noticeL;//提示
    UIButton *_pushBth;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
        self.backgroundColor = Base_Color2  ;
    }
    return self;
}

-(void)createView
{
    _noticeL = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(237, 120, 14);
        view.font = [UIFont systemFontOfSize:12.0];
        view.text = @"* 是必填项";
        view;
    });
    
    _pushBth = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = RGB(237, 120, 14);
        [view setTitle:@"选择节点" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(pushSucess:) forControlEvents:UIControlEventTouchUpInside];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:17.0];
        view.layer.cornerRadius = 5;
        view;
    });
    
    [self sd_addSubviews:@[_noticeL,_pushBth]];
    _noticeL.sd_layout.leftSpaceToView(self,14).topSpaceToView(self,12).heightIs(12).rightSpaceToView(self,0);
    _pushBth.sd_layout.leftSpaceToView(self,12).rightSpaceToView(self,12).heightIs(40).topSpaceToView(_noticeL,10);
    
}
-(void)pushSucess:(UIButton *)sender
{
    if (self.delegate && [self respondsToSelector:@selector(pushSucess:)]) {
        [self.delegate pushProdure:sender];
    }
}
@end
