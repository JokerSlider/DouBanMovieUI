//
//  WIFIEditFooterView.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WIFIEditFooterView.h"
#import "UIView+SDAutoLayout.h"
#import "UIView+UIViewController.h"
#import "TechInitSignViewController.h"

@implementation WIFIEditFooterView
{
    UIButton *_finisBtn ;
    UIButton *_editMsg;//
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
//创建视图
-(void)createView
{
    _finisBtn = ({
        UIButton *view = [UIButton new];
        view.titleLabel.font = [UIFont systemFontOfSize:16.0 ];
        view.backgroundColor = Base_Orange;
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(openStatrtSignVC) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    _editMsg = ({
        UIButton *view = [UIButton new ];
        [view setTitle:@"信息不准确，点此处编辑" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:16.0 ];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(opeenEditView) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self sd_addSubviews:@[_finisBtn,_editMsg]];

    _finisBtn.sd_layout.leftSpaceToView(self,14).rightSpaceToView(self,14).heightIs(41).bottomSpaceToView(self,20);
    _editMsg.sd_layout.rightSpaceToView(self,15).topSpaceToView(self,21).heightIs(15).widthIs(200);
    
}
-(void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    if (_isEdit) {
        [_finisBtn setTitle:@"完成" forState:UIControlStateNormal];
        _editMsg.hidden = YES;
    }else{
        [_finisBtn setTitle:@"开始签到" forState:UIControlStateNormal];

    }
}
-(void)opeenEditView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(openEditViewController)]) {
        [self.delegate openEditViewController];
    }
}
-(void)openStatrtSignVC{
    if (!_isEdit) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(openStartSignViewController)]) {
            [self.delegate openStartSignViewController];
        }
    
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(openSureViewController)]) {
            [self.delegate openSureViewController];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
