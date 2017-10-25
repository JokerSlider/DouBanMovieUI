//
//  URLConsts.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/11.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#ifndef URLConsts_h  
#define URLConsts_h

#define isDEBUG  //调试模式，正式版本注释掉。

#define isTest //开发环境，正式版本注释掉

#define isNewVer //新版，首页样式变化

#ifdef isDEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

//#ifdef isDEBUG
//#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//#else
//#define NSLog(format, ...)
//#endif

#ifdef isTest
//#define API_HOST2 @"http://123.233.121.17:4109/index.php"
//#define API_HOST @"http://111.14.210.46:4109/index.php"
#define API_HOST2 @"http://123.233.121.17:15100/index.php"
#define API_HOST @"http://111.14.210.46:15100/index.php"
#else
#define API_HOST2 @"http://123.233.121.17:12100/index.php"
#define API_HOST @"http://111.14.210.46:12100/index.php"

#endif
#define kDOMAIN @"toplion.toplion-domain"      //xmpp域名
#define kHOSTNAME @"123.233.121.17"   //xmpp服务器名
//#define kHOSTNAME @"192.168.80.243"   //xmpp服务器名
//#define kHOSTNAME @"124.133.55.98"   //xmpp服务器名124.133.55.98

#define KPort     35210 //5222     4110 演示版    //服务器端口号
//#define KPort     5222 //5222     4110 演示版    //服务器端口号
//#define KPort     8916 //5222     4110 演示版    //服务器端口号

//接受到消息的通知消息的通知名
#define SendMsgName @"sendMessage"
//删除好友时发出的通知名
#define DeleteFriend @"deleteFriend"
//收到好友请求的通知
#define FrindsRequest @"frindsRequest"
//拒绝添加为好友
#define CancelAddFriends @"CancelAddFriends"
//已经成为好友
#define DiDBecomeFriends @"DiDBecomeFriends"
//全功能通知
#define AllFunctionNotication  @"AllFunctionNotification"
//移除了全功能的小红点
#define RemoveFunctionNotication  @"RemoveFunctionNotication"



#define WEB_URL_HELP(A) [NSString stringWithFormat:@"http://123.233.121.17:12100/help/%@",A]

#define URL_IdCodeImage [NSURL URLWithString:[NSString stringWithFormat:@"%@?rid=getChkNum",API_HOST]]

#define TEST_URL @"http://www.baidu.com"

#endif /* URLConsts_h */
