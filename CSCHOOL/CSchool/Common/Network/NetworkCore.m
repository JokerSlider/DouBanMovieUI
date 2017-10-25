
//
//  NetworkCore.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "NetworkCore.h"
#import "KSCache.h"
#import <AFNetworking.h>
#import "ProgressHUD.h"
#import "UIViewController+KSNoNetController.h"
#import "GTMBase64.h"
#import <JSONKit.h>
#import "BaseGMT.h"
#import "DES3Util.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "XGAlertView.h"
#import "PXRequest.h"
#import <YYModel.h>
#import "CRSA.h"
#import<CommonCrypto/CommonDigest.h>
#import "EncryptObject.h"
#import "ConfigObject.h"
#import "ICMP.h"
#import "Address.h"
#import "ARP.h"
#import "MDNS.h"

//===========================请求超时时间==========================//
#define TIMEOUTINTERVAL 10
//====================是不是需要缓存==YES需要==NO不需要====================//
#define ISCACHE NO
//====================是不是参数、返回数据加密====================//
#define ISSECRET NO

#define ISAESSECRET  NO

#define ISRSASECRET  YES


@implementation NetworkCore

+ (NSString *)getMacInfo{
    
    NSString *mac = @"02:00:00:00:00:00";
#if TARGET_IPHONE_SIMULATOR
#else
    
    //设置获取mac地址三种方式
    NSString *ip = [Address currentIPAddressOf:@"en0"];
    //way 1
    [ICMP sendICMPEchoRequestTo:ip];
    NSString *mac1 = [ARP walkMACAddressOf:ip];
    
    //way 2
    [ICMP sendICMPEchoRequestTo:ip]; //just for way2 regular steps
    NSString *mac2 = [ARP MACAddressOf:ip];
    
    //way 3
    NSString *mac3 = [MDNS getMacAddressFromMDNS];
    
    if (mac1 && ![mac1 isEqualToString:@"02:00:00:00:00:00"]) {
        mac = mac1;
    }else if (mac2 && ![mac2 isEqualToString:@"02:00:00:00:00:00"]){
        mac = mac2;
    }else if (mac3 && ![mac3 isEqualToString:@"02:00:00:00:00:00"]){
        mac = mac3;
    }
    
    #endif
    return mac;
}

/**
 *  获取wifi名称(ssid)
 *
 *  @return
 */
+ (NSString *)getWifiName{
    NSString *wifiName = nil;
    NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    for (NSString *name in interFaceNames) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        }
    }
    return wifiName;
}

+ (NSString *)translateMacAdd:(NSString *)bssid{
    if (!bssid || [bssid length] < 1) {
        return @"";
    }
    NSArray *arr = [bssid componentsSeparatedByString:@":"];
    NSMutableString *macAdd = [NSMutableString string];
    for (NSString *obj in arr) {
        if ([obj length]==1) {
            [macAdd appendString:@"0"];
        }
        [macAdd appendString:obj];
    }
    return macAdd;
}

/**
 *  获取wifi BSSID
 *
 *  @return
 */
+ (NSString *)getBSSID{
    NSString *wifiName = nil;
    NSArray *interFaceNames = (__bridge_transfer id)CNCopySupportedInterfaces();
    
    for (NSString *name in interFaceNames) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)name);
        if (info[@"BSSID"]) {
            wifiName = info[@"BSSID"];
        }
    }
    return [NetworkCore translateMacAdd:wifiName];
}

/**
 *  判断当前wifi名称是否是规定名称
 *
 *  @return YES，NO
 */
+(BOOL)wifiIsEqual{
    BOOL isEqual = false;
    NSString *wifiName = [NetworkCore getWifiName];
    if (![[AppUserIndex GetInstance].wifiName isEqual: [NSNull null]]) {
        NSArray *arr = [[AppUserIndex GetInstance].wifiName componentsSeparatedByString:@","];
        for (NSString *wifi in arr) {
            if([wifiName isEqualToString:wifi]){
                isEqual = YES;
                break;
            }
        }
        
        return isEqual;
    }else{
        return NO;
    }

}

+ (NSString *)getIPAddress
{
    NSString *address = @"0.0.0.0";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}


/**
 *  判断网络状态的POST请求
 */
+ (void)requestTarget:(UIViewController*)target POST:(nonnull NSString*)URLString parameters:(nullable id)parameters withVerKey:(NSString *)verKey success:(requestSuccess)success failure:(requestFailureDic)failure
{
    [self requestCache:URLString parameters:parameters withVerKey:verKey  success:success failure:failure];
}

