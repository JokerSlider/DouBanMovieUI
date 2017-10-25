//
//  StandPrice.m
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "StandPrice.h"
#import "UIView+SDAutoLayout.h"
#import "UILabel+stringFrame.h"
@interface  StandPrice()
{
}
@end
@implementation StandPrice
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
-(void)createView
{
    UILabel *priceLabel = ({
        UILabel *view = [UILabel new];
        view.text = @"标准价格:";
        view.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17];
        view.textColor = Color_Black;
        view;
    });
    _priceTitle = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:17];
        view.textColor = Color_Black;
        view;
    });
    _beniftTitle = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = [UIColor redColor];
        view.numberOfLines = 0;
        view;
    });
    _noticeV= ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"at"] forState:UIControlStateNormal] ;
        view;
    });
    [self.contentView addSubview:_beniftTitle];
    [self.contentView addSubview:priceLabel];
    [self.contentView addSubview:_priceTitle];
    [self.contentView addSubview:_noticeV];
    priceLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,20).widthIs(80).heightIs(20);
    _priceTitle.sd_layout.leftSpaceToView(priceLabel,0).topEqualToView(priceLabel).heightIs(20).maxWidthIs(100).widthIs(20);
    _beniftTitle.sd_layout.leftSpaceToView(_priceTitle,0).centerYEqualToView(priceLabel).autoHeightRatio(0).maxWidthIs(kScreenWidth-160).widthIs(20);
    _noticeV.sd_layout.leftSpaceToView(_beniftTitle,0).topEqualToView(priceLabel).widthIs(20).heightIs(20);
}
-(void)setModel:(PackageModel *)model
{
    _model = model;
    _beniftTitle.text = [NSString stringWithFormat:@"(%@)",model.discountDes];
    CGSize size=[_beniftTitle boundingRectWithSize:CGSizeMake(0, 21)];
    _beniftTitle.sd_layout.widthIs(size.width);
    
}


@end
