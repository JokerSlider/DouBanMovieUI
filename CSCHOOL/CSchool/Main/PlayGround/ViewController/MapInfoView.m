//
//  MapInfoView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MapInfoView.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MapInfoView
{
    UIImageView *_picImageView; //图片
    UILabel *_nameLabel;        //名称
    UILabel *_phoneLabel;       //电话
    UILabel *_addressLabel;     //地址
    UILabel *_descripLabel;     //简介，描述
    UIView *_backView;
    UIButton *_goButton;        //到这去 按钮
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews{
    
    _backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _goButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = Base_Orange;
        [view addTarget:self action:@selector(GoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _picImageView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view;
    });
    
    _phoneLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    _addressLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    _descripLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = Color_Gray;
        view;
    });
    
    UIImageView *buttonLogo = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"map_lu"];
        view;
    });
    
    UILabel *goLabel = ({
        UILabel *view = [UILabel new];
        [view setTextColor:[UIColor whiteColor]];
        view.font = [UIFont systemFontOfSize:10];
        view.textAlignment = NSTextAlignmentCenter;
        view.text = @"路线";
        view;
    });
    
    [_goButton addSubview:buttonLogo];
    [_goButton addSubview:goLabel];
    
    
    
    [self addSubview:_backView];
    [self addSubview:_goButton];
    
    _goButton.sd_layout
    .rightSpaceToView(self,15)
    .topSpaceToView(self,0)
    .widthIs(60)
    .heightIs(60);
    
    _goButton.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    _backView.sd_layout
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .topSpaceToView(self,30);
    
    [_backView addSubview:_picImageView];
    [_backView addSubview:_nameLabel];
    [_backView addSubview:_phoneLabel];
    [_backView addSubview:_addressLabel];
    [_backView addSubview:_descripLabel];
    
    
    UIImageView *phoneImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"map_tel"];
        view;
    });
    [_backView addSubview:phoneImageView];
    
    
    UIImageView *addImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"map_dd"];
        view;
    });
    [_backView addSubview:addImageView];
    
    
    _picImageView.sd_layout
    .leftSpaceToView(_backView,2)
    .topSpaceToView(_backView,5)
    .heightIs(90)
    .widthIs(120);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_picImageView,5)
    .topEqualToView(_picImageView)
    .rightSpaceToView(_backView,5)
    .heightIs(30);
    
    phoneImageView.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,10)
    .widthIs(10)
    .heightIs(0);//10
    
    _phoneLabel.sd_layout
    .leftSpaceToView(phoneImageView,3)
    .topSpaceToView(_nameLabel,5)
    .rightEqualToView(_nameLabel)
    .heightIs(0);//20
    
    addImageView.sd_layout
    .leftEqualToView(phoneImageView)
    .topSpaceToView(_phoneLabel,7)
    .widthIs(10)
    .heightIs(10);
    
    _addressLabel.sd_layout
    .leftSpaceToView(addImageView,3)
    .topSpaceToView(_phoneLabel,2)
    .rightEqualToView(_phoneLabel)
    .heightIs(20);
    
    _descripLabel.sd_layout
    .leftSpaceToView(_backView,2)
    .rightSpaceToView(_backView,2)
    .topSpaceToView(_picImageView,5)
    .autoHeightRatio(0);
    
    buttonLogo.sd_layout
    .centerXEqualToView(_goButton)
    .topSpaceToView(_goButton,15)
    .widthIs(15)
    .heightIs(15);
    
    goLabel.sd_layout
    .centerXEqualToView(_goButton)
    .topSpaceToView(buttonLogo,2)
    .widthRatioToView(_goButton,1)
    .heightIs(20);
}

//设置数据字典
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
//    _picImageView.sd_layout.widthIs(0);
    [_picImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"MAIICONURL"]]];
    
    _nameLabel.text = _dataDic[@"MAINAME"];
    _descripLabel.text = _dataDic[@"des"];
    
    _phoneLabel.text = @"";
    _addressLabel.text = _dataDic[@"SDSNAME"];
    
    [_backView setupAutoHeightWithBottomView:_descripLabel bottomMargin:10];
    [self setupAutoHeightWithBottomView:_backView bottomMargin:0];

}

//按钮执行回调
- (void)GoBtnClick:(UIButton *)sender{
    if (_goBtnClickBlock) {
        _goBtnClickBlock(_dataDic);
    }
}

@end
