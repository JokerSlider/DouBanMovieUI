//
//  DouBNetCore.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "DouBNetCore.h"
#import <AFNetworking.h>
#import <JSONKit.h>


#define TIMEOUTINTERVAL   10  //网络超时时间
//返回void 参数id 名字Completion
typedef void(^Completion)(_Null_unspecified id responseObject);
@implementation DouBNetCore
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

+ (void)requestNewPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure
{
    
    AFHTTPSessionManager* manager = [self getManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *newparams = [NSMutableDictionary dictionaryWithDictionary:parameters];

#ifdef isDEBUG
    
    
#else
    
    
#endif
//        [newparams setObject:@"ios" forKey:@"clientOSType"];
//        [newparams setObject:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"clientVerNum"];
    
        
#ifdef isDEBUG
#else
       
#endif
    NSLog(@"[POST]:%@",URLString);
    NSLog(@"parameters:%@",newparams);
    
    [manager POST:URLString parameters:newparams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSString *decodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [decodeStr objectFromJSONString];
        //先判断是否有回调，然后回调
        NSDictionary *resultDic = [[NSDictionary alloc] init];
        resultDic = dic;    
        if (resultDic) {
//            NSLog(@"%@",resultDic);
//            NSString *code = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"code"]];
//            if ([code isEqualToString:@"0x000000"]||[code isEqualToString:@"0"]) {
//                success?success(task,resultDic):nil;
//            }else{
//                failure?failure(task,resultDic):NSLog(@"%@",dic);
//            }
            success?success(task,resultDic):nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure?failure(task,@{@"msg":@"网络故障，请稍后重试"}):NSLog(@"%@",@"");
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


@end
