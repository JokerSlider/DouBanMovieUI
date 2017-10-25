//
//  NSDate+CH.h
//  新闻
//
//  Created by Think_lion on 15/5/16.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CH)

//判断是否为今天
-(BOOL)isToday;
//判断是否为昨天
-(BOOL)isYesterday;
//判断是否为今年
-(BOOL)isThisYear;
//获得与当前时间的差距
-(NSDateComponents *)deltaWithNow;

- (NSDate *)dateWithYMD;

/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour  WithCurrentData:(NSDate *)currentDate;
//过期的方法
/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour;


/**
 判断两个时间的时间差

 @param startTime 开始时间
 @param endTime 下一个节点的时间
 @return 返回是否超过半小时
 */
+ (BOOL)dateTimeDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime;

@end