/**
 *  添加Cache
 */
+ (void)requestCache:(nonnull NSString*)URLString parameters:(nullable id)parameters withVerKey:(NSString *)verKey success:(requestSuccess)success failure:(requestFailureDic)failure
{
    
    if (ISCACHE) {
        success(nil,[KSCache selectObjectWithURL:URLString parameter:parameters]);
        [self requestProgress:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
            NSDictionary *lastDic = [KSCache selectObjectWithURL:URLString parameter:parameters];
            NSString *keyPath = [NSString stringWithFormat:@"data.%@",verKey];
            //=====这个判断需要和后台协商，什么情况下请求成功=然后才可以缓寸=====================================================//
//            if ([lastDic[verKey] compare:responseObject[verKey]]== NSOrderedAscending || !lastDic) {
            if ([[lastDic valueForKeyPath:keyPath] compare:[responseObject valueForKeyPath:keyPath]]== NSOrderedAscending || !lastDic) {

                //======================================================//
                [KSCache updateObject:responseObject withURL:URLString parameter:parameters];
                success?success(task,responseObject):nil;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            failure?failure(task,error):nil;
        }];
    }else{
        [self requestPOST:URLString parameters:parameters success:success failure:failure];
    }
}
/**
 *  带活动指示器的请求
 */
+ (void)requestProgress:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailureDic)failure
{
    [ProgressHUD show:@"正在加载..."];
    
    [self requestPOST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        [ProgressHUD showSuccess:@"获取数据成功"];
        
        success?success(task,responseObject):nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:@"网络异常，请检查您的网络！"];
        
        failure?failure(task,error):nil;
    }];
}
//缓存提前获取缓存版本
+ (void)requestCachePost:(nonnull NSString *)URLString parameters:(nullable id)parameters withCacheKeyVersion:(nonnull NSString *)verKey success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure{
    
    success(nil,[KSCache selectObjectWithURL:URLString parameter:parameters]);
    
    NSDictionary *lastDic = [KSCache selectObjectWithURL:URLString parameter:parameters];

    if ([verKey compare:[lastDic valueForKeyPath:@""]] == NSOrderedAscending || !lastDic) {
        [self requestPOST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [KSCache updateObject:responseObject withURL:URLString parameter:parameters];
            success?success(task,responseObject):nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            failure?failure(task,error):nil;
        }];
    }
}
/**
 *  基本POST请求(数据加密解密)
 */
