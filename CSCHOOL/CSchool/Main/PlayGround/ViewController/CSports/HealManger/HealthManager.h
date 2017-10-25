//
//  HealthManager.h
//  CSchool
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
typedef void(^LocationBlock)(NSArray *objArr,NSArray *locationNameArr);

@interface HealthManager : NSObject
@property (nonatomic,strong) HKHealthStore *healthStore;

@property (nonatomic, copy) LocationBlock loctationBlock;

+(HealthManager *)shareInstance;

/**
 获取权限

 @param handler 返回成功或者失败
 */
- (void)getPermissions:(void(^)(BOOL value, NSError *error))handler;


/*!
 *  @author Lcong, 15-04-20 18:04:38
 *
 *  @brief  获取当天实时步数
 *
 *  @param handler 回调
 */
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 15-04-20 18:04:34
 *
 *  @brief  获取一定时间段步数
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 15-04-20 18:04:32
 *
 *  @brief  获取卡路里
 *
 *  @param predicate    时间段
 *  @param quantityType 样本类型
 *  @param handler      回调
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 15-04-20 18:04:17
 *
 *  @brief  当天时间段
 *
 *  @return ,,,
 */
+ (NSPredicate *)predicateForSamplesToday;

/**
 开始定位
 */
-(void)startLocation;

@end
