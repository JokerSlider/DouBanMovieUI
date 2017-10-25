//
//  AddFriendsCell.m
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AddFriendsCell.h"
#import "UIButton+BackgroundColor.h"
#import "UIView+SDAutoLayout.h"
#import "ChatModel.h"
#import "XMPPFramework.h"
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "UIView+UIViewController.h"
@implementation AddFriendsCell
{

    UIImageView *_picImage;
    UILabel     *_nickName;//昵称
    UILabel     *_userInfo;//用户说明
    UIButton    *_addbutton;//接受按钮
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createVIew];
    }
    return self;
}
-(void)createVIew
{
    _picImage = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"defaultHead"];
        view.layer.cornerRadius = 3;
        view.clipsToBounds = YES;
        view;
    });
    _nickName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(1, 1, 1);
//        view.text = @"王辉";
        view;
    });
    _userInfo  = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:12];
        view.textColor = RGB(98, 98, 98);
//        view.text = @"对方请求添加您为好友";
        view;
    });
    _addbutton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setBackgroundColor:Base_Orange forState:UIControlStateNormal];
        [view setBackgroundColor:[UIColor clearColor] forState:UIControlStateSelected];
        [view setTitle:@"接受" forState:UIControlStateNormal];
        [view setTitle:@"已添加" forState:UIControlStateSelected];
       
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setTitleColor:RGB(98, 98, 98) forState:UIControlStateSelected];
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        [view addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    UIView *contentView = [self contentView];
    [contentView sd_addSubviews:@[_nickName,_picImage ,_userInfo,_addbutton]];
    _picImage.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,16).widthIs(40).heightIs(40);
    _nickName.sd_layout.leftSpaceToView(_picImage,15).topSpaceToView(contentView,18).widthIs(200).heightIs(14);
    _userInfo.sd_layout.leftEqualToView(_nickName).topSpaceToView(_nickName,7).widthIs(200).heightIs(12);
    _addbutton.sd_layout.rightSpaceToView(contentView,10).topSpaceToView(contentView,19).heightIs(28).widthIs(70);
}
-(void)setModel:(ChatModel *)model
{
    _model = model;
    //判断是否子已经存在的好友
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:model.from xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if ([user.subscription isEqualToString:@"from"]||[user.subscription isEqualToString:@"both"]) {
        _addbutton.selected = YES;
        _addbutton.userInteractionEnabled = NO;
    }else{
        _addbutton.selected = NO;
        _addbutton.userInteractionEnabled = YES;

    }
    
    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:model.from shouldFetch:YES];
    _picImage.image=friendvCard.photo.length!=0?[UIImage imageWithData:friendvCard.photo]:[UIImage imageNamed:@"defaultHead"];

    _nickName.text = [[model.from.user componentsSeparatedByString:@"_"] lastObject];//用户名
    if (user.nickname) {
        _nickName.text = user.nickname;
        if ([user.nickname containsString:kDOMAIN]) {
            _nickName.text = [[model.from.user componentsSeparatedByString:@"_"] lastObject];//用户名
        }
    }
    if (![model.requestMsg isEqualToString:@"0"]) {
        _userInfo.text = model.requestMsg;
    }else{
        _userInfo.text = @"请求添加您为好友";

    }
    CGSize size = [_nickName boundingRectWithSize:CGSizeMake(0, 14)];
    _nickName.sd_layout.widthIs(size.width);
}

#pragma addfrinds
-(void)addFriends:(UIButton *)sender
{
   
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", _model.from];
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];

    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
   
    NSString *groupName = @"我的好友" ;
    NSString *nickName=[NSString stringWithFormat:@"%@",jid];
    nickName = [[[[nickName componentsSeparatedByString:@"@"] firstObject]componentsSeparatedByString:@"_"]lastObject];
    if (user.nickname) {
        nickName = user.nickname;
    }
    UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否请求成为对方的好友？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [[HQXMPPManager shareXMPPManager].roster addUser:jid withNickname:nickName groups:@[groupName] subscribeToPresence:NO];

        [[HQXMPPManager shareXMPPManager].roster  acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:NO];//YES:自动发送请求添加对方为好友的请求   NO:不发送
        sender.selected = !sender.selected;
        _addbutton.userInteractionEnabled = NO;

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //do nothing
        [[HQXMPPManager shareXMPPManager].roster addUser:jid withNickname:nickName groups:@[groupName] subscribeToPresence:NO];
        [[HQXMPPManager shareXMPPManager].roster  acceptPresenceSubscriptionRequestFrom:jid  andAddToRoster:NO];//YES:自动发送请求添加对方为好友的请求   NO:不发送
        sender.selected = !sender.selected;
        _addbutton.userInteractionEnabled = NO;

    }];
    
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self.viewController presentViewController:alert animated:YES completion:^{
        //do nothing
    }];
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
