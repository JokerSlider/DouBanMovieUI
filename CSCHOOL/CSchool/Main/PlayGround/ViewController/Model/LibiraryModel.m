
//
//  LibiraryModel.m
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibiraryModel.h"
#import <YYModel.h>
/*
 "M_TITLE": "精通JBuilder 2005",
 "RNUM": 1,
 "LEND_DATE": "2010-10-2100:00:00",
 "PROP_NO": "8502151",
 "NORM_RET_DATE": "2011-01-19 ",
 "M_AUTHOR": "陈雄华、涂传滨等编著"
 
 M_TITLE 书名
 LEND_DATE 借书日期
 PROP_NO 图书财产号
 NORM_RET_DATE 需归还日期
 M_AUTHOR 作者
 
 nearToEnd
 Int
 即将到期
 noReturn
 
 未归还
 overdue
 
 超期
 overdueMoney
 
 欠费
 data
 Array
 返回信息
 @property (nonatomic,copy)NSString *bookName;
 @property (nonatomic,copy)NSString *authorName;
 @property (nonatomic,copy)NSString *publishOfficeName;
 @property (nonatomic,copy)NSString *bookNum;//条码号
 @property (nonatomic,copy)NSString *orderTime;//预定时间
 @property (nonatomic,copy)NSString *returnTime;//归还时间
 @property (nonatomic,copy)NSString *bookState;//状态
 @property (nonatomic,copy)NSString *money;//欠款
 
 @property (nonatomic,copy,nonnull)NSString *CERT_ID; //学号/工号
 @property (nonatomic,copy,nonnull)NSString *TOTAL_LEND_QTY;//总借阅数
 @property (nonatomic,copy,nonnull)NSString *NAME ;//读者名字
 @property (nonatomic,copy,nonnull)NSString *NOW_LEND_QYT;//当前借
 */
@implementation LibiraryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"bookName" : @"M_TITLE",
             @"addressName" : @"LEND_DATE",
             @"returnTime" : @"NORM_RET_DATE",
             @"orderTime" : @"LEND_DATE",
             @"authorName" : @"M_AUTHOR",
             @"RNUM":@"RNUM",
             @"nearToEnd":@"nearToEnd",
             @"noReturn":@"noReturn",
             @"overdue":@"overdue",
             @"overdueMoney":@"overdueMoney",
             @"publishOfficeName":@"M_PUBLISHER",
             @"libiraryDate":@"date",
             @"PROP_NO":@"PROP_NO",
             @"NUM":@"NUM",
             @"CERT_ID":@"CERT_ID",
             @"TOTAL_LEND_QTY":@"TOTAL_LEND_QTY",
             @"NAME":@"NAME",
             @"NOW_LEND_QYT":@"NOW_LEND_QYT",
             @"CALL_NO":@"CALL_NO",
             @"TYPE":@"TYPE",
             @"WORDS":@"WORDS",
             @"TXDZ":@"TXDZ"
             };
}

@end
