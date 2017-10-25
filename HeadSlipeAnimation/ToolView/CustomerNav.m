//
//  CustomerNav.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "CustomerNav.h"
@implementation CustomerNav
{
    UIButton *_leftBtn;//左侧按钮
    UIButton *_rightBtn;
    UILabel  *_titleL;//标题
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, KscreenWidth, 64);
        [self createView];
    }
    return self;
}
//创建视图
-(void)createView
{
    _leftBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(10, self.center.y, 32, 32);
        [view setImage:[UIImage imageNamed:_leftImage] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    _rightBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(KscreenWidth-10-32, self.center.y, 32, 32);
        [view addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setImage:[UIImage imageNamed:_leftImage] forState:UIControlStateNormal];
        view;
    });
    
    _titleL = ({
        UILabel *view = [UILabel new];
        view.frame = CGRectMake((KscreenWidth-100)/2, self.center.y, 100, 30);
        view.font = [UIFont systemFontOfSize:16];
        view.textColor = _titleColor;
        view.textAlignment  = NSTextAlignmentCenter;
        view.text = _title;
        view;
    });
    [self addSubview:_leftBtn];
    [self addSubview:_rightBtn];
    [self addSubview:_titleL];
}
#pragma setter & getter
-(void)setLeftImage:(NSString *)leftImage
{
    _leftImage = leftImage;
    [_leftBtn setImage:[UIImage imageNamed:_leftImage] forState:UIControlStateNormal];

}
-(void)setRightImage:(NSString *)rightImage
{
    _rightImage = rightImage ;
    [_rightBtn setImage:[UIImage imageNamed:_rightImage] forState:UIControlStateNormal];

}
-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleL.text = title;
}
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleL.textColor = titleColor;
}
#pragma mark  delegate 
-(void)leftAction:(UIButton *)sender
{
    if (self.delegate&&[self respondsToSelector:@selector(leftAction:)]) {
        [self.delegate leftBtnAction:sender];
    }
}
-(void)rightAction:(UIButton *)sender
{
    if (self.delegate&&[self respondsToSelector:@selector(rightAction:)]) {
        [self.delegate rightBtnAction:sender];
    }
}





@end
