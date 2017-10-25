//
//  GroupNameCell.m
//  CSchool
//
//  Created by mac on 17/2/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GroupNameCell.h"
#import "UIView+SDAutoLayout.h"
#import "HQXMPPChatRoomManager.h"

@implementation GroupNameCell
{
    UILabel *_txtLabel;//
    UILabel *_detailLabel;//
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
        view.text = @"群聊名称";
        view;
    });
    _detailLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(98, 98, 98);
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_detailLabel,_txtLabel]];
    _txtLabel.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,18).widthIs(60).heightIs(15);
    _detailLabel.sd_layout.rightSpaceToView(contentView,10).topEqualToView(_txtLabel).heightIs(15).widthIs(60);
    CGSize size = [ _txtLabel boundingRectWithSize:CGSizeMake(0, 15)];
    _txtLabel.sd_layout.widthIs(size.width);
}

-(void)setRoomJid:(NSString *)roomJid
{
    _roomJid = roomJid;
    NSArray *roomArray =  [HQXMPPChatRoomManager shareChatRoomManager].roomList;
    for ( XMPPElement *element in roomArray) {
        NSString *jidString =element.attributesAsDictionary[@"jid"];
        XMPPJID *roomJid = [XMPPJID jidWithString:jidString];
        if ([roomJid.user isEqualToString:_roomJid]) {
            _detailLabel.text =[NSString stringWithFormat:@"%@",element.attributesAsDictionary[@"name"]];
            CGSize size = [ _detailLabel boundingRectWithSize:CGSizeMake(0, 15)];
            _detailLabel.sd_layout.widthIs(size.width);
        }
    }
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
