//
//  KSNetRequest.h
//  Test
//
//  Created by KS on 15/11/24.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
///  成功回调
typedef void (^requestSuccess)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject);
///  失败回调
typedef void (^requestFailure)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error);

typedef void (^requestProgress)(NSProgress * _Nonnull uploadProgress);

//失败回调传回字典
typedef void (^requestFailureDic)(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error);


@interface KSNetRequest : NSObject


/**
 *  检测网络状态下的POST请求
 *
 *  @param target     请求控制器
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestTarget:(nonnull UIViewController*)target POST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nullable requestSuccess)success failure:(nullable requestFailure)failure;

/**
 *  普通POST请求(加密)
 *
 *  @param URLString  请求接口
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nullable requestSuccess)success failure:(nullable requestFailure)failure;

/**
 *  普通POST请求
 *
 *  @param URLString  请求接口
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestNormalPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess _Null_unspecified)success failure:(requestFailure _Null_unspecified)failure;
/**
 *  普通GET请求
 *
 *  @param URLString  请求接口
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestGET:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nullable requestSuccess)success failure:(nullable requestFailure )failure;
//带指示器的请求
+ (void)requestProgress:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(requestSuccess _Null_unspecified)success failure:(requestFailure _Null_unspecified)failure;

@end
