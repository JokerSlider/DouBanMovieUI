//
//  KSNetRequest.m
//  Test
//
//  Created by KS on 15/11/24.
//  Copyright © 2015年 xianhe. All rights reserved.
//
#import "KSCache.h"

#import "KSNetRequest.h"
#import <AFNetworking.h>
#import "ProgressHUD.h"
#import "UIViewController+KSNoNetController.h"
#import "GTMBase64.h"
#import <JSONKit.h>

//===========================请求超时时间==========================//
#define TIMEOUTINTERVAL 30
//====================是不是需要缓存==YES需要==NO不需要====================//
#define ISCACHE YES


@interface KSNetRequest ()

@end

@implementation KSNetRequest

/**
 *  判断网络状态的POST请求
 */
+ (void)requestTarget:(UIViewController*)target POST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailure)failure
{
    if ([self checkNetState]) {
        [target hiddenNonetWork];
        
        [self requestCache:URLString parameters:parameters success:success failure:failure];
        
    }else{
        [target showNonetWork];
    
        success?success(nil,nil):nil;
        failure?failure(nil,nil):nil;
    }
}

/**
 *  添加Cache
 */
+ (void)requestCache:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailure)failure
{
    
    if (ISCACHE) {
        success(nil,[KSCache selectObjectWithURL:URLString parameter:parameters]);
        [self requestProgress:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            #warning warning
            //=====这个判断需要和后台协商，什么情况下请求成功=然后才可以缓寸=====================================================//
            if ([responseObject[@"result"] isEqualToString:@"0"]) {
            //======================================================//
                [KSCache updateObject:responseObject withURL:URLString parameter:parameters];
                
            }
            success?success(task,responseObject):nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            failure?failure(task,error):nil;
        }];
    }else{
        [self requestProgress:URLString parameters:parameters success:success failure:failure];
    }
}
/**
 *  带活动指示器的请求
 */
+ (void)requestProgress:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailure)failure
{
    
    [ProgressHUD show:@"正在登录中..."];
    
    [self requestPOST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        
        success?success(task,responseObject):nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        [NSThread sleepForTimeInterval:1.5f];

        [ProgressHUD dismiss];
        
        failure?failure(task,error):nil;
    }];
}
/**
 *  基本POST请求(数据加密)
 */
+ (void)requestPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailure)failure
{
    NSLog(@"[GET]:%@",URLString);
    NSLog(@"parameters:%@",parameters);
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        
        //GTM64编码前缀和后缀
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
        
        
        
        //先判断是否有回调，然后回调
        success?success(task,dic):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);

        //如果有回调，则返回处理
        failure?failure(task,error):NSLog(@"%@",error);
    }];
}

/**
 *  基本POST请求(普通)
 */
+ (void)requestNormalPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailure)failure
{
    NSLog(@"[GET]:%@",URLString);
    NSLog(@"parameters:%@",parameters);
    

    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        NSString *A = [[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
        NSLog(@"____%@",A);
        
        
        //先判断是否有回调，然后回调
        success?success(task,responseObject):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [NSThread sleepForTimeInterval:1.5f];

        NSLog(@"%@",error);
        
        //如果有回调，则返回处理
        failure?failure(task,error):NSLog(@"%@",error);
    }];
}

/**
 *  基本GET请求
 */
+ (void)requestGET:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess)success failure:(requestFailure)failure
{
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
//        NSLog(@"%@",responseObject);
        //先判断是否有回调，然后回调
        success?success(task,responseObject):nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //如果有回调，则返回处理
        failure?failure(task,error):NSLog(@"%@",error);
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
    decodeStr = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding  ];
    return decodeStr;
    
    
}
//删除字符串的特定字符串
+(NSString *)deleteOringinString:(NSMutableString *)oringinStr withOneString:(NSString *)oneStr withtwoStr:(NSString *)twoStr{
    
    NSMutableString *mString = [NSMutableString stringWithString:oringinStr];
    NSString *str2 = [mString stringByReplacingOccurrencesOfString:oneStr withString:@""];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:twoStr withString:@""];
    
    return str3;
    
}
@end
