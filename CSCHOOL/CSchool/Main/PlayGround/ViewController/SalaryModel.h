//
//  SalaryModel.h
//  CSchool
//
//  Created by mac on 16/11/28.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
@interface SalaryModel : NSObject
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
 [sectionValueArr addObject:@[dic[@"公积金"],dic[@"养老保险"],dic[@"医疗保险"],dic[@"税前扣款"],dic[@"计税工资"],dic[@"个税减免系数"],dic[@"个人所得税"],dic[@"其它扣"]]];
 */
@property (nonatomic,copy)NSString *yingFaSalary;//应发工资:
@property (nonatomic,copy)NSString *shiFaSalary;//实发工资
@property (nonatomic,copy)NSString *gangWeiSalary;//岗位工资
@property (nonatomic,copy)NSString *xinJiSalary;//薪级工资;
@property (nonatomic,copy)NSString *jiChuJixiao;//基础绩效
@property (nonatomic,copy)NSString *jiangLiJiXiao;//奖励绩效
@property (nonatomic,copy)NSString *zhuFangBuTie;//住房补贴
@property (nonatomic,copy)NSString *wuYeBuTie;//物业补贴
@property (nonatomic,copy)NSString *qiTaBuTie1;//其他补1

@property (nonatomic,copy)NSString *qiTaBuTie2;//其他补2
@property (nonatomic,copy)NSString *gongJiJin;//公积金
@property (nonatomic,copy)NSString *yangLaobaoXian;//养老保险
@property (nonatomic,copy)NSString *yiLiaoBaoxian;//医疗保险
@property (nonatomic,copy)NSString *shuiQianKouKuan;//税前扣款
@property (nonatomic,copy)NSString *jiShuiGongzi;//计税工资

@property (nonatomic,copy)NSString *geShuiJianMian;//个税减免系数
@property (nonatomic,copy)NSString *geRenSuodeShui;//个人所得税
@property (nonatomic,copy)NSString *qiTaKou;//其他扣
@property (nonatomic,copy)NSString *montnNum;//月份
@end
