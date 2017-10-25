//
//  PhotoWallDetailView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhotoWallDetailView.h"
#import "SDAutoLayout.h"
#import "UILabel+stringFrame.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhotoCarView.h"
#import "UIView+UIViewController.h"
#import "SendFlowerView.h"

@implementation PhotoWallDetailView

{
    UIImageView *_picView;
    
    UIView *_bootomView;
    UIImageView *_headerView;
    UILabel *_nameLabel;
    UILabel *_schoolLabel;
    UIImageView *_sexImageView;
    UIImageView *_flowerImageView;
    UILabel *_flowerNumLabel;
    UIView *_flowerBacView;
    UIButton *_flowerBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _picView = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view;
    });
    
    _bootomView = ({
        UIView *view = [UIView new];
        view;
    });
    
    [self sd_addSubviews:@[_picView, _bootomView]];
    
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(51, 51, 51);
        view.font = [UIFont systemFontOfSize:15];
        view.textAlignment = NSTextAlignmentLeft;
        view;
    });
    
    _schoolLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(153, 153, 153);
        view.font = [UIFont systemFontOfSize:12];
        
        view;
    });
    
    _flowerNumLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = Base_Orange;
        view.font = [UIFont systemFontOfSize:17];
        view.text = @"0";
        view.textAlignment = NSTextAlignmentRight;
        view;
    });
    
    _headerView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _sexImageView = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    
    _flowerImageView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"photoWall_flower_s"];
        view;
    });
    
    _flowerBtn = ({
        UIButton *flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [flowerBtn setImage:[UIImage imageNamed:@"photoWall_flower_btn"] forState:UIControlStateNormal];
        [flowerBtn addTarget:self action:@selector(sendFlowerAction:) forControlEvents:UIControlEventTouchUpInside];
        flowerBtn;
    });
    
    _flowerBacView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
        view;
    });
    
    [_bootomView sd_addSubviews:@[_nameLabel, _schoolLabel,  _headerView, _sexImageView, _flowerBtn]];
    
    [_picView addSubview:_flowerBacView];
    
    [_flowerBacView sd_addSubviews:@[_flowerImageView, _flowerNumLabel,]];
    
    _picView.backgroundColor = [UIColor redColor];
    _bootomView.backgroundColor = [UIColor whiteColor];
    
    [self cc_layoutSubviews];
}

- (void)cc_layoutSubviews {
    
    CGFloat bootomHeight = self.frame.size.height*(10.0/45.0);
    
    _picView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    _bootomView.frame = CGRectMake(0, self.frame.size.width, self.frame.size.width,self.height*0.2);
    _headerView.sd_layout
    .leftSpaceToView(_bootomView,17)
    .centerYEqualToView(_bootomView)
    .widthIs(LayoutHeightCGFloat(40))
    .heightIs(LayoutHeightCGFloat(40));
    _headerView.sd_cornerRadius = @(LayoutHeightCGFloat(20));
    
    _nameLabel.sd_layout
    .leftSpaceToView(_bootomView,10+LayoutHeightCGFloat(40)+17)
    .topSpaceToView(_bootomView, (bootomHeight -LayoutHeightCGFloat(40))/2)
    .heightIs(LayoutHeightCGFloat(14))
    .maxWidthIs(200);
    
    _schoolLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .heightIs(LayoutHeightCGFloat(12))
    .widthIs(180)
    .bottomEqualToView(_headerView);
    
    _sexImageView.sd_layout
    .leftSpaceToView(_nameLabel,2)
    .centerYEqualToView(_nameLabel)
    .widthIs(17)
    .heightIs(17);
    
    _flowerBtn.sd_layout
    .rightSpaceToView(_bootomView, 23)
    .centerYEqualToView(_bootomView)
    .widthIs(LayoutHeightCGFloat(51))
    .heightIs(LayoutHeightCGFloat(51));
    
    _flowerBacView.sd_layout
    .rightSpaceToView(_picView,8)
    .bottomSpaceToView(_picView,14)
    .heightIs(31);
    
    _flowerBacView.sd_cornerRadius = @(15);
    
    _flowerImageView.sd_layout
    .leftSpaceToView(_flowerBacView,8)
    .centerYEqualToView(_flowerBacView)
    .widthIs(18)
    .heightIs(21);
    
    _flowerNumLabel.sd_layout
    .rightSpaceToView(_flowerBacView,8)
    .centerYEqualToView(_flowerBacView)
    .maxWidthIs(200)
    .heightIs(13);
}

-(void)setModel:(PhotoCarModel *)model{
    _model = model;
    
    _nameLabel.text = _model.name;
    CGSize size=[_nameLabel boundingRectWithSize:CGSizeMake(0, 21)];
    _nameLabel.sd_layout.widthIs(size.width);
    
    _flowerNumLabel.text = _model.flowerNum;
    CGSize size1=[_flowerNumLabel boundingRectWithSize:CGSizeMake(0, 21)];
    _flowerNumLabel.sd_layout.widthIs(size1.width);
    
    _flowerBacView.sd_layout.widthIs(size1.width+40);
    
    _schoolLabel.text = _model.school;
    
    _sexImageView.image = ([_model.userSex isEqualToString:@"1"])?[UIImage imageNamed:@"photoWall_boy"]:(([_model.userSex isEqualToString:@"2"]?[UIImage imageNamed:@"photoWall_girl"]:[UIImage imageNamed:@""]));
    
    [_picView sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:PlaceHolder_Image];
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_model.headerUrl] placeholderImage:PlaceHolder_Image];

}

- (void)sendFlowerAction:(UIButton *)sender{
    SendFlowerView *view = [[SendFlowerView alloc] init];
    view.model = _model;
    view.sendFlowerBlock = ^(SendFlowerView *view, PhotoCarModel *model){
        self.model = model;
    };
    [self.viewController.view addSubview:view];
}

@end
