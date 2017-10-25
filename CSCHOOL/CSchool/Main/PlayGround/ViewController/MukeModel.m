//
//  MukeModel.m
//  CSchool
//
//  Created by mac on 16/11/5.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MukeModel.h"
#import <YYModel.h>
@implementation MukeModel
/*@property (nonatomic,copy)NSString *ctImgUrl;//图片地址
 @property (nonatomic,copy)NSString *name;//课程名
 @property (nonatomic,copy)NSString *enrollCount;//已有多少人参加
 @property (nonatomic,copy)NSString *ctStartTime;//开始时间
 @property (nonatomic,copy)NSString *ctEndTime;
 @property (nonatomic,copy)NSString *ctUrl;*/
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ctImgUrl" : @"ctImgUrl",
             @"name" : @"name",
             @"enrollCount" : @"enrollCount",
             @"ctStartTime" : @"ctStartTime",
             @"ctEndTime" : @"ctEndTime",
             @"ctUrl":@"ctUrl"
             };
}

@end
