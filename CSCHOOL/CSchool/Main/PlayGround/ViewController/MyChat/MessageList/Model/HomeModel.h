//
//  HomeCellModel.h
//  微信
//
//  Created by Think_lion on 15/6/17.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
@interface HomeModel : NSObject
//聊天用户的头像头像
@property (nonatomic,copy) NSData *headerIcon;
//聊天ID
@property (nonatomic,copy) NSString *uname;

//nickname
@property (nonatomic,copy) NSString *nickname;

//子标题
@property (nonatomic,copy) NSString *body;
//时间  格式化后
@property (nonatomic,copy) NSString  *time;
//jid
@property (nonatomic,strong) XMPPJID *jid; //聊天用户的jid

@property (nonatomic,strong)XMPPJID   *myJid;
//数字提醒
@property (nonatomic,copy) NSString *badgeValue;

@property (nonatomic,strong)NSString *trueTime;

@property (nonatomic,strong)NSString *messageType;//

//@property (nonatomic, retain) XMPPElement *xmppElement;

@end
