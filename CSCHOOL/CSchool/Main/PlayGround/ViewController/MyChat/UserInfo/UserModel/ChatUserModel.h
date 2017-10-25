//
//  ChatUserModel.h
//  CSchool
//
//  Created by mac on 17/3/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUserModel : NSObject
@property (nonatomic,copy)NSString *CSRQ ;//出生日期
@property (nonatomic,copy)NSString *XBM ;//性别  1 男  2  女
@property (nonatomic,copy)NSString *NC  ;//昵称
@property (nonatomic,copy)NSString *CSDM ;//故乡地址
@property (nonatomic,copy)NSString *SJ;//手机号
@property (nonatomic,copy)NSString *SDSNAME ;//学校名称
@property (nonatomic,copy)NSString *FLOWERSNUMBER ;//鲜花数
@property (nonatomic,copy)NSString *XZZ ;// 现住址
@property (nonatomic,copy)NSString *XM;//真实姓名
@property (nonatomic,copy)NSString *txdz;//头像
//群组成员model
@property (nonatomic,copy)NSString *SCODE;//学校code
@property (nonatomic,copy)NSString *JID;//用户jid
@property (nonatomic,copy)NSString *YHBH;//学号
@property (nonatomic,copy)NSString *TXDZ;
/*
"scode": "sdjzu",
"jid": "20120411175@toplion.toplion-domain",
"txdz": "",
"xm": "王大川",
"yhbh": "20120411175"
 */

@property (nonatomic,copy)NSString *GROUPNAME;// 群组名称
@property (nonatomic,copy)NSString *DESCRIPTION;// 描述
//@property (nonatomic,copy)NSString *ROOMID;//房间ID
@property (nonatomic,copy)NSString *ROOMJID;
@end
