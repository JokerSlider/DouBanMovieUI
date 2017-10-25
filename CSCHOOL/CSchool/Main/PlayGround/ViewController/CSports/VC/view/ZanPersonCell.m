//
//  ZanPersonCell.m
//  CSchool
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ZanPersonCell.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZanPersonCell
{
    UIImageView *_picImage;
    UILabel     *_nickName;
    UILabel     *_stepNum;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView
{
    _picImage = ({
        UIImageView *view = [UIImageView new];
        view.clipsToBounds = YES;
        view.layer.cornerRadius = 51/2;
        view;
    });
    _nickName = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    _stepNum = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(102, 102, 102);
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_picImage,_nickName,_stepNum]];
    _picImage.sd_layout.leftSpaceToView(contentView,13).topSpaceToView(contentView,9).widthIs(51).heightIs(51);
    _nickName.sd_layout.leftSpaceToView(_picImage,11).topSpaceToView(contentView,28).heightIs(15).widthIs(75);
    _stepNum.sd_layout.rightSpaceToView(contentView,13).topSpaceToView(contentView,28).widthIs(100).heightIs(15);
    [self setupAutoHeightWithBottomView:_picImage bottomMargin:10];
}
-(void)setModel:(SportModel *)model
{
    _model = model;
    _nickName.text = model.XM;
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.TXDZ stringByReplacingOccurrencesOfString:breakString withString:@""];
    [_picImage sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"rentou"]];
    _stepNum.text =[NSString stringWithFormat:@"%@步",model.UMISTEPNUMBER];
    
    CGSize size = [_stepNum boundingRectWithSize:CGSizeMake(0, 15)];
    _stepNum.sd_layout.widthIs(size.width);
    size = [_nickName boundingRectWithSize:CGSizeMake(0, 15)];
    _nickName.sd_layout.widthIs(size.width);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
