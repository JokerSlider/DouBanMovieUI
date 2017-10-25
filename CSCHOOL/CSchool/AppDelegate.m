//
//  AppDelegate.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LoadingViewController.h"
#import "LoginoneViewController.h"
#import "KSNetRequest.h"
#import "NetworkCore.h"
#import "BaseGMT.h"
#import "WXApi.h"
#import "CoreNewFeatureVC.h"
#import "ConfigObject.h"
#import "XGAlertView.h"
#import <UMengAnalytics/UMMobClick/MobClick.h>
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "PushMsgViewController.h"
#import "LoginNewViewController.h"
#import "DateUtils.h"
#import "IQKeyboardManager.h"
#import "PhotoWallDetailViewController.h"

#import "HQXMPPManager.h"
#import "HQXMPPChatRoomManager.h"
#import "HQXMPPUserInfo.h"
#import "HealthPostDataManager.h"
#import "CSportViewController.h"
#import "XGWebDavManager.h" //
#import "EncryptObject.h"
#import "UserLoginViewController.h"
#import "SchoolSelectViewController.h"
#import "EncryptObject.h"
#import <UserNotifications/UserNotifications.h>
#include "RxWebViewController.h"

#import "MCLeftSlideViewController.h"
#import "MCLeftSliderManager.h"
#import "SettingLeftViewController.h"
#import "NewIndexViewController.h"

@interface AppDelegate ()<XGAlertViewDelegate,WXApiDelegate,JPUSHRegisterDelegate>

@property (nonatomic, strong) LoadingViewController *loadingViewController;
@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;
@property (nonatomic,strong)LoginoneViewController *login2;
@property (nonatomic, strong) RxWebViewController* webViewController;
@property (nonatomic, strong) UINavigationController* webNavViewController;
@property (nonnull, strong) NewIndexViewController *playVC;

@end

@implementation AppDelegate

//弹出登录页面
-(void)presentLoginVC:(UIViewController *)ownerViewControler{
    
    SchoolSelectViewController *vc = [[SchoolSelectViewController alloc]init];
    
    self.login2 = [[LoginoneViewController alloc]init];
    UINavigationController *navlogin = [[UINavigationController alloc] initWithRootViewController:vc];
    [ownerViewControler presentViewController:navlogin  animated:YES completion:nil];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册本地推送
     float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
     if (sysVersion>=8.0) {
         UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
         UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
         [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
         [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];

     }
    AppUserIndex *user = [AppUserIndex GetInstance];
    [user readFromFile];
    // Override point for after application launch.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccess:) name:NotificationLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutAction) name:NotificationLogout object:nil];

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = Base_Orange;
    [self.window makeKeyAndVisible];
    
    
    [[UITabBar appearance] setTintColor:Base_Orange];

    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];

    // ios8后，需要添加这个注册，才能得到授权
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
//                                                                                 categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }
    
    //    //极光推送
//    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                      UIUserNotificationTypeSound |
//                                                      UIUserNotificationTypeAlert)
//                                          categories:nil];
//
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//
//    [JPUSHService setupWithOption:launchOptions appKey:appKey
//                          channel:user.schoolCode
//                 apsForProduction:isProduction
//            advertisingIdentifier:advertisingId];
    
//--------------------------
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    
//    [self pustConfig:application];
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction];
    
//--------------------------
    //微信支付
    [WXApi registerApp:@"wx19cb13813aa97855" withDescription:@"CSchool"];
    //友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    
    UMAnalyticsConfig *umConfig = [[UMAnalyticsConfig alloc] init];
    umConfig.appKey = @"56d3a282e0f55a87ce001980";
    umConfig.channelId = @"CPLUS";
//    [MobClick startWithAppkey:@"56d3a282e0f55a87ce001980" reportPolicy:BATCH channelId:@"SDJZU"];
    [MobClick startWithConfigure:umConfig];
   
    //判断是否需要显示：（内部已经考虑版本及本地版本缓存）
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    
    //测试代码，正式版本应该删除
