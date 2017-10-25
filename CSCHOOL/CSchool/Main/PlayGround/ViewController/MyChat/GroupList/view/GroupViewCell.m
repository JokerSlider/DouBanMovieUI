//
//  GroupViewCell.m
//  CSchool
//
//  Created by mac on 17/2/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GroupViewCell.h"
#import "UIView+SDAutoLayout.h"
@implementation GroupViewCell
{
    UIImageView *_picImage;//群组头像
    UILabel     *_groupName;//群组名
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
    _picImage  = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"defaultHead"];
        view;
    });
    _groupName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(1, 1, 1);
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_picImage,_groupName]];
    _picImage.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,16).widthIs(36).heightIs(36);
    _groupName.sd_layout.leftSpaceToView(_picImage,16).topSpaceToView(contentView,26).widthIs(200).heightIs(14);
    
}
-(void)setModel:(ChatUserModel *)model
{
    _model = model;
    _groupName.text = model.GROUPNAME;

}
//-(void)setXmppElement:(XMPPElement *)xmppElement{
//    _xmppElement = xmppElement;
//    _groupName.text = xmppElement.attributesAsDictionary[@"name"];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
