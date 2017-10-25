//
//  DouBNetCore.h
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/22.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
///  成功回调
typedef void (^requestSuccess)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject);
///  失败回调
typedef void (^requestFailure)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error);

//失败回调传回字典
typedef void (^requestFailureDic)(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error);

@interface DouBNetCore : NSObject

+ (void)requestNewPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;

+(void)requestNormalGET:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;


@end