+ (void)requestNewPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailureDic)failure
{

    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *newparams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //base64
    if (ISSECRET) {
            for (NSString *s in [parameters allKeys]) {
            NSString *b = [self TextCode:[parameters objectForKey:s]];
            [newparams setObject:b forKey:s];
        }
    }
    //AES加密
    if (ISAESSECRET) {
            for (NSString *s in [parameters allKeys]) {
            NSString *b = [self AESEnc:[parameters objectForKey:s]];
            [newparams setObject:b forKey:s];
        }

    }
    else{
#warning 这里新加了schoolCode，加密暂时不可用了。需要修改。

        AppUserIndex *appUser = [AppUserIndex GetInstance];
        NSString *role = appUser.role_type;
        //默认为学生
        if (!role) {
            role = @"2";
        }
        
#ifdef isDEBUG
        if (!newparams[@"schoolCode"]) {
            [newparams setObject:@"sdjzu" forKey:@"schoolCode"];

        }
//        [newparams setObject:@"sdmu" forKey:@"schoolCode"];

#else
        if (appUser.schoolCode) {
            [newparams setObject:appUser.schoolCode forKey:@"schoolCode"];
        }
#endif
        [newparams setObject:@"ios" forKey:@"clientOSType"];
        [newparams setObject:role forKey:@"role"];
        [newparams setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"clientVerNum"];
        
        
#ifdef isDEBUG
#else
        if (appUser.token) {
//            [newparams setObject:appUser.token forKey:@"userToken"];
        }
#endif
        
    }
        NSLog(@"[POST]:%@",URLString);
        NSLog(@"parameters:%@",newparams);
    
    [manager POST:URLString parameters:newparams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *cleanString = [decodeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDictionary *dic = [cleanString objectFromJSONString];
            //先判断是否有回调，然后回调

        NSDictionary *resultDic = [[NSDictionary alloc] init];
            if (dic) {
                resultDic = dic;
            }else{
                if (ISAESSECRET) {
                    
                    resultDic = [self AESDec:decodeStr];

                }
                else if (ISSECRET) {
                    resultDic = [self dateToDic:responseObject];

                }else if (ISRSASECRET){
//                    NSMutableString *value_String = [NSMutableString string];
//
//                    for (NSString *obj in responseObject) {
//                        
//                        NSString *value = [NSString stringWithFormat:@"%@",obj];
//                        NSString *score_String = [self RSAdataToDic:value];
//                        1
//                        [value_String appendString:score_String];
//                    }
//                    NSDictionary *newdic = [value_String objectFromJSONString];
//                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
//                    for (NSString *key in [dic allKeys]) {
//                        NSLog(@"--%@",[NSString stringWithFormat:@"%@",dic[key]]);
//                        id obj = [[NSString stringWithFormat:@"%@",dic[key]] objectFromJSONString];
//                        if (obj) {
//                            [mutDic setObject:obj forKey:key];
//                        }else{
//                            [mutDic setObject:dic[key] forKey:key];
//                        }
//                    }
                    resultDic = dic;
                    
                }

            }
        
        if (resultDic) {
            NSLog(@"%@",resultDic);
            NSString *code = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"code"]];
            if ([code isEqualToString:@"0x000000"]||[code isEqualToString:@"0"]) {
                success?success(task,resultDic):nil;
            }else if ([code isEqualToString:@"Util_class_0x00003500000"] || [code isEqualToString:@"MobileCenterController_class_0x0000a300000"]){
                //[ProgressHUD showError:@"账号异常，请重新登录!"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRelogin object:[resultDic objectForKey:@"msg"]];
            }else if ([code isEqualToString:@"Util_class_0x00002143000"]){
                //软件升级
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdate object:@"update"];
            }else{
//                [ProgressHUD dismiss];
                [ProgressHUD showError:[resultDic objectForKey:@"msg"]];
                failure?failure(task,resultDic):NSLog(@"%@",dic);
            }
        }else{
            [ProgressHUD dismiss];
            failure?failure(task,@{@"msg":decodeStr}):NSLog(@"%@",@"");
            NSLog(@"%@",decodeStr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        failure?failure(task,@{@"msg":@""}):NSLog(@"%@",@"");
    }];
}

