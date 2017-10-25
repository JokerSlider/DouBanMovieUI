//
//  MyInfoMessageCell.m
//  CSchool
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyInfoMessageCell.h"
#import "UIView+SDAutoLayout.h"
#import "MyInfoModel.h"
#import "UILabel+stringFrame.h"
@implementation MyInfoMessageCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
            }
    return self;
}
-(void)setUpView
{
    CGRect frame = self.contentView.frame;
    frame.size.height = 50 ;
    self.contentView.frame = frame;
    
    _titleLabel  = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Gray;
        view.font = Title_Font;
        view;
    });
    _txtField = ({
        UILabel *view = [UILabel new];
        view.textColor = Color_Black;
        view.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:12.0f];
        view.textAlignment = NSTextAlignmentLeft;
        view.numberOfLines = 0;
        view;
    });
    [self.contentView sd_addSubviews:@[_titleLabel,_txtField]];
    CGFloat margin = 10;
    _titleLabel .sd_layout.leftSpaceToView(self.contentView,margin).heightIs(30).widthIs(80).topSpaceToView(self.contentView,margin);
    _txtField.sd_layout.leftSpaceToView(_titleLabel,margin).rightSpaceToView(self.contentView,30).autoHeightRatio(0).centerYIs(self.contentView.centerY);
    [self setupAutoHeightWithBottomView:_txtField bottomMargin:0];

}
-(void)setModel:(MyInfoModel *)model
{
    _model = model;
    
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
