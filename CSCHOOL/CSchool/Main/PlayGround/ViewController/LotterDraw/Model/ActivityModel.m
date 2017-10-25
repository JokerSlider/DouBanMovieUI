//
//  ActivityModel.m
//  CSchool
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ActivityModel.h"
/*
 @property (nonatomic,copy)NSString *activietyID;//互动ID
 @property (nonatomic,copy)NSString *name;//name 活动名称
 @property (nonatomic,copy)NSString *content;//content 活动描述
 @property (nonatomic,copy)NSString *startTime;//startTime 开始时间
 @property (nonatomic,copy)NSString *endTime; //endTime 结束时间
 @property (nonatomic,copy)NSString *actstatus;//actstatus 活动状态(1代表即时出结果，2代表最后出结果0代表其他活动 , 目前只使用1)
 @property (nonatomic,copy)NSString *status;//状态（0.未开始，1.进行中， 2.已结束 需根据此判断是否可以点击
 */
@implementation ActivityModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"activietyID" : @"id",
             @"name" : @"name",
             @"content" : @"content",
             @"startTime" : @"startTime",
             @"endTime" : @"endTime",
             @"picUrl":@"pic",
             @"actstatus":@"actstatus",
             @"status":@"status"
             };
}
@end
