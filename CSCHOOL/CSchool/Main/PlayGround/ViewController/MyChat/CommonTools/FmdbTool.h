//
//  FmdbTool.h
//  微信
//
//  Created by Think_lion on 15/6/30.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
@interface FmdbTool : NSObject

/*
head blob,uname text,detailname text,time text,badge text
 */

//添加数据
+(BOOL)addHead:(NSData *)head uname:(NSString *)uname detailName:(NSString *)detailName time:(NSString *)time badge:(NSString *)badge xmppjid:(XMPPJID *)jid withMyjid:(XMPPJID *)myJid andMsgType:(NSString *)msgtype;
//查询判断数据有没有存在
+(BOOL)selectUname:(NSString *)uname withMyjid:(XMPPJID *)myJid;
//更新数据库里面的东西
+(BOOL)updateWithName:(NSString *)uname detailName:(NSString *)detailName time:(NSString *)time badge:(NSString *)badge withMyjid:(XMPPJID *)myJid andUserJId:(XMPPJID *)userJid  andMsgTyope:(NSString *)msgType;
//查询所有的数据
+(NSArray *)selectAllDatawithXmppID:(XMPPJID *)myXmppjid andMessageType:(NSString *)type;
//清除小红点的方法
+(void)clearRedPointwithName:(NSString *)uname withXmppID:(XMPPJID *)myXmppjid;
//删除聊天数据的方法
+(void)deleteWithName:(NSString *)uname withXmppID:(XMPPJID *)myXmppjid;


//添加好友的信息存储
+(BOOL)addFriends:(NSString *)fromString  xmppJid:(XMPPJID *)jid andbadgeValue:(NSString *)badgeValue andRequestMsg:(NSString *)msg withMyXmppID:(XMPPJID *)myjid presenceTime:(NSString *)time;
//查询判断数据有没有存在
+(BOOL)selectfromString:(NSString*)selectfromString  xmppJid:(XMPPJID *)myjid ;
//更新添加好友的信息
+(BOOL)updateFfomString:(NSString*)fromString xmppJid:(XMPPJID *)jid andbadgeValue:(NSString *)badgeValue  andRequestMsg:(NSString *)msg withMyXmppID:(XMPPJID *)myjid presenceTime:(NSString *)time;
//删除添加好友的信息
+(void)deleteFromString:(NSString*)fromStr xmppJid:(XMPPJID *)jid withMyXmppID:(XMPPJID *)myjid;

//查询好友请求信息  查询关于正在登陆好友的信息
+(NSArray *)selectRequestDatawithXmppID:(XMPPJID *)xmppjid;
//删除好友请求信息的小红点
+(void)clearRedPointwithFromString:(XMPPJID *)jid withMyXmppID:(XMPPJID *)myjid withbadgeValue:(NSString *)badgeValue;

@end
