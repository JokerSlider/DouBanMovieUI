//
//  AddSearchCell.m
//  CSchool
//
//  Created by mac on 17/3/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AddSearchCell.h"
#import "UIButton+BackgroundColor.h"
#import "UIView+SDAutoLayout.h"
#import "HQXMPPManager.h"
#import "UIView+UIViewController.h"
#import "SetAddMsgViewController.h"
#import "XMPPvCardTemp.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AddSearchCell
{
    UIImageView *_picImageV ;
    UILabel     *_nickNameL ;
    UILabel     *_numberL;//学号
    UIButton    *_add_friend;
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
    _picImageV = ({
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 3;
        view.clipsToBounds = YES;
        view.image = [UIImage imageNamed:@"defaultHead"];
        view;
    });
    _nickNameL = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(1, 1, 1);
        view.font = [UIFont systemFontOfSize:15.0f];
        view;
    });
    _numberL = ({
        UILabel *view = [UILabel new];
        view.textColor = RGB(98, 98, 98);
        view.font = [UIFont systemFontOfSize:12.0f];
        view;
    });

    _add_friend = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setBackgroundColor:Base_Orange forState:UIControlStateNormal];
        [view setBackgroundColor:[UIColor clearColor] forState:UIControlStateSelected];
        [view setTitle:@"添加" forState:UIControlStateNormal];
        [view setTitle:@"已添加" forState:UIControlStateSelected];
        view.selected  = NO;
        view.layer.cornerRadius  = 2;
        view.clipsToBounds = YES;
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setTitleColor:RGB(98, 98, 98) forState:UIControlStateSelected];
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        [view addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    UIView *contentView = self.contentView;
    [contentView sd_addSubviews:@[_picImageV,_nickNameL,_numberL,_add_friend]];
    _picImageV.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(contentView,15).widthIs(35).heightIs(35);
    _nickNameL.sd_layout.leftSpaceToView(_picImageV,15).topEqualToView(_picImageV).widthIs(150).heightIs(15);
    _numberL.sd_layout.leftEqualToView(_nickNameL).topSpaceToView(_nickNameL,7).heightIs(12).widthIs(200);
    _add_friend.sd_layout.rightSpaceToView(contentView,10).topSpaceToView(contentView,19).widthIs(70).heightIs(28);
}
-(void)setModel:(ChatModel *)model
{
    _model = model;
//    NSString *uname=[self trimStr:_model.toStr];
//    uname=[uname lowercaseString];  //转成小写
//    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:model.to shouldFetch:YES];
//    _picImageV.image=friendvCard.photo.length!=0?[UIImage imageWithData:friendvCard.photo]:[UIImage imageNamed:@"defalt_head"];
//    _nickNameL.text = model.to.user;//用户名
//    if (friendvCard.nickname) {
//        _nickNameL.text = friendvCard.nickname;
//    }
//    _numberL.text =  uname;
//    XMPPJID *jid=[XMPPJID jidWithUser:uname domain:kDOMAIN resource:nil];
//    //判断是否子已经存在的好友
//    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
//    if ([user.subscription isEqualToString:@"both"]) {
//        _add_friend.selected = YES;
//        _add_friend.userInteractionEnabled = NO;
//    }else if([user.subscription isEqualToString:@"to"]){
//        _add_friend.selected = NO;
//        _add_friend.userInteractionEnabled = YES;
//    }else{
//        _add_friend.selected = NO;
//        _add_friend.userInteractionEnabled = YES;
//    }
    NSString *breakString =[NSString stringWithFormat:@"/thumb"];
    NSString *photoUrl = [model.TXDZ  stringByReplacingOccurrencesOfString:breakString withString:@""];

    [_picImageV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"defaultHead"]];
    _nickNameL.text =[NSString stringWithFormat:@"%@(%@)",model.NC?model.NC:@"无",model.XM];
    if (!model.NC) {
        _nickNameL.text =[NSString stringWithFormat:@"%@",model.XM?model.XM:model.YHBH];
    }
    NSString *uname=[self trimStr:_model.YHBH];
    _numberL.text = model.YHBH;
    XMPPJID *jid=[XMPPJID jidWithUser:uname domain:kDOMAIN resource:nil];
    NSString *jidStr = [NSString stringWithFormat:@"%@_%@",[AppUserIndex GetInstance].schoolCode,jid];
    jid  = [XMPPJID jidWithString:jidStr];
    //判断是否子已经存在的好友
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if ([user.subscription isEqualToString:@"both"]) {
        _add_friend.selected = YES;
        _add_friend.userInteractionEnabled = NO;
    }else if([user.subscription isEqualToString:@"to"]){
        _add_friend.selected = NO;
        _add_friend.userInteractionEnabled = YES;
    }else{
        _add_friend.selected = NO;
        _add_friend.userInteractionEnabled = YES;
    }
//    CGSize size = [_nickNameL boundingRectWithSize:CGSizeMake(0, 15)];
//    _nickNameL.sd_layout.widthIs(size.width);
    CGSize size = [_numberL boundingRectWithSize:CGSizeMake(0, 12)];
    _numberL.sd_layout.widthIs(size.width);
}
-(void)addFriends:(UIButton *)sender
{
    NSString *uname=[self trimStr:_model.YHBH];

    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",uname,kDOMAIN]];
    XMPPJID *newJId =[XMPPJID jidWithString:uname];
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:newJId xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if (!user) {
        user =[[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    }
   if([user.subscription isEqualToString:@"to"]){
       [ProgressHUD showSuccess:@"好友请求已发送,请等待对方回应。"];
       return;
    }

    SetAddMsgViewController *vc = [[SetAddMsgViewController alloc]init];
    vc.uname = [self trimStr:_model.YHBH];
    [self.viewController.navigationController pushViewController:vc animated:YES];

}
#pragma mark 去掉两边空格的方法
-(NSString*)trimStr:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
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
