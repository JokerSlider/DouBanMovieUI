//
//  ChatAddFriendsFooterView.h
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
@interface ChatAddFriendsFooterView : UIView
@property(nonatomic,strong) UIButton *addFriends;
@property (nonatomic,strong) UIButton *sendMessage;
@property (nonatomic,strong) XMPPJID *userJid;
@end
