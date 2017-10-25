//
//  PersonInfoModel.m
//  CSchool
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PersonInfoModel.h"
/*
 NJDM 年级
 YXDM 院系
 JTDZ 家庭地址
 ZYDM 专业
 ZZMMDM 政治面貌
 ZZMM 政治面貌
 JTDH 家庭电话
 XH 学号
 SJH 手机号
 LXDH 联系电话
 XM 姓名
 YXMC 院系名称
 ZYMC 专业名称
 **/
@implementation PersonInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"NJDM" : @"NJDM",
             @"YXDM" : @"YXDM",
             @"JTDZ" : @"JTDZ",
             @"ZYDM" : @"ZYDM",
             @"ZZMMDM" : @"ZZMMDM",
             @"ZZMM" : @"ZZMM",
             @"JTDH" : @"JTDH",
             @"XH" : @"XH",
             @"SJH" : @"SJH",
             @"LXDH" : @"LXDH",
             @"XM" : @"XM",
             @"YXMC" : @"YXMC",
             @"ZYMC" : @"ZYMC"
             };
}
@end
