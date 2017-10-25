//
//  ChatAddFriendsFooterView.m
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChatAddFriendsFooterView.h"
#import "UIView+SDAutoLayout.h"
#import "XGChatViewController.h"
#import "UIView+UIViewController.h"
#import "SetAddMsgViewController.h"

@implementation ChatAddFriendsFooterView
{

}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}
-(void)createView
{
    _sendMessage = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = RGB(237, 120, 14);
        view.layer.cornerRadius = 2;
        [view setTitle:@"发消息" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:17];
        [view addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    _addFriends = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = RGB(219, 219, 219);
        view.layer.cornerRadius = 2;
        [view setTitle:@"加好友" forState:UIControlStateNormal];
        [view setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:17];
        [view addTarget:self action:@selector(addFriendsAction:) forControlEvents:UIControlEventTouchUpInside];

        view;
    });
    [self sd_addSubviews:@[_sendMessage,_addFriends]];
    _sendMessage.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(46).topSpaceToView(self,50);
    _addFriends.sd_layout.leftEqualToView(_sendMessage).rightEqualToView(_sendMessage).heightIs(46).topSpaceToView(_sendMessage,10);
    
}
-(void)sendMessageAction:(UIButton *)sender
{
    XGChatViewController *vc = [[XGChatViewController alloc]init];
    vc.jidStr = [NSString stringWithFormat:@"%@",_userJid];
    [self.viewController.navigationController pushViewController:vc animated:YES ];
}
-(void)addFriendsAction:(UIButton *)sender
{
    SetAddMsgViewController *vc = [[SetAddMsgViewController alloc]init];
    vc.uname = [self trimStr:[NSString stringWithFormat:@"%@",_userJid]];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
#pragma mark 去掉两边空格的方法
-(NSString*)trimStr:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}

@end