/**
 RSA数据加密

 @param URLString URL
 @param parameters 参数字典
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)requestPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailureDic)failure
{
    
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *newparams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //base64
    if (ISSECRET) {
        for (NSString *s in [parameters allKeys]) {
            NSString *b = [self TextCode:[parameters objectForKey:s]];
            [newparams setObject:b forKey:s];
        }
    }
    //AES加密
    if (ISAESSECRET) {
        for (NSString *s in [parameters allKeys]) {
            NSString *b = [self AESEnc:[parameters objectForKey:s]];
            [newparams setObject:b forKey:s];
        }
        
    }
    else{
#warning 这里新加了schoolCode，加密暂时不可用了。需要修改。
        AppUserIndex *appUser = [AppUserIndex GetInstance];
        NSString *role = appUser.role_type;
        //默认为学生
        if (!role) {
            role = @"2";
        }
#ifdef isDEBUG
        if (appUser.schoolCode) {
//            [newparams setObject:@"sdjzu" forKey:@"schoolCode"];
            [newparams setObject:appUser.schoolCode forKey:@"schoolCode"];
        }
        //        [newparams setObject:@"sdmu" forKey:@"schoolCode"];
        
#else
        if (appUser.schoolCode) {
            [newparams setObject:appUser.schoolCode forKey:@"schoolCode"];
        }
#endif
        [newparams setObject:@"ios" forKey:@"clientOSType"];
        [newparams setObject:role forKey:@"role"];
        [newparams setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"clientVerNum"];
        
        
#ifdef isDEBUG
#else
        if (appUser.token) {
            //            [newparams setObject:appUser.token forKey:@"userToken"];
        }
#endif
        
    }
    NSLog(@"[POST]:%@",URLString);
    NSLog(@"parameters:%@",newparams);
    NSString *value = [newparams objectForKey:@"rid"];
    BOOL  isRSA = NO;
    if ([value isEqualToString:@"getScoreByInput"]) {
        isRSA = YES;
    }
//    else{
//        isRSA = YES;
//    }
    
    NSDictionary *whiteListDic = [EncryptObject shareEncrypt].whiteListDic;
    isRSA = ![whiteListDic objectForKey:value];
    
    [manager POST:URLString parameters:newparams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [decodeStr objectFromJSONString];
        
        NSDictionary *resultDic = [[NSDictionary alloc] init];
            if (ISAESSECRET) {
                
                resultDic = [self AESDec:decodeStr];
                
            }
            else if (ISSECRET) {
                resultDic = [self dateToDic:responseObject];
                
            }else if (isRSA){
                    NSMutableString *value_String = [NSMutableString string];
                    
                    for (NSString *obj in dic) {
                        
                        NSString *value = [NSString stringWithFormat:@"%@",obj];
                        NSString *score_String = [self RSAdataToDic:value];
                        
                        [value_String appendString:score_String];
                    }
                    NSDictionary *newdic = [value_String objectFromJSONString];
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                    for (NSString *key in [newdic allKeys]) {
                        id obj = [[NSString stringWithFormat:@"%@",newdic[key]] objectFromJSONString];
                        if (obj) {
                            [mutDic setObject:obj forKey:key];
                        }else{
                            [mutDic setObject:newdic[key] forKey:key];
                        }
                    }
                    resultDic = mutDic;
                }else{
                    resultDic = dic;
                NSLog(@"%@",decodeStr);
            }


        if ([resultDic isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",resultDic);
            NSString *code = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"code"]];
            if ([code isEqualToString:@"0x000000"]||[code isEqualToString:@"0"]) {
                success?success(task,resultDic):nil;
            }else if ([code isEqualToString:@"Util_class_0x00003500000"] || [code isEqualToString:@"MobileCenterController_class_0x0000a300000"]){
                //[ProgressHUD showError:@"账号异常，请重新登录!"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRelogin object:[dic objectForKey:@"msg"]];
            }else if ([code isEqualToString:@"Util_class_0x00002143000"]){
                //软件升级
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdate object:@"update"];
            }else{
                if ([dic isKindOfClass:[NSDictionary class]] &&[[dic allKeys] containsObject:@"msg"]) {
                    if ([dic[@"code"] isEqualToString:@"0x000000"]||[dic[@"code"] isEqualToString:@"0"]) {
                        success?success(task,dic):nil;
                    }else{
                        [ProgressHUD showError:[dic objectForKey:@"msg"]];
                        NSLog(@"%@",dic);
                        failure?failure(task,dic):NSLog(@"%@",dic);
                    }
                }else{
                    NSLog(@"%@",decodeStr);
                    failure?failure(task,@{@"msg":@"网络似乎出了一些问题，请稍后重试"}):NSLog(@"%@",@"");
                }
                
            }
        }else{
            NSLog(@"%@",decodeStr);
            failure?failure(task,@{@"msg":@"网络似乎出了一些问题，请稍后重试"}):NSLog(@"%@",dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(task,@{@"msg":@"网络似乎出了一些问题，请稍后重试"}):NSLog(@"%@",@"");
    }];
}

/*
 *系统原生请求
 */
+ (void)requestOriginlTarget:(nonnull NSString*)URLString parameters:(nullable id)parameters isget:(BOOL)isGET block:(Completion)block
{
    // 3.设置请求体
    [self startRequest:parameters url:URLString block:block isget:isGET];
}

+ (void)startRequest:(NSDictionary *)param
                 url:(NSString *)urlString
               block:(Completion)block isget:(BOOL)isGET

{
    NSURL *Url = [NSURL URLWithString:urlString];
    
    PXRequest *request = [PXRequest requestWithURL:Url];
    if (isGET) {
        request.HTTPMethod = @"GET";
        
    }else{
        request.HTTPMethod = @"POST";
    }
    
    if (param) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody=data;
        
    }
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request startAsynrc];
    //当request的block执行时 会执行这里面的代码 block封装一段代码
    request.block = ^(NSData *data){
        if (data.length!=0) {
            NSLog(@"%@",data);
            NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",retStr);
            data = [retStr dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //json解析
            block(json);
            
        }
    };
}
//ASE加密
+(NSString *)AESEnc:(NSString *)param{


    NSString * key = @"1234567812345678";
   
    NSString * gIv = @"1234567812345678";
    
    NSString *encryptionString =[DES3Util AES128Encrypt:param withgKey:key andgiv:gIv];
    return encryptionString;


}
//AES解密
+(NSDictionary *)AESDec:(NSString *)param{

    NSString * key = @"ToplionKvmCplus8908";
    
    NSString * gIv = @"toplion123kvm789";

    NSString *decryptionString =[DES3Util AES128Decrypt:param withgKey:key andgiv:gIv];
    
    NSDictionary *dic = [decryptionString objectFromJSONString];

    return dic;


}

