//
//  RequstListCell.m
//  CSchool
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "RequstListCell.h"
#import "UIView+SDAutoLayout.h"
#import "HQXMPPManager.h"
@implementation RequstListCell
{
    UILabel *_userName;
    UILabel *_messageLabel;
    UIButton *_addFriends;
    
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    _userName = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15.0];
        view.textColor = [UIColor blackColor];
        view;
    });
    _messageLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:14.0];
        view.textColor = Color_Black;
        view.numberOfLines = 0;
        view;
    });
    _addFriends =({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"再次添加" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.font = [UIFont systemFontOfSize:15.0];
        view;
    });
    [self.contentView sd_addSubviews:@[_userName,_messageLabel]];
    _userName.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,20).widthIs(50).heightIs(20);
    
    _messageLabel.sd_layout.leftSpaceToView(self.contentView,30).topSpaceToView(_userName,10).widthIs(kScreenWidth-30).heightIs(40);
    
//    _addFriends.sd_layout.rightSpaceToView(self.contentView,10).topSpaceToView(_messageLabel,10).widthIs(100).heightIs(20);//隐藏再次添加按钮
    
}
-(void)setModel:(HomeModel *)model
{
    _model = model;
    _userName.text = [[model.uname componentsSeparatedByString:@"+"]lastObject];//用户名
    _messageLabel.text = model.body;
    CGSize  size = [_messageLabel boundingRectWithSize:CGSizeMake(0, 20)];
    _messageLabel.sd_layout.widthIs(size.width);
    size = [_userName boundingRectWithSize:CGSizeMake(0, 20)];
    _userName.sd_layout.widthIs(size.width);
    NSArray *array = [model.uname componentsSeparatedByString:@"+"];
    XMPPJID *jid = [XMPPJID jidWithString:[array firstObject]];
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if ([user.subscription isEqualToString:@"none"]||!user) {
        _addFriends.hidden = NO;
    }else{
        _addFriends.hidden = YES;
    }
}
#pragma mark 添加好友
-(void)addFriends
{
    //添加好友
    NSString *groupName = @"我的好友";

    if([_model.uname isEqualToString:@""]) return;
    //添加好友
    XMPPJID *jid=[XMPPJID jidWithString:_model.uname];
    //判断时代否为自己
    NSString *jidStr = [NSString stringWithFormat:@"%@",jid];
    if (![jidStr containsString:kDOMAIN]) {
        jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@_%@@%@",[AppUserIndex GetInstance].schoolCode,jid,kDOMAIN]];
    }
    NSString *me=[HQXMPPUserInfo shareXMPPUserInfo].user;
    me = [[me componentsSeparatedByString:@"_"]lastObject];
    if([me isEqualToString:_model.uname]){
        [ProgressHUD showError:@"不能添加自己为好友"];
        return;
    }
    XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
    if ([user.subscription isEqualToString:@"both"]) {
        [ProgressHUD showError:@"该用户已经是您的好友了，请勿重复添加!"];
        return;
    }else if ([user.subscription isEqualToString:@"to"]){
        [ProgressHUD showError:@"好友请求已发送,请等待对方确认!"];
        return;
    }

    //发送好友请求
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[HQXMPPManager shareXMPPManager].roster addUser:jid withNickname:_model.uname groups:@[groupName] RequestMessageInfo:@"请求添加您为好友!" mySchoolCode:[AppUserIndex GetInstance].schoolCode andFriendCode:[AppUserIndex GetInstance].schoolCode subscribeToPresence:YES];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"好友请求已发送!"];
    });

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
