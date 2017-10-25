//
//  XGChatViewController.h
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/7.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

@interface XGChatViewController : UIViewController
//好友的jid
@property (strong, nonatomic) NSString *jidStr;
@property (nonatomic, assign) BOOL isRoomChat; //是否是群聊
@property (nonatomic,copy)NSString *sectionName;//分组名
@property (nonatomic,copy)NSString *userName;//用户名

@property (nonatomic,copy)NSString *groupName;//群组
@property (nonatomic,copy)NSString *roomJid;

@end