+ (NSDictionary *)dateToDic:(NSData *)responseObject{
    static NSString *beforeStr = @"WkTf89tYs";
    static NSString *afterStr = @"OqN9Ts73u";
    NSString *decodeStr = [self changeGmt64str:responseObject];
    //删除前缀码和后缀码再解码一次
    NSMutableString *mString = [NSMutableString stringWithString:decodeStr];
    NSString *Jsonstr3=[self deleteOringinString:mString withOneString:beforeStr withtwoStr:afterStr];
    
    //string  转data
    NSData *data = [Jsonstr3 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    Jsonstr3 = [self changeGmt64str:data];
    
    NSDictionary *dic = [Jsonstr3 objectFromJSONString];
    return dic;
}

//base加密
+(NSString *)TextCode:(NSString *)schoolInfo{
    static NSString *beforeStr = @"WkTf89tYs";
    static NSString *afterStr = @"OqN9Ts73u";
    //字符串拼接
    NSData *Data=[schoolInfo dataUsingEncoding:NSUTF8StringEncoding];
    //进行编码
    Data =[GTMBase64 encodeData:Data];
    
    NSString *codestr=[[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
    //拼接
    schoolInfo = [NSString stringWithFormat:@"%@%@%@",beforeStr,codestr,afterStr];
    Data = [schoolInfo dataUsingEncoding:NSUTF8StringEncoding];
    schoolInfo = [[NSString alloc]initWithData:[GTMBase64 encodeData:Data] encoding:NSUTF8StringEncoding];
//    NSLog(@"输出%@",schoolInfo);
    
    return schoolInfo;
}
//RSA解密
+(NSString *)RSAdataToDic:(NSString *)my_String
{
    
    CRSA *rea = [CRSA shareInstance];
    NSString *nestSr = [rea decryptByRsa:my_String withKeyType:KeyTypePublic];//解密
//    NSLog(@"%@",nestSr);
    return nestSr;
}
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

/**
 *  基本POST请求(普通)
 */
+ (void)requestNormalPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailureDic)failure
{
//    NSLog(@"[GET]:%@",URLString);
//    NSLog(@"parameters:%@",parameters);
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
        
        
        //先判断是否有回调，然后回调
        success?success(task,responseObject):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@",error);
        
        //如果有回调，则返回处理
        failure?failure(task,error):NSLog(@"%@",error);
    }];
}

/**
 * 加密解密GET请求
 */
+(void)requestGET:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailureDic)failure
{
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSMutableDictionary *newparams = [NSMutableDictionary dictionary];
    //base64
    if (ISSECRET) {
        for (NSString *s in [parameters allKeys]) {
            NSString *b = [self TextCode:[parameters objectForKey:s]];
            [newparams setObject:b forKey:s];
        }
    }
    //AES加密
    if (ISAESSECRET) {
        
        for (NSString *s in [parameters allKeys]) {
            NSString *b = [self AESEnc:[parameters objectForKey:s]];
            [newparams setObject:b forKey:s];
        }
        
    }
    
    else{
        newparams = parameters;
    }

       [manager GET:URLString parameters:newparams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"%@",responseObject);
           
           NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
           NSString *retStr = [[NSString alloc] initWithData:responseObject encoding:enc];

           //先判断是否有回调，然后回调
           if (retStr) {
               success?success(task,retStr):nil;
           }else{
               if (ISAESSECRET) {
                   
                   
                   success?success(task,[self AESDec:retStr]):nil;
                   
               }
               if (ISSECRET) {
                   success?success(task,[self dateToDic:responseObject]):nil;
                   
               }
               if (ISRSASECRET) {
                   NSMutableString *value_String = [NSMutableString string];
                   for (NSDictionary *termDic in responseObject[@"data"]) {
                       NSString *value = [NSString stringWithFormat:@"%@",termDic[@"value"]];
                       NSString *score_String = [self RSAdataToDic:value];
                       [value_String appendString:score_String];
                   }
                   NSDictionary *dic = [self dictionaryWithJsonString:value_String];
                   success?success(task,dic):nil;
               }
               
           }
       //        //先判断是否有回调，然后回调
//        success?success(task,responseObject):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
        //如果有回调，则返回处理
        failure?failure(task,error):NSLog(@"%@",error);
    }];
}
/**
 *基本GET请求
 */
