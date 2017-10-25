//
//  Common.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define DEMO

#define NotificationLogout @"NSNotificationLogout" //注销通知
#define NotificationLogin @"NSNotificationLoginSuccess" //登录成功通知
#define NotificationUpdate @"NotificationUpdate" //检查更新通知
#define NotificationAPNSHandler @"NSNotificationAPNSHandler"  //收到推送信息通知
#define NotificationRelogin @"NotificationRelogin" //重新登录通知

#define NotificationYunListReload @"NotificationYunListReload" //云盘列表刷新

#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#ifdef __IPHONE_10_0
#define RGB_Alpha(R,G,B,Alpha)	 UIColor colorWithDisplayP3Red:R/255.0f green:G/255.0f blue:B/255.0f alpha:Alpha]
#endif
#define RGB_Alpha(R,G,B,Alpha)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:Alpha]


#import "BaseStyle.h"
#import "KSNetRequest.h"
#import "URLConsts.h"
#import "ProgressHUD.h"
#import "AppUserIndex.h"
#import "NetworkCore.h"
#import <JSONKit.h>
#import "XGAlertView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UILabel+stringFrame.h"
#import "HealthPostDataManager.h"
#import "JohnAlertManager.h"
#import "FriendRequestManager.h"
//通知的名字及参数
#define WX_PAY_RESULT   @"weixin_pay_result"
#define IS_SUCCESSED    @"wechat_pay_isSuccessed"
#define IS_FAILED       @"wechat_pay_isFailed"

#define OABase_URL      @"http://123.233.121.17:35201/StationWebService/api"//正式: 123.233.121.17:35201    开发: 124.133.55.98:8915  测试开发:192.168.80.208:8389

//OA办公账号
#define PlaceHolder_Image [UIImage imageNamed:@"placdeImage"]

#ifdef isDEBUG
//教师工号---学生学号
#define OATeacherNum  [AppUserIndex GetInstance].role_id
#define stuNum @"201511101102"//17370783154940  17370705150581   17370102110229

#define teacherNum @"13042"
#define APP_URL @"http://123.233.121.17:12100/index.php"
#define Message_Num  @"15"
#define sportUserName @"201511101102"//运动排行账号

#else
#define stuNum [AppUserIndex GetInstance].role_id
#define teacherNum [AppUserIndex GetInstance].role_id
#define APP_URL [AppUserIndex GetInstance].API_URL
#define Message_Num  @"15"
#define sportUserName [AppUserIndex GetInstance].role_id//运动排行账号
#define OATeacherNum    [AppUserIndex GetInstance].role_id
#endif

#endif /* Common_h */
