//
//  DanMuView.m
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "DanMuView.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DanMuView
{
    UIImageView *_backImageV;
    UIImageView *_picImageV;
    UILabel     *_nickName;
    UILabel     *_danmuInfo;
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
    self.layer.cornerRadius =15;
    self.backgroundColor = RGB(245, 245, 245);
    _picImageV = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.cornerRadius = 25/2;
        view.clipsToBounds = YES;
        view;
    });
    _nickName = ({
        UILabel *view =[UILabel new];
        view.textColor = RGB(94, 94, 94);
        view.font = [UIFont systemFontOfSize:9];
        view;
    });
    _danmuInfo = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0];
        view;
    });
    [self sd_addSubviews:@[_picImageV,_nickName,_danmuInfo]];
    _picImageV.sd_layout.leftSpaceToView(_backImageV,1).topSpaceToView(_backImageV,3).widthIs(25).heightIs(25);
    _nickName.sd_layout.leftSpaceToView(_picImageV,1).topSpaceToView (_backImageV,5).widthIs(75).heightIs(8);
    _danmuInfo.sd_layout.leftSpaceToView(_picImageV,5).topSpaceToView (_nickName,1).heightIs(15).widthIs(120);
    [self setupAutoWidthWithRightView:_danmuInfo rightMargin:20];
}
-(void)setModel:(SportModel *)model
{
    _model = model;
    _danmuInfo.text = model.SMICONTENT;
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.TXDZ  stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_picImageV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"rentou"]];
    _nickName.text = model.NC;

    CGSize size = [_danmuInfo boundingRectWithSize:CGSizeMake(0, 12)];
    _danmuInfo.sd_layout.widthIs(size.width);
    size = [_nickName boundingRectWithSize:CGSizeMake(0, 8)];
    _nickName.sd_layout.widthIs(size.width);
    if(_danmuInfo.frame.size.width<_nickName.frame.size.width){
        [self setupAutoWidthWithRightView:_nickName rightMargin:15];
 
    }
}
@end