+(void)requestNormalGET:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailureDic)failure
{
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //先判断是否有回调，然后回调
    success?success(task,responseObject):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
        //如果有回调，则返回处理
        failure?failure(task,error):NSLog(@"%@",error);
    }];
}
+(void)networkingGetMethod:(NSDictionary *)parameters urlName:(NSString *)urlName success:(requestSuccess)successBlock failure:(requestFailure)failureBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"html/text",@"text/json", @"text/html", @"text/plain",nil];
    [manager GET:urlName parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        successBlock?successBlock(task,responseObject):nil;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock?failureBlock(task,error):NSLog(@"%@",error);

    }];
    
}
/**
 *  判断网络状态
 *
 *  @return 返回状态 YES 为有网 NO 为没有网
 */
+ (BOOL)checkNetState
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus > 0;
}
/**
 *  创建请求者
 *
 *  @return AFHTTPSessionManager
 */
+ (AFHTTPSessionManager*)getManager
{
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    
    
    //设置请求超时
    manager.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"html/text",@"text/json", @"text/html", @"text/plain",nil];
    return manager;
}

//base64解码
+(NSString *)changeGmt64str:(NSData *)encodeData{
    
    NSData *data = encodeData;
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *decodeStr = nil;
    NSData *gmtData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decodeData = [GTMBase64 decodeData:gmtData];
    decodeStr = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
    return decodeStr;
    
    
}
//删除字符串的特定字符串
+(NSString *)deleteOringinString:(NSMutableString *)oringinStr withOneString:(NSString *)oneStr withtwoStr:(NSString *)twoStr{
    
    NSMutableString *mString = [NSMutableString stringWithString:oringinStr];
    NSString *str2 = [mString stringByReplacingOccurrencesOfString:oneStr withString:@""];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:twoStr withString:@""];
    
    return str3;
    
}

