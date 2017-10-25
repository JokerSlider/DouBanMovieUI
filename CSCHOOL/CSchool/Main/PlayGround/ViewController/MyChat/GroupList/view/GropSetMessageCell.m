//
//  GropSetMessageCell.m
//  CSchool
//
//  Created by mac on 17/2/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GropSetMessageCell.h"
#import "UIView+SDAutoLayout.h"
@implementation GropSetMessageCell
{
    UILabel *_txtLabel;//
    UISwitch *_messageSwitch;//屏蔽消息开关
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
    _txtLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor=Color_Black ;
        view.text = @"消息免打扰";
        view;
    });
    _messageSwitch = ({
        UISwitch *view = [UISwitch new];
        [view setOn:NO];
        view;
    });
    UIView *contentView =self.contentView;
    [contentView sd_addSubviews:@[_txtLabel,_messageSwitch]];
    _txtLabel.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,18).widthIs(200).heightIs(15);
    _messageSwitch.sd_layout.rightSpaceToView(contentView,10).centerYIs(contentView.centerY).heightIs(15).widthIs(40);

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
