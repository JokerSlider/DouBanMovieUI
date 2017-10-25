//
//  SalaryModel.m
//  CSchool
//
//  Created by mac on 16/11/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SalaryModel.h"
#import <YYModel.h>

@implementation SalaryModel
/*
 [sectionKeyArr addObject:@[@"应发工资:",@"实发工资:"]];
 [sectionValueArr addObject:@[dic[@"应发"],dic[@"实发"]]];
 [sectionKeyArr addObject:@[@"岗位工资:",@"薪级工资:"]];
 [sectionValueArr addObject:@[dic[@"岗位工资"],dic[@"薪级工资"]]];
 
 [sectionKeyArr addObject:@[@"基础绩效:",@"奖励绩效:"]];
 [sectionValueArr addObject:@[dic[@"基础绩效"],dic[@"奖励绩效1"]]];
 
 [sectionKeyArr addObject:@[@"住房补贴:",@"物业补贴:",@"其他补1:",@"其他补2:"]];
 [sectionValueArr addObject:@[dic[@"住房补贴"],dic[@"物业补贴"],dic[@"其他补1"],dic[@"其他补2"]]];
 
 [sectionKeyArr addObject:@[@"公积金:",@"养老保险:",@"医疗保险:",@"税前扣款:",@"计税工资:",@"个税减免系数:",@"个人所得税:",@"其他扣:"]];
 [sectionValueArr addObject:@[dic[@"公积金"],dic[@"养老保险"],dic[@"医疗保险"],dic[@"税前扣款"],dic[@"计税工资"],dic[@"个税减免系数"],dic[@"个人所得税"],dic[@"其它扣"]]]; */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"yingFaSalary" : @"应发",
             @"shiFaSalary" : @"实发",
             @"gangWeiSalary" : @"岗位工资",
             @"xinJiSalary" : @"薪级工资",
             @"jiChuJixiao" : @"基础绩效",
             @"jiangLiJiXiao": @"奖励绩效1",
             @"zhuFangBuTie":@"住房补贴",
             @"wuYeBuTie":@"物业补贴",
             @"qiTaBuTie1":@"其他补1",
             @"qiTaBuTie2" : @"其他补2",
             @"gongJiJin" : @"公积金",
             @"yangLaobaoXian" : @"养老保险",
             @"yiLiaoBaoxian" : @"医疗保险",
             @"shuiQianKouKuan":@"税前扣款",
             @"jiShuiGongzi":@"计税工资",
             @"geShuiJianMian":@"个税减免系数",
             @"geRenSuodeShui" : @"个人所得税",
             @"qiTaKou":@"其它扣",
             @"monthNum":@"月份"
             };
}

@end
