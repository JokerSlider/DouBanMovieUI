//
//  ChatModel.h
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface ChatModel : NSObject
@property (nonatomic,copy)NSString *messageNum;
@property (nonatomic,copy)NSString *groupName;
@property (nonatomic,copy)NSArray *memberArray;//用户组
@property (nonatomic,assign)BOOL  state;//是否在线
@property (nonatomic,copy)NSString *signTxt;//签名

@property (nonatomic,copy)NSString * nickTitle;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSArray  *userInfo;
@property (nonatomic,copy)NSString *totalCount;
@property (nonatomic,copy)NSString *onlineCount;
@property (nonatomic,copy)NSArray *userMessage;
//用户个人信息
@property (nonatomic,copy)NSString *trueName;//真实姓名
@property (nonatomic,copy)NSString *name;//菁彩校园自己设置的姓名
@property (nonatomic,copy)NSString *nickName;//昵称
@property (nonatomic,copy)NSString *sex;//性别
@property (nonatomic,copy)NSString *picImageUrl;//头像
@property (nonatomic, copy) UIImage *avatarImage; //头像data
@property (nonatomic,strong)XMPPJID *userjid;//好友jid

//消息页面
@property (nonatomic,copy)NSString *percentMessage;//消息页面最新消息
@property (nonatomic,copy)NSString *percentTime;//当前时间

//添加好友消息
@property (nonatomic,strong)XMPPJID *to;//
@property (nonatomic,copy)NSString *toStr;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,strong)XMPPJID *from;
@property (nonatomic,copy)NSString *fromStr;
@property (nonatomic,copy) NSString *badgeValue;
@property (nonatomic,copy)NSString *requestMsg;//请求的消息
@property (nonatomic,strong)NSData *usrPhotodata;
@property (nonatomic,strong)NSString *timeStr;


@property (nonatomic,strong)NSString *XM; //: 王兆文,
@property (nonatomic,strong)NSString *YHBH; //: 10712,
@property (nonatomic,strong)NSString *NC;// : 吃饭睡觉打豆豆,
@property (nonatomic,strong)NSString *SDS_CODE; //: sdjzu,
@property (nonatomic,strong)NSString *TXDZ;// : http://123.233.121.17:22100/sport/sdjzu/20170317/thumb/201703170834558529820170317083503.jpeg



@end
