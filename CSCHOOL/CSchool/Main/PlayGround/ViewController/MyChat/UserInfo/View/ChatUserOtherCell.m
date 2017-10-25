//
//  ChatUserOtherCell.m
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChatUserOtherCell.h"
#import "UIView+SDAutoLayout.h"
@implementation ChatUserOtherCell
{
    UILabel  *_nameLabel;
    UILabel  *_detaiLabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
//
-(void)createView
{
    _nameLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(1, 1, 1);
        view;
    });
    _detaiLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(98, 98, 98);
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_nameLabel,_detaiLabel]];
    _nameLabel.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,15).widthIs(60).heightIs(30);
    _detaiLabel.sd_layout.leftSpaceToView(_nameLabel,28).topEqualToView(_nameLabel).widthIs(200).heightIs(30);
}
-(void)setModel:(ChatModel *)model
{
    _model  = model;
    _nameLabel.text = model.nickTitle;
    _detaiLabel.text = model.content;
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
