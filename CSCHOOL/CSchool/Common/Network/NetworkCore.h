//
//  NetworkCore.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

//返回void 参数id 名字Completion
typedef void(^Completion)(_Null_unspecified id responseObject);
@interface NetworkCore : NSObject

/**
 *获取mac地址
 */
+ (NSString *_Nullable)getMacInfo;

/**
 *系统原生请求
 */
+ (void)requestOriginlTarget:(nonnull NSString*)URLString parameters:(nullable id)parameters isget:(BOOL)isGET block:( _Null_unspecified Completion)block;

/**
 *  判断当前链接的wifi是否与预定wifi一致
 *
 *  @return
 */
+(BOOL)wifiIsEqual;

/**
 *  当前链接wifi名字
 *
 *  @return
 */
+ (nonnull NSString *)getWifiName;

/**
 *  获取wifi BSSID
 *
 *  @return
 */
+ (nonnull NSString *)getBSSID;

//转换mac地址（去冒号，单位数补0）
+ (nonnull NSString *)translateMacAdd:(nonnull NSString *)bssid;

/**
 *  获取IP地址
 *
 *  @return IP地址
 */
+ (nonnull NSString *)getIPAddress;

/**
 *  POST请求，带指示器，带缓存
 *
 *  @param target     请求控制器
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param verKey     请求版本号比对key
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)requestTarget:(nonnull UIViewController*)target POST:(nonnull NSString*)URLString parameters:(nullable id)parameters withVerKey:(nonnull NSString *)verKey success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;


/**
 *  缓存提前获取缓存版本
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param verKey     缓存对比号码，为CacheObject中的属性
 *  @param success
 *  @param failure
 */
+ (void)requestCachePost:(nonnull NSString *)URLString parameters:(nullable id)parameters withCacheKeyVersion:(nonnull NSString *)verKey success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;

/**
 *  基本POST请求(数据加密)
 */
+ (void)requestPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;
/**
 *  基本POST请求(RSA加密)
 */
+ (void)requestNewPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;

/**
 *  基本POST请求(普通)
 */
+ (void)requestNormalPOST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;
/**
 *  基本GET请求(普通)
 */
+(void)requestNormalGET:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;
/**
 *  加密解密GET请求(普通)
 */

+(void)requestGET:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;

/**
 *  登录接口
 */
+ (void)queryUserInfoWithName:(nonnull NSString*)userName success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;

/**
 *  获取缴费配置信息
 */
+ (void)getAllPayInfoSuccess:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;

//ASE加密
+(NSString * _Null_unspecified )AESEnc:(NSString * _Null_unspecified )param;

/**
 *  上传图片（二手市场、兼职招聘、寻物招领）
 *
 *  @param image   图片
 *  @param success
 *  @param failure 
 */
+ (void)uploadImage:(UIImage * _Null_unspecified )image success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;
/**
 *  上传头像
 *
 *  @param image   图片
 *  @param params  参数
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)uploadPhotoImagewithParams:(UIImage * _Null_unspecified)image WithParams:(nullable id)params success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure  progress:(nonnull requestProgress)progress;

/**
 *  上传图片通用接口
 *
 *  @param image   图片
 *  @param url     图片地址
 *  @param params  参数
 *  @param success
 *  @param failure
 */
+ (void)uploadImage:(UIImage * _Null_unspecified)image withURL:(nonnull NSString*)url withParams:(nullable id)params success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;

/**
 聊天上传图片接口

 @param image 获取到的相册资源
 @param params 参数字典
 @param success 成功的回调
 @param failure 失败的回调
 @param progress 进度
 */
+ (void)uploadChatImagewithParams:(ALAsset * _Null_unspecified)image WithParams:(nullable id)params success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure  progress:(nonnull requestProgress)progress;

/**
 基础get请求

 @param parameters <#parameters description#>
 @param urlName <#urlName description#>
 @param successBlock <#successBlock description#>
 @param failureBlock <#failureBlock description#>
 */
+(void)networkingGetMethod:(NSDictionary *_Null_unspecified)parameters urlName:(NSString *_Null_unspecified)urlName success:(requestSuccess _Null_unspecified)successBlock failure:(requestFailure _Null_unspecified)failureBlock;

/**
 OA办公MD5加密接口

 @param URLString 请求地址
 @param parameters 参数
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)requestMD5POST:(nonnull NSString*)URLString parameters:(nullable id)parameters success:(nonnull requestSuccess)success failure:(nonnull requestFailureDic)failure;


/**
 判断文件类型

 @param data 图片数据
 @return 返回类型
 */
+(NSString *)typeForImageData:(NSData *)data;

@end
