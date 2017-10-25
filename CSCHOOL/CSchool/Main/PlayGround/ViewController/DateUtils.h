//
//  DateUtils.h
//  Course
//
//  Created by MacOS on 14-12-17.
//  Copyright (c) 2014年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

//获取本周的日期数组
+ (NSArray *)getDatesOfCurrence;

//获取距本周多少个周的日期数组,参数为1就代表下周，参数为2就是下下周，参数为-1就是上周
+ (NSArray *)getDatesSinceCurence:(int)weeks;

//根据给定的字符串 “001110011” 切割成数组
+ (NSArray *)getWeekIsHaveClassArray:(NSString *)weekStr;

@end
