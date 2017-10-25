//
//  OAToolView.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAToolView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+UIViewController.h"
#import "YLButton.h"
@implementation OAToolView
{
    YLButton *_nameFilter;//名称筛选
    
    YLButton *_stateFilter;//状态筛选
    
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        [self createView];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = Base_Color2.CGColor;
        self.layer.borderWidth = 0.5;
    }
    return self;
}
/// 创建视图
-(void)createView
{
    _nameFilter = ({
        YLButton *view = [YLButton buttonWithType:UIButtonTypeCustom];
        view.imageRect = CGRectMake(kScreenWidth/2-10, 35-10, 10, 10);
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        [view setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
        [view setTitle:@"名称筛选" forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"OA_shaixuan"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(filterByName:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    UIView *lineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(220, 220, 220);
        view;
    });
    UIView *lineView2 = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(220, 220, 220);
        view;
    });
    _stateFilter = ({
        YLButton *view = [YLButton buttonWithType:UIButtonTypeCustom];
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        view.imageRect = CGRectMake(kScreenWidth/2-10, 35-10, 10, 10);
        [view setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
        [view setTitle:@"状态筛选" forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"OA_shaixuan"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(filterByState:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self sd_addSubviews:@[_nameFilter,_stateFilter,lineView,lineView2]];
    _nameFilter.sd_layout.leftSpaceToView(self,0).heightIs(35).topSpaceToView(self,0).widthIs(kScreenWidth/2);
    lineView.sd_layout.leftSpaceToView(_nameFilter,0).topSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(0.5);
    
    
    _stateFilter.sd_layout.rightSpaceToView(self,0).heightIs(35).topSpaceToView(self,0).widthIs(kScreenWidth/2);
    lineView2.sd_layout.rightSpaceToView(_stateFilter,0).topSpaceToView(self,0).bottomSpaceToView(self,0).widthIs(0.5);
    
}
//通过名字筛选
-(void)filterByName:(UIButton *)sender
{
    if (self.delegate&&[self respondsToSelector:@selector(filterByName:)]) {
        [self.delegate filterDataByName];
    }
}
//通过状态筛选  已处理 or   未处理
-(void)filterByState:(UIButton *)sender
{
    if (self.delegate&&[self respondsToSelector:@selector(filterByState:)]) {
        [self.delegate filerDataByState];
    }
}

@end