//    canShow = YES;
    
    [self getEncryptWhiteList];

    if(canShow){
        
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"scimage_ios1.jpg"]];
        
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"scimage_ios2.jpg"]];
        
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"scimage_ios3.jpg"]];
        
        NewFeatureModel *m4 = [NewFeatureModel model:[UIImage imageNamed:@"scimage_ios4.jpg"]];
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3,m4] enterBlock:^{
            
            [self enter];
        }];
    }else{
        if(!user.isLogin){
            
            [self enter];
        }else{
            
           _loadingViewController = [[LoadingViewController alloc] init];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loadingViewController];
            nav.navigationBarHidden =  YES;
            [self.window setRootViewController:nav];
            //不是第一次登陆
            _loadingViewController.showLabel.text = @"正在登录...";
            //自动登录
            [self autoLogin];
        }
    }

    //设置icon数字为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [AppUserIndex GetInstance].pushUserInfo = remoteNotification;
       
        [self pustAction:remoteNotification];
    }
   
//    [[[IQKeyboardManager sharedManager] disabledDistanceHandlingClasses] addObject:[PhotoWallDetailViewController class]];
    //获取地理位置信息
//    [self getLocalInfo];
    
    return YES;
}

- (void)pustConfig:(UIApplication *)application{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"注册失败");
            }
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

//自动登录
- (void)autoLogin{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstUpdate"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstUpdate"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
        return;
    }
    AppUserIndex *user = [AppUserIndex GetInstance];
    if (!user.accountId  || !user.schoolCode || !user.API_URL || ![[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"]) {
        //|| !user.token
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
        return;
    }
    WEAKSELF;
    [NetworkCore queryUserInfoWithName:[AppUserIndex GetInstance].accountId success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogin object:self];
        [weakSelf getAppInfo];
        _loadingViewController.showLabel.text = @"";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        _loadingViewController.showLabel.text = @"";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
//        [_loadingViewController showErrorViewLoadAgain:@"加载数据失败,请重新获取!"];
    }];
    
}

//根据角色信息返回账号显示套餐
- (void)getAppInfo{
#ifdef isNewVer
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getNewAppSystemInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //        [AppUserIndex GetInstance].appListArray = responseObject[@"data"];
        [AppUserIndex GetInstance].fileListArray = [responseObject valueForKeyPath:@"data.file"];
        [AppUserIndex GetInstance].hotListArray = [responseObject valueForKeyPath:@"data.hot"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogin object:self];

        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
    }];
#else
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogin object:self];

#endif
    
    
}

- (void)getEncryptWhiteList{
    [NetworkCore requestPOST:API_HOST parameters:@{@"rid":@"getEncryptWhiteList"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [EncryptObject shareEncrypt].whiteListArray = responseObject[@"data"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        NSLog(@"2");
    }];
}


- (void)enter{
    _loadingViewController = [[LoadingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loadingViewController];
    nav.navigationBarHidden = YES;
    [self.window setRootViewController:nav];
    
    [self presentLoginVC:_loadingViewController];
}


- (void)logOutAction{
    //清除用户名  密码   学校

    
    AppUserIndex *user = [AppUserIndex GetInstance];
    [user cleanAndSave];
    [[ConfigObject shareConfig] clean];

#ifdef isNewVer
    [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
    [self presentLoginVC:_playVC];
#else
    [self presentLoginVC:_loadingViewController];

#endif
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url);
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            //            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            //            NSLog(@"result = %@",resultDic);
        }];
    }    
    return  [WXApi handleOpenURL:url delegate:self];
}
-(void)onResp:(BaseResp *)resp
{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSLog(@"+++++++++支付结果++++++++");
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        NSLog(@"resp.errCode = %d  errStr = %@",resp.errCode,resp.errStr);
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:@"成功"];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
                
                break;
                
        }
        
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAPNSHandler object:userInfo];
    [self persentPushVC:userInfo];

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound);  // 系统要求执行这个方法
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber=0;
    [[HealthPostDataManager shareInstance]sendStepNumAndColriaData];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateActive)) {
        
        // 取得 APNs 标准信息内容
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        
        if (![[userInfo valueForKey:@"moudle"] isEqualToString:@"41"]) {
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"推送" withContent:content WithCancelButtonTitle:@"查看" withOtherButton:nil];
            alert.tempValue = userInfo;
            alert.isBackClick = YES;
            alert.tag = 2001;
            [alert show];
        }
        
        
        //收到极光的推送  本地发送通知
        [self postNewFuncNotification:[userInfo valueForKey:@"moudle"]];

    }else{
        [self pustAction:userInfo];
    }
    
    //IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
