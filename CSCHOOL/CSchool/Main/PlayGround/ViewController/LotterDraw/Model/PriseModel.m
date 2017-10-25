//
//  PriseModel.m
//  CSchool
//
//  Created by mac on 17/5/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "PriseModel.h"
@implementation PriseModel
/*
 @property (nonatomic,copy)NSString *awardName;
 @property (nonatomic,copy)NSString *redeemCode;//兑奖码
 @property (nonatomic,copy)NSString *awardId;//奖品ID
 
 @property (nonatomic,copy)NSString *stuNo;// 学号
 @property (nonatomic,copy)NSString *schoolCode;// 学校识别码
 @property (nonatomic,copy)NSString *wintime;// 中奖时间
 @property (nonatomic,copy)NSString *isReceive;// 是否领取
 @property (nonatomic,copy)NSString *receiveUsr;// 领取人
 @property (nonatomic,copy)NSString *receivePhone ;//领取人联系电话
 @property (nonatomic,copy)NSString *receiveTime ;//领取时间
 @property (nonatomic,copy)NSString *activityName;// 活动名称
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"priseID" : @"id",
             @"priseName" : @"name",
             @"priseContent" : @"content",
             @"prisecount" : @"count",
             @"destription" : @"des",
             @"picUrl":@"pic",
             @"awardName":@"awardName",
             @"redeemCode":@"redeemCode",
             @"awardId":@"awardId",
             @"awardPic":@"awardPic",
             @"restcount":@"restcount",
             @"stuNo":@"stuNo",
             @"wintime":@"wintime",
             @"isReceive":@"isReceive",
             @"receiveUsr":@"receiveUsr",
             @"receivePhone":@"receivePhone",
             @"receiveTime":@"receiveTime",
             @"activityName":@"activityName",
             @"prizeName":@"prizeName"
             };
}
@end
