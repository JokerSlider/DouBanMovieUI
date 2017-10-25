//
//  BenefitCell.m
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BenefitCell.h"
#import "UIView+SDAutoLayout.h"
@implementation BenefitCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    CGFloat bSpace = 10;
    _noticeImageView = [[UIImageView alloc] init];
    UIImage* img=[UIImage imageNamed:@"bg10.png"];//原图
    UIEdgeInsets edge=UIEdgeInsetsMake(25, 25, 25,25);
    //UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
    //UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图
    img= [img resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    _noticeImageView.image=img;
    
    _noticeImageLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = RGB(255, 0, 0);
        view;
    });
    
    [_noticeImageView addSubview:_noticeImageLabel];
    [self.contentView addSubview:_noticeImageView];
    
    _noticeImageLabel.sd_layout
    .leftSpaceToView(_noticeImageView,20)
    .rightSpaceToView(_noticeImageView,15)
    .topSpaceToView(_noticeImageView,20)
    .autoHeightRatio(0);
    [_noticeImageView setupAutoHeightWithBottomView:_noticeImageLabel bottomMargin:10];
    
    _noticeImageView.sd_layout
    .leftSpaceToView(self.contentView,bSpace)
    .topSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,bSpace);
    [self setupAutoHeightWithBottomView:_noticeImageView bottomMargin:10];
}
-(void)setModel:(PackageModel *)model
{
    _model = model;
    _noticeImageLabel.text =model.discountExplain;
}
@end