+ (void)uploadImage:(UIImage *)image success:(requestSuccess)success failure:(requestFailureDic)failure{
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"schoolCode":[AppUserIndex GetInstance].schoolCode}];
    
    [manager POST:[NSString stringWithFormat:@"%@upload_image.php",[AppUserIndex GetInstance].uploadUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 获取图片数据
        NSData *fileData = UIImageJPEGRepresentation(image, 0.3);
        // 设置上传图片的名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *type = [self typeForImageData:fileData];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", str,type];
        
        [formData appendPartWithFileData:fileData name:@"image" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 返回结果
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [decodeStr objectFromJSONString];
        NSLog(@"%@",dic);
//        [ProgressHUD showSuccess:@"发布成功!"];
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSString *decodeStr = [[NSString alloc]initWithData:error encoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [decodeStr objectFromJSONString];
//        failure(task,dic);
    }];
}
+ (void)uploadPhotoImagewithParams:(UIImage * _Null_unspecified)image WithParams:(nullable id)params success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure  progress:(nonnull requestProgress)progress
{
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AppUserIndex *appUser = [AppUserIndex GetInstance];
    // 设置请求参数
    NSMutableDictionary *newparams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    
    [newparams setObject:appUser.schoolCode forKey:@"schoolCode"];
    
    [manager POST:[NSString stringWithFormat:@"%@upload_image.php",[AppUserIndex GetInstance].uploadUrl] parameters:newparams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 获取图片数据
        NSData *fileData = UIImageJPEGRepresentation(image, 0.8);
        // 设置上传图片的名字
        NSInteger length = [fileData length]/1000;
        NSLog(@"%ld",length);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *type = [self typeForImageData:fileData];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", str,type];
        
        [formData appendPartWithFileData:fileData name:@"image" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 返回结果
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [decodeStr objectFromJSONString];
        NSLog(@"%@",dic);
        //        [ProgressHUD showSuccess:@"发布成功!"];
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
+ (void)uploadChatImagewithParams:(ALAsset * _Null_unspecified)image WithParams:(nullable id)params success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure  progress:(nonnull requestProgress)progress
{
    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AppUserIndex *appUser = [AppUserIndex GetInstance];
    // 设置请求参数
    NSMutableDictionary *newparams = [NSMutableDictionary dictionaryWithDictionary:params];
    

    [newparams setObject:appUser.schoolCode forKey:@"schoolCode"];
    
    [manager POST:[NSString stringWithFormat:@"%@upload_image.php",[AppUserIndex GetInstance].uploadUrl] parameters:newparams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ALAsset *result = image;
        ALAssetRepresentation *rep = [result defaultRepresentation];
        Byte *imageBuffer = (Byte*)malloc(rep.size);
        NSError *error;
        NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:rep.size error:&error];
        NSLog(@"%@",error);
        NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
        // 获取图片数据
        NSString *type = [self typeForImageData:imageData];
        //不是GIF的话 对图片进行压缩
        if (![type isEqualToString:@"gif"]) {
            CGImageRef cimg =[[result defaultRepresentation] fullResolutionImage];
            UIImage *img = [UIImage imageWithCGImage:cimg];//aspectRatioThumbnail
            // 获取图片数据
            imageData= UIImageJPEGRepresentation(img, 0.6);
            // 设置上传图片的名字
        }else{
            ALAssetRepresentation *re = [result defaultRepresentation];;
            NSUInteger size = (NSUInteger)re.size;
            uint8_t *buffer = malloc(size);
            NSError *error;
            NSUInteger bytes = [re getBytes:buffer fromOffset:0 length:size error:&error];
            NSData *data = [NSData dataWithBytes:buffer length:bytes];//这个就是选取的GIF图片的原二进制数据
            imageData = data;
            free(buffer);
        }
        // 设置上传图片的名字
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", str,type];
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@",type]];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 返回结果
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [decodeStr objectFromJSONString];
        NSLog(@"%@",dic);
        //        [ProgressHUD showSuccess:@"发布成功!"];
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


+ (void)uploadImage:(UIImage *)image withURL:(NSString*)url withParams:(nullable id)params success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure{

    // 获得网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AppUserIndex *appUser = [AppUserIndex GetInstance];
    // 设置请求参数
    NSMutableDictionary *newparams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [newparams setObject:appUser.schoolCode forKey:@"schoolCode"];
    
    [manager POST:[NSString stringWithFormat:@"%@upload_image.php",url] parameters:newparams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 获取图片数据
        NSData *fileData = UIImageJPEGRepresentation(image, 0.8);
        
        NSInteger length = [fileData length]/1000;
        NSLog(@"%ld",length);
        // 设置上传图片的名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *type = [self typeForImageData:fileData];
        NSString *fileName = [NSString stringWithFormat:@"%@.%@", str,type];
        
        [formData appendPartWithFileData:fileData name:@"image" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 返回结果
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [decodeStr objectFromJSONString];
        NSLog(@"%@",dic);
        //        [ProgressHUD showSuccess:@"发布成功!"];
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


+(NSString *)typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
    }
    
    return nil;
    
}

/**
 *  登录
 *
 *  @param userName 用户名
 *  @param success
 *  @param failure  
 */

+ (void)queryUserInfoWithName:(nonnull NSString*)userName success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure{

    AppUserIndex *user = [AppUserIndex GetInstance];
    
    if (user.isNewEntry && user.aNewEntryId) {
        userName = user.aNewEntryId;
    }
    
    NSDictionary *userDic = @{
                              @"rid":@"queryUserInfo",
                              @"username":userName,
                              @"isNewEntry":@(user.isNewEntry)
                              };
    [NetworkCore requestPOST:user.API_URL parameters:userDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    
        [user yy_modelSetWithDictionary:responseObject];

        if (![ConfigObject shareConfig].isGetInfo) {
            [NetworkCore getAllPayInfoSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//                failure?failure(task,error):NSLog(@"%@",error);
                success(task,responseObject);
            }];
        }else{
            success(task,responseObject);
        }
        
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {

        failure?failure(task,error):NSLog(@"%@",error);

    }];
    
}

+ (void)getAllPayInfoSuccess:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAllPayInfo", @"userid":[AppUserIndex GetInstance].accountId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ConfigObject shareConfig].isGetInfo = YES;
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            [[ConfigObject shareConfig] setPayInfo:responseObject[@"data"]];
        }
        
        if ([AppUserIndex GetInstance].isNewEntry) {
            [NetworkCore updateUserSuccess:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                failure?failure(task,error):NSLog(@"%@",error);
            }];
        }else{
            success(task,responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        NSLog(@"%@",error);
        failure?failure(task,error):NSLog(@"%@",error);
    }];
}

+ (void)updateUserSuccess:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure{
    UIDevice *curDev = [UIDevice currentDevice];
    AppUserIndex *user = [AppUserIndex GetInstance ];
    //设备唯一编号
    
    NSDictionary *params = @{
                             @"rid" : @"updateUser",
                             @"username" :user.role_id,
                             @"password":user.passWord?user.passWord:@"",
                             @"schoolId":user.schoolId,
                             @"deviceNum":[NSString stringWithFormat:@"%@",[curDev.identifierForVendor UUIDString]],
                             @"simNum":@"0",
                             @"subscriberNum":@"0",
                             @"imsiNum":@"0",
                             @"deviceMode":@"0",
                             @"osType":[NSString stringWithFormat:@"ios%.1f",[[curDev systemVersion] floatValue]],
                             @"phone":user.userInputPhonenum?user.userInputPhonenum:@""
                             };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {

       success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:@"登录失败，请重新登录"];
        failure?failure(task,error):NSLog(@"%@",error);
    }];
}

