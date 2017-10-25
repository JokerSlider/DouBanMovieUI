//
//  PayInfoView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/23.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PayInfoView.h"
#import "SDAutoLayout.h"

@implementation PayInfoView
{
    UIView *_infoView;
    UILabel *_mealLabel;
    UILabel *_timeLabel;
    UILabel *_youhuLabel;
    UILabel *_moneyLabel;
    UIButton *_payButton;
}
- (instancetype)init
{
    self = [super init];//[super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews{
    self.clipsToBounds = YES;
    UIView *control = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    control.backgroundColor = RGB(0, 0, 0);
    control.alpha = 0.4;
    [self addSubview:control];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlAction:)];
    [control addGestureRecognizer:tap];
//    [control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventAllEvents];
    [self createInfoView];
}

- (void)createInfoView{
    
    _infoView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    [self addSubview:_infoView];
    
    _infoView.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .bottomEqualToView(self);
    
    UILabel *mealNameLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view.text = @"套餐名：";
        view;
    });
    
    _mealLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    UILabel *timeNameLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view.text = @"时长：";
        view;
    });
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    UILabel *youhuiNameLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view.text = @"优惠说明：";
        view;
    });
    
    _youhuLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    UIView *bottomView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(247, 247, 247);
        view;
    });
    
    [_infoView sd_addSubviews:@[mealNameLabel,_mealLabel,timeNameLabel,_timeLabel,youhuiNameLabel,_youhuLabel,bottomView]];
    
    UILabel *payNameLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _moneyLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _payButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"去支付" forState:UIControlStateNormal];
        [view setBackgroundColor:Base_Orange];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [bottomView sd_addSubviews:@[payNameLabel, _moneyLabel, _payButton]];

    mealNameLabel.sd_layout
    .leftSpaceToView(_infoView,10)
    .topSpaceToView(_infoView,5)
    .widthIs(80)
    .heightIs(25);
    
    _mealLabel.sd_layout
    .leftSpaceToView(mealNameLabel,5)
    .topEqualToView(mealNameLabel)
    .rightSpaceToView(_infoView,5)
    .heightRatioToView(mealNameLabel,1);
    
    timeNameLabel.sd_layout
    .leftEqualToView(mealNameLabel)
    .topSpaceToView(mealNameLabel,5)
    .widthRatioToView(mealNameLabel,1)
    .heightRatioToView(mealNameLabel,1);
    
    _timeLabel.sd_layout
    .leftEqualToView(_mealLabel)
    .topEqualToView(timeNameLabel)
    .rightEqualToView(_mealLabel)
    .heightRatioToView(mealNameLabel,1);
    
    youhuiNameLabel.sd_layout
    .leftEqualToView(mealNameLabel)
    .topSpaceToView(timeNameLabel,5)
    .widthRatioToView(mealNameLabel,1)
    .heightRatioToView(mealNameLabel,1);
    
    _youhuLabel.sd_layout
    .leftEqualToView(_mealLabel)
    .topEqualToView(youhuiNameLabel)
    .rightEqualToView(_mealLabel)
    .autoHeightRatio(0);

    bottomView.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(_youhuLabel,5)
    .heightIs(40);
    
    
    
    
    
    _youhuLabel.text = @"121321315";
    [_infoView setupAutoHeightWithBottomView:youhuiNameLabel bottomMargin:10];

}

- (void)controlAction:(UIControl *)sender{
    self.hidden = YES;
}

- (void)payButtonAction:(UIButton *)sender{
    if (_payBtnClickBlock) {
        _payBtnClickBlock(nil);
    }
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    hidden?(self.sd_layout.heightIs(0)):(self.sd_layout.heightIs(kScreenHeight-64));
    if (_payInfoHiddenBlock&&hidden) {
        _payInfoHiddenBlock();
    }
}

@end
