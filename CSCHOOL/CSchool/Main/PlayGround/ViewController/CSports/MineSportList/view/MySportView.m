//
//  MySportView.m
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MySportView.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SportInfoViewController.h"
#import "UIView+UIViewController.h"
@implementation MySportView
{
    UIImageView *_picImageV;//头像
    UILabel     *_nickNameL;//昵称
    UILabel     *_numberL;//排名
    
    UILabel     *_stepNum;//步数
    UIButton    *_zanBtn;//赞我的人
    UILabel     *_zanNumLabel;//赞的次数
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openInfoVC)];
    
    [self addGestureRecognizer:gesture];
    
    self.backgroundColor = [UIColor whiteColor];
    _picImageV = ({
        UIImageView *view = [[UIImageView alloc]init];
        view.clipsToBounds = YES;
        view.image = [UIImage imageNamed:@"rentou"];
        view.layer.cornerRadius = 40/2;
        view;
    });
    _nickNameL = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    _numberL = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(134, 133, 133);
        view.font = [UIFont systemFontOfSize:12.0f];
        view;
    });
    _stepNum = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(237, 120, 14);
        view.font = [UIFont systemFontOfSize:24.0f];
        view;
    });
    _zanBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"sport_ZanOrange"] forState:UIControlStateNormal];
        view;
    });
    _zanNumLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(211, 211, 211);
        view.font = [UIFont systemFontOfSize:15.0];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });

    [self sd_addSubviews:@[_picImageV,_nickNameL,_numberL,_stepNum,_zanBtn,_zanNumLabel]];
    _picImageV.sd_layout.leftSpaceToView(self,14).topSpaceToView(self,11).widthIs(40).heightIs(40);
    _nickNameL.sd_layout.leftSpaceToView(_picImageV,11).topSpaceToView(self,11).widthIs(45).heightIs(15);
    _numberL.sd_layout.leftEqualToView(_nickNameL).topSpaceToView(_nickNameL,10).heightIs(12).widthIs(50);
    _zanNumLabel.sd_layout.rightSpaceToView(self,12).topSpaceToView(self,11).widthIs(18).heightIs(13);
    _zanBtn.sd_layout.rightSpaceToView(self,14).topSpaceToView(_zanNumLabel,5).widthIs(17).heightIs(16);
    
    _stepNum.sd_layout.rightSpaceToView(_zanBtn,25).topSpaceToView(self,24).widthIs(100).heightIs(19);
}
-(void)setModel:(SportModel *)model
{
    _model = model;
    _nickNameL.text = model.xm?model.xm:[AppUserIndex GetInstance].nickName;
    _numberL.text = [NSString stringWithFormat:@"第%@名", model.pm?model.pm:@"1"];
    _stepNum.text = model.umi_stepnumber;
    _zanNumLabel.text = model.count?model.count:@"0";
    
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.txdz  stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_picImageV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"rentou"]];
    CGSize size = [_stepNum boundingRectWithSize:CGSizeMake(0, 15)];
    _stepNum.sd_layout.widthIs(size.width);
    size = [_nickNameL boundingRectWithSize:CGSizeMake(0, 15)];
    _nickNameL.sd_layout.widthIs(size.width);
    size = [_zanNumLabel boundingRectWithSize:CGSizeMake(0, 35)];
    if (size.width>_zanNumLabel.width) {
        _zanNumLabel.sd_layout.widthIs(size.width);
        _zanNumLabel.sd_layout.rightSpaceToView(self, 6);
        [self updateLayoutWithCellContentView:_zanNumLabel];
    }
}
-(void)openInfoVC{
    SportInfoViewController *vc = [[SportInfoViewController alloc]init];
    vc.userID = _model.yhbh;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
@end
