//
//  PriseAlertView.m
//  CSchool
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "PriseAlertView.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation PriseAlertView
{
    UIView      *_backView;
    UIView      *_infoBackView;
    UIImageView *_titleImageV;//标题
    UIImageView *_goodsView;//
    UILabel     *_redeemCodeL;//兑换码
    UILabel     *_prizeNameL;
    UILabel *_noticeL;//提示语
    UIButton    *_closeBtn;//关闭按钮
    
}
- (id)initWithPriseViewwithPriseLevel:(int)level{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

        [self createViewwithLevel:level];
    }
    return self;
}
#pragma mark 创建视图
-(void)createViewwithLevel:(int)level
{
    _backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB_Alpha(0, 0, 0, 0.56);
        view;
    });
    _closeBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"priseClose"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchDown];
        view;
    });
    _infoBackView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(255, 238, 191);
        view;
    });
    _titleImageV = ({
        UIImageView *view = [UIImageView new];
        [view setImage:[UIImage imageNamed:@"priseHistory"]];//中奖纪录
        view;
    });
    _prizeNameL = ({
        UILabel *view = [UILabel new];
        view.textColor  = [UIColor lightGrayColor];
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont fontWithName:@"GeeZaPro" size:15.0];
        view;
    });
    _redeemCodeL = ({
        UILabel *view = [UILabel new];
        view.textColor  = [UIColor lightGrayColor];
        view.textAlignment = NSTextAlignmentCenter;
        view.font = [UIFont fontWithName:@"GeeZaPro" size:15.0];
        view;
    });
    _goodsView = ({
        UIImageView *view = [UIImageView new];
        view.backgroundColor = [UIColor  redColor];
        view.contentMode = UIViewContentModeScaleToFill;
        view.image = [UIImage imageNamed:@"placdeImage"];
        view;
    });
    _noticeL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:18.0];
        view.textColor = RGB(204, 31, 31);
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self addSubview:_backView];
    [_backView sd_addSubviews:@[_closeBtn,_infoBackView]];
    [_infoBackView sd_addSubviews:@[_titleImageV,_goodsView,_noticeL,_prizeNameL,_redeemCodeL]];
    
    _backView.sd_layout.leftSpaceToView(self,0).topSpaceToView(self,0).bottomSpaceToView(self,0).rightSpaceToView(self,0);
    _closeBtn.sd_layout.rightSpaceToView(_backView,90).topSpaceToView(_backView,15).widthIs(30).heightIs(30);
    _infoBackView.sd_layout.centerXIs(self.centerX).topSpaceToView(_backView,110).widthIs(kScreenWidth-40*2).heightIs(kScreenWidth-20*2);
    _titleImageV.sd_layout.centerXIs(_infoBackView.centerX).topSpaceToView(_infoBackView,27).widthIs(130+28*2).heightIs(40);
    
    _prizeNameL.sd_layout.leftSpaceToView(_infoBackView,0).topSpaceToView(_titleImageV,10).rightSpaceToView(_infoBackView,0).autoHeightRatio(0).heightIs(25);
    _redeemCodeL.sd_layout.leftSpaceToView(_infoBackView,0).topSpaceToView(_prizeNameL,10).rightSpaceToView(_infoBackView,0).autoHeightRatio(0).heightIs(25);
    
    _noticeL.sd_layout.leftSpaceToView(_infoBackView,0).bottomSpaceToView(_infoBackView,20).rightSpaceToView(_infoBackView,0).autoHeightRatio(0).heightIs(25);
    _goodsView.sd_layout.centerXIs(_infoBackView.centerX).topSpaceToView(_redeemCodeL,10).widthIs(kScreenWidth-40*4).bottomSpaceToView(_noticeL,10);
}

-(void)setModel:(PriseModel *)model
{
    _model = model;
    NSString *url = [model.awardPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_goodsView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placdeImage"]];
    if (model.awardPic.length==0) {
        _goodsView.hidden = YES;
        _noticeL.sd_layout.leftSpaceToView(_infoBackView,0).topSpaceToView(_redeemCodeL,50).rightSpaceToView(_infoBackView,0).autoHeightRatio(0).heightIs(25);

    }
    _prizeNameL.text = [NSString stringWithFormat:@"奖品名称:%@",model.prizeName];
    _redeemCodeL.text = [NSString stringWithFormat:@"兑换码:%@",model.redeemCode];
    _noticeL.text = model.awardName;
    
}

-(void)closeView
{
    //取消时，放大并且修改透明度  最后移除
    [UIView animateWithDuration:1 animations:^{
        self.transform = CGAffineTransformMakeScale(3, 3);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    /*
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
     */
}
-(void)showView
{


}
@end