//推送功能消息
-(void)postNewFuncNotification:(NSString *)ID
{
    NSString *msgNum ;
    if ([ID isEqualToString:@"40"]) {
        msgNum = @"1";
    }else{
        msgNum = @"";
    }
    
    NSDictionary *dic = @{
                          @"funcID":ID,
                          @"msgNum":msgNum
                          };
    NSNotification *allFuncNote = [[NSNotification alloc]initWithName:AllFunctionNotication object:dic userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:allFuncNote];
    //将系统消息存档
    AppUserIndex *shareConfig = [AppUserIndex GetInstance];
    NSMutableArray *funcArr =[NSMutableArray arrayWithArray:shareConfig.funcMsgArr];
    if (funcArr.count == 0) {
        [funcArr addObject:dic];
    }
    [funcArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"funcID"] isEqualToString:ID]) {
            // do sth
            [funcArr removeObject:obj];
            [funcArr addObject:dic];
            *stop = YES;
        }else{
            [funcArr addObject:dic];
            *stop = YES;
        }
    }];
    shareConfig.funcMsgArr = funcArr;
    [shareConfig saveToFile];
    
}
//推送弹窗处理
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag == 2001) {
        NSDictionary *userInfo = view.tempValue;
        [self pustAction:userInfo];
    }
}

- (void)pustAction:(NSDictionary *)userInfo{

    [self postNewFuncNotification:[userInfo valueForKey:@"moudle"]];
    if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"output"]] isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAPNSHandler object:userInfo];
    }else if ([[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"output"]] isEqualToString:@"2"]){
        [AppUserIndex GetInstance].pushUserInfo = nil;

        RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:userInfo[@"moudle"]]];//
        vc.isNewWebViewFrame = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dissmissWebView:)];
        vc.navigationItem.rightBarButtonItem = leftItem1;
        _webViewController = vc;
        _webNavViewController = nav;
        [self performSelector:@selector(presentNav:) withObject:userInfo afterDelay:1];
    }
}

- (void)presentNav:(NSDictionary *)userInfo{
    [_loadingViewController presentViewController:_webNavViewController animated:YES completion:nil];
}
- (void)dissmissWebView:(UIButton *)sender{
    [_webNavViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)persentPushVC:(NSDictionary *)userInfo{
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
//    if (![UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
    
//        PushMsgViewController *vc = [[PushMsgViewController alloc] init];
//        vc.contentStr = content;
//        [_loadingViewController presentViewController:vc animated:YES completion:nil];
//    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginBackgroundTaskWithExpirationHandler:^{

    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    [[NSUserDefaults standardUserDefaults] setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"terminateTime"];

}

-(void)handleLoginSuccess:(NSNotification *)notification {

    //新生是否显示绑定手机号页面
    if (([[AppUserIndex GetInstance].yanzhengPhoneArray count] < 3) && [AppUserIndex GetInstance].isNewEntry ){//&& [AppUserIndex GetInstance].isUp) { //
        [AppUserIndex GetInstance].isBundPhone = YES;
    }
//
    XGWebDavManager *manager = [XGWebDavManager sharWebDavmManager];
    manager.userName = @"admin";
    manager.password = @"123456";
    manager.url = @"http://192.168.80.243:8090/remote.php/webdav/";
    manager.baseUrl = @"http://192.168.80.243:8090";


//    [·1JPUSHService setAlias:[AppUserIndex GetInstance].role_id completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        NSLog(@"%ld-%@",(long)iResCode,iAlias)
//    } seq:1];
    
    NSString *str = [JPUSHService registrationID];
    if (str) {
        //添加推送信息
        NSDictionary *jpushDic = @{
                                   @"rid":@"addJpushinfoByState",
                                   @"state":@"1",
                                   @"userid":[AppUserIndex GetInstance].accountId,//@"fcguo",//
                                   @"information":str
                                   };
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:jpushDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"上传推送信息成功");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            NSLog(@"%@",error);
        }];
    }

    [HQXMPPUserInfo shareXMPPUserInfo].user =[[NSString stringWithFormat:@"%@_%@",[AppUserIndex GetInstance].schoolCode,stuNum] lowercaseString];//[NSString stringWithFormat:@"%@_%@",[AppUserIndex GetInstance].schoolCode,stuNum];
    [HQXMPPUserInfo shareXMPPUserInfo].pwd = [EncryptObject md532BitUpper:[EncryptObject md532BitUpper:[NSString stringWithFormat:@"%@@toplion",[stuNum uppercaseString]]]];

    
    [[NSUserDefaults standardUserDefaults] setObject:[HQXMPPUserInfo shareXMPPUserInfo].user forKey:@"xmppuserName"];
    WEAKSELF;
    if (![AppUserIndex GetInstance].isUseChat) {
        [[HQXMPPManager shareXMPPManager] xmppUserLoginWithResult:^(XMPPResultType type) {
            
            [weakSelf handleResultType:type];
        }];
    }
