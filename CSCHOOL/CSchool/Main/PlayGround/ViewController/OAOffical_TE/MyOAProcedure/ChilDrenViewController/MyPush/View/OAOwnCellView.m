//
//  OAOwnCellView.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAOwnCellView.h"
#import "UIView+SDAutoLayout.h"
#import "OAModel.h"
@implementation OAOwnCellView
{
    UIImageView *_iconV;
    UILabel     *_titleL;
    UILabel     *_subtitleL;
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
    _iconV = ({
        UIImageView *view = [UIImageView new];
        view;
    });
    _titleL = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font  = [UIFont systemFontOfSize:14];
        view;
    });
    _subtitleL = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(85, 85, 85);
        view.font  = [UIFont systemFontOfSize:14];
        view.textAlignment = NSTextAlignmentRight ;
        view;
    });
    [self sd_addSubviews:@[_iconV,_titleL,_subtitleL]];
    
    _iconV.sd_layout.leftSpaceToView(self,14).topSpaceToView(self,0).widthIs(14).heightIs(14);
    _titleL.sd_layout.leftSpaceToView(_iconV,11).topEqualToView(_iconV).widthIs(100).heightIs(14);
    _subtitleL.sd_layout.rightSpaceToView(self,14).topEqualToView (_iconV).leftSpaceToView(_titleL,10).heightIs(14);
    [self setupAutoHeightWithBottomView:_subtitleL bottomMargin:10];
}
-(void)setModel:(OAModel *)model
{
    _model = model;

    _iconV.image = [UIImage imageNamed:model.imgName];
    _titleL.text = model.title;
    _subtitleL.text = model.subTitle;
    CGSize size = [_titleL boundingRectWithSize:CGSizeMake(0, 14)];
    _titleL.sd_layout.widthIs(size.width);
}
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleL.textColor = titleColor;
    _subtitleL.textColor = titleColor;
    
}
@end
