//
//  FellowCell.m
//  CSchool
//
//  Created by mac on 17/2/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "FellowCell.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatUserInfoViewController.h"
#import "UIView+UIViewController.h"
@implementation FellowCell
{
    UIImageView *_picImage;
    UILabel     *_userNickName;
    UILabel     *_userInfo;//用户状态以及用户说明
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
        view.layer.cornerRadius = 40/2;
        view.clipsToBounds = YES;
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSetUserView:)];
        view.userInteractionEnabled = YES;
        gester.numberOfTapsRequired = 1;
        [view addGestureRecognizer:gester];
        view;
    });
    _userNickName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15.0];
        view.textColor = Color_Black;
        view;
    });
    _userInfo = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12.0];
        view.textColor = RGB(98, 98, 98);
        view;
    });
    [self.contentView sd_addSubviews:@[_picImage,_userNickName,_userInfo]];
    UIView *contentView = self.contentView;
    _picImage.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,15).widthIs(40).heightIs(40);
    _userNickName.sd_layout.leftSpaceToView(_picImage,15).topEqualToView(_picImage).widthIs(kScreenWidth-100).heightIs(15);
    _userInfo.sd_layout.leftEqualToView(_userNickName).topSpaceToView (_userNickName,8).heightIs(12).widthIs(kScreenWidth-100);
    [self setupAutoHeightWithBottomView:_picImage bottomMargin:15];
    
}
-(void)setModel:(ChatModel *)model
{
    _model = model;
    //更换昵称 和  头像  走本地接口
    [_picImage setImage:[UIImage imageNamed:@"defaultHead"]];
    if (model.avatarImage) {
        _picImage.image = model.avatarImage;
    }

    _userNickName.text = model.name;
    BOOL isOnline = _model.state;
    NSString *onlineState = isOnline?@"[在线]":@"[离线]";
    _userInfo.text = [NSString stringWithFormat:@"%@%@",onlineState,@""];

}
#pragma mark 头像点击事件
-(void)openSetUserView:(UIButton *)sendr
{
    ChatUserInfoViewController  *vc =[[ChatUserInfoViewController alloc]init];
    vc.jid  = _model.userjid;
    vc.groupName = _model.groupName;
    [self.viewController.navigationController pushViewController:vc animated:YES];
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
