//
//  YunUploadBottomView.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/18.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunUploadBottomView.h"
#import "SDAutoLayout.h"

@implementation YunUploadBottomView
{
    UIView *_percentBacView;
    UILabel *_diskInfoLabel;
    UIView *_percentView;
    UILabel *_titleLabel;
    UIButton *_myYunButton;
    UIButton *_uploadButton;
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
    
    self.backgroundColor = [UIColor whiteColor];
    
    _percentBacView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(225, 225, 225);
        view;
    });
    
    _percentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = Base_Orange;
        view;
    });
    
    _diskInfoLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:9];
        view;
    });
    
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"选择上传位置：";
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    
    _myYunButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [view setTitle:@"我的云盘" forState:UIControlStateNormal];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        view.sd_cornerRadius = @(5);
        view.layer.borderWidth = .5;
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [view addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _uploadButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setTitle:@"上传" forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
        view.sd_cornerRadius = @(5);
        view.layer.borderWidth = .5;
        view.layer.borderColor = Base_Orange.CGColor;
        view;
    });
    
    [self sd_addSubviews:@[_percentBacView, _percentView, _diskInfoLabel, _titleLabel, _myYunButton, _uploadButton]];
    
    _percentBacView.sd_layout
    .leftSpaceToView(self,0)
    .topSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(16);
    
    _diskInfoLabel.sd_layout
    .rightSpaceToView(self,8)
    .topSpaceToView(self,0)
    .widthIs(200)
    .heightIs(16);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(_percentBacView,22)
    .heightIs(15)
    .widthIs(200);
    
    _myYunButton.sd_layout
    .leftSpaceToView(self,10)
    .topSpaceToView(_titleLabel,10)
    .widthIs((kScreenWidth-25)/2)
    .heightIs(31);
    
    _uploadButton.sd_layout
    .rightSpaceToView(self,10)
    .leftSpaceToView(_myYunButton,10)
    .topEqualToView(_myYunButton)
    .heightRatioToView(_myYunButton,1)
    .widthRatioToView(_myYunButton,1);
}

- (void)uploadAction:(UIButton *)sender{
    if (_uploadClick) {
        _uploadClick();
    }
}

- (void)locationAction:(UIButton *)sender{
    if (_locationClick) {
        _locationClick();
    }
}

- (void)setLocationBtnTitle:(NSString *)title{
    if (title.length<1) {
        title = @"我的云盘";
    }
    [_myYunButton setTitle:title forState:UIControlStateNormal];
}

@end
