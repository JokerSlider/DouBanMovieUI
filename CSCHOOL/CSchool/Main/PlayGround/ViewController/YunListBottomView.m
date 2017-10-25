//
//  YunListBottomView.m
//  CSchool
//
//  Created by 左俊鑫 on 17/4/27.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunListBottomView.h"
#import "YLButton.h"
#import "SDAutoLayout.h"

@implementation YunListBottomView
{
    YLButton *_shareButton;
    YLButton *_downButton;
    YLButton *_deleteButton;
    YLButton *_moreButton;
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
        [self creataViews];
    }
    return self;
}

- (void)creataViews{
    self.clipsToBounds = YES;
    self.backgroundColor = RGB(246,246,246);
    _shareButton = [self createYLButton];
    [_shareButton setImage:[UIImage imageNamed:@"pan_share"] forState:UIControlStateNormal];
    _shareButton.tag = 1;
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    
    _downButton = [self createYLButton];
    [_downButton setImage:[UIImage imageNamed:@"pan_download.png"] forState:UIControlStateNormal];
    _downButton.tag = 2;
    [_downButton setTitle:@"下载" forState:UIControlStateNormal];
    
    _deleteButton = [self createYLButton];
    [_deleteButton setImage:[UIImage imageNamed:@"pan_del"] forState:UIControlStateNormal];
    _deleteButton.tag = 3;
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    
    _moreButton = [self createYLButton];
    [_moreButton setImage:[UIImage imageNamed:@"pan_more"] forState:UIControlStateNormal];
    _moreButton.tag = 4;
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    
    [self sd_addSubviews:@[_shareButton, _downButton, _deleteButton, _moreButton]];
    float space = (kScreenWidth-(30*4))/5;
    
    for (int i =0; i<4; i++) {
        YLButton *btn = @[_shareButton, _downButton, _deleteButton, _moreButton][i];
        btn.frame = CGRectMake((space+30)*i+space, 0, 30, 50);
    }
}

- (YLButton *)createYLButton{
    YLButton *button = [YLButton buttonWithType:UIButtonTypeCustom];
    button.imageRect = CGRectMake(7, 9, 16, 16);
    button.titleRect = CGRectMake(0, 30, 30, 12);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:Color_Black forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClick:(UIButton *)sender{
    if (_bottomClick) {
        _bottomClick(sender);
    }
}

@end