#pragma mark 带MD5加密的
/**
 *  基本POST请求(数据加密解密)
 */
+ (void)requestMD5POST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailureDic)failure
{
    
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *newparams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
        AppUserIndex *appUser = [AppUserIndex GetInstance];
//        NSString *role = appUser.role_type;
//        //默认为学生
//        if (!role) {
//            role = @"2";
//        }
//        
//#ifdef isDEBUG
//        if (!newparams[@"schoolCode"]) {
//            [newparams setObject:@"sdjzu" forKey:@"scode"];
//            
//        }
//#else
//        if (appUser.schoolCode) {
//            [newparams setObject:appUser.schoolCode forKey:@"scode"];
//        }
//#endif
//        [newparams setObject:@"ios" forKey:@"clientOSType"];
//        [newparams setObject:role forKey:@"role"];
//        [newparams setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"clientVerNum"];
    
    //MD5加密
    NSLog(@"[POST]:%@",URLString);
    NSLog(@"parameters:%@",newparams);
    NSString *key =[EncryptObject md532BitLower:appUser.schoolName];
    NSString *newKey = [EncryptObject md532BitLower:key];
    //得到MD5key
    NSMutableString *newString =[NSMutableString string];
//    NSString *flagString ;
    NSMutableArray  *keyArray = [NSMutableArray array];
    NSArray *flagKeyArr = [parameters[@"flag"] componentsSeparatedByString:@","];
    
    for (NSString *key in flagKeyArr) {
        NSString *value = [newparams objectForKey:key];
        [keyArray addObject:key];
        [newString appendString:value];
    }
    
    [newString appendString:newKey];
    NSString *md5Key = [EncryptObject md532BitLower:newString];
    [newparams setObject:md5Key forKey:@"md5sign"];
    [newparams removeObjectForKey:@"flag"];
    [manager POST:URLString parameters:newparams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *cleanString = [decodeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDictionary *dic = [cleanString objectFromJSONString];
        //先判断是否有回调，然后回调
        
        NSDictionary *resultDic = [[NSDictionary alloc] init];
        if (dic) {
            resultDic = dic;
        }
        
        if (resultDic) {
            NSLog(@"%@",resultDic);
            NSString *code = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"status"]];
            if ([code isEqualToString:@"OK"]) {
                if ([dic[@"content"] isKindOfClass:[NSString class]]) {
                    if ([[dic objectForKey:@"content"] objectFromJSONString] ==nil) {
                        success?success(task,[dic objectForKey:@"content"]):nil;
                    }else{
                        success?success(task,[[dic objectForKey:@"content"] objectFromJSONString]):nil;
                    }
                }else{
                    success?success(task,[dic objectForKey:@"content"]):nil;
 
                }
//                success?success(task,dic[@"content"]):nil;

            }else if ([code isEqualToString:@"ERROR"] ){
                [ProgressHUD dismiss];
                failure?failure(task,resultDic):NSLog(@"%@",[dic[@"content"] objectFromJSONString]);
            }else{
                [ProgressHUD dismiss];
                failure?failure(task,resultDic):NSLog(@"%@",[dic[@"content"] objectFromJSONString]);
            }
        }else{
            [ProgressHUD dismiss];
            failure?failure(task,@{@"msg":decodeStr}):NSLog(@"%@",@"");
            NSLog(@"%@",decodeStr);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        failure?failure(task,@{@"msg":@""}):NSLog(@"%@",@"");
    }];
}
+ (NSComparisonResult)compare: (NSDictionary *)otherDictionary{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
    NSNumber *number2 = [[otherDictionary allKeys] objectAtIndex:0];
    NSComparisonResult result = [number1 compare:number2];
    
    return result == NSOrderedDescending; // 升序
    //    return result == NSOrderedAscending;  // 降序
}
@end
