//
//  ChatUserInfoViewController.h
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
#import "XMPPFramework.h"
@interface ChatUserInfoViewController : UIViewController
@property (nonatomic,strong) XMPPJID *jid; //聊天用户的jid
@property (nonatomic,strong) NSString *groupName;
@end
