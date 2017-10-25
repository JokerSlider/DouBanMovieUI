//
//  WifiClassView.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WifiClassView.h"
#import "UIView+SDAutoLayout.h"
@implementation WifiClassView
{
    UILabel *_titleL;

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
    _titleL = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    _deleteBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"wifi_add"] forState:UIControlStateNormal];
        view;
    });
    
    [self addSubview:_titleL];
    [self addSubview:_deleteBtn];
    
    _titleL.sd_layout.leftSpaceToView(self,0).widthIs(100).heightIs(15).topSpaceToView(self,0);
    _deleteBtn.sd_layout.rightSpaceToView(self,125).heightIs(15).widthIs(15).topSpaceToView(self,0);
}
-(void)setModel:(WIFICellModel *)model
{
    _model = model;
    [_titleL setText:model.title];
    
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 15)];
    _titleL.sd_layout.widthIs(size.width);
}
-(void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    if (!_isEdit) {
        _deleteBtn.hidden = YES;
    }
}
@end
