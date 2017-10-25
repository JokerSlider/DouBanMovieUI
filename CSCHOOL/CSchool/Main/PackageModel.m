//
//  PackageModel.m
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PackageModel.h"
@implementation PackageModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"mealName" : @"mealName",
             @"discountExplain" : @"discountExplain",
             @"timelength" : @"timelength",
             @"discountDes" : @"discountDes",
             @"remark" : @"remark",
             };
    }

@end