#ifdef isNewVer
    if(!self.playVC)
    {
        AppUserIndex *user = [AppUserIndex GetInstance];
        NSLog(@"%@",user.schoolCode);
        self.loadingViewController.navigationController.navigationBarHidden = YES;
        
        _playVC = [[NewIndexViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_playVC];
        SettingLeftViewController *leftVC = [[SettingLeftViewController alloc] init];
        MCLeftSlideViewController *rootVC = [[MCLeftSlideViewController alloc] initWithLeftView:leftVC andMainVCView:nav];
        
        
        [self.loadingViewController.navigationController pushViewController:rootVC animated:YES];
        [MobClick event:@"login"];
    }
    
    [_playVC logSuccess];
#else
    
    if(self.mainTabBarViewController)
    {
        [self.mainTabBarViewController setSelectedIndex:0];
        return;
    }
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSLog(@"%@",user.schoolCode);
    self.mainTabBarViewController = [[MainTabBarViewController alloc] init];
    self.loadingViewController.navigationController.navigationBarHidden = YES;
    [self.loadingViewController.navigationController pushViewController:self.mainTabBarViewController animated:YES];
    [MobClick event:@"login"];
    
#endif


}


//xmpp登录后信息回掉
-(void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{                                //  线程刷新UI
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                
                //这里要获取到用户所有加入的群组列表，并且加入到每个群组中
                [[HQXMPPChatRoomManager shareChatRoomManager] setup];
                [[HQXMPPChatRoomManager shareChatRoomManager] queryRooms];
                
                [HQXMPPChatRoomManager shareChatRoomManager].updateData = ^(id sender){
                    for (XMPPElement *obj in [HQXMPPChatRoomManager shareChatRoomManager].roomList) {
                        NSString *jidString = obj.attributesAsDictionary[@"jid"];
                        
                        [[HQXMPPChatRoomManager shareChatRoomManager] joinInChatRoom:jidString withPassword:nil];
                        
                    }
                };
                
                [[HQXMPPManager shareXMPPManager].roster setAutoAcceptKnownPresenceSubscriptionRequests:NO];//自动同意好友请求
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                NSLog(@"The Name or password wrong");
                break;
            case XMPPResultTypeNetErr:
                NSLog(@"Network is not available");
            default:
                break;
        }
    });
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"notification : %@", notification);
    
    [self postNewFuncNotification:@"41"];
    
    
    if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@"sportNotifi"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"菁彩运动" message:@"您今天的健康运动信息已经统计完毕，快打开菁彩运动查看今天的运动排行吧~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:okAction];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}
@end
