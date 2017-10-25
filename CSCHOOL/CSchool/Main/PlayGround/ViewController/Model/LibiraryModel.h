//
//  LibiraryModel.h
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
@interface LibiraryModel : NSObject
@property (nonatomic,copy,nonnull)NSString *bookName;
@property (nonatomic,copy,nonnull)NSString *authorName;
@property (nonatomic,copy,nonnull)NSString *publishOfficeName;
@property (nonatomic,copy,nonnull)NSString *bookNum;//条码号
@property (nonatomic,copy,nonnull)NSString *orderTime;//预定时间
@property (nonatomic,copy,nonnull)NSString *returnTime;//归还时间
@property (nonatomic,copy,nonnull)NSString *bookState;//状态
@property (nonatomic,copy,nonnull)NSString *money;//欠款
@property (nonatomic,copy,nonnull)NSString *RNUM;//排序号
@property (nonatomic,copy,nonnull)NSString *nearToEnd;//即将到期图书
@property (nonatomic,copy,nonnull)NSString *noReturn;//未归还书本数目
@property (nonatomic,copy,nonnull)NSString *overdue;//已经超期图书
@property (nonatomic,copy,nonnull)NSString *overdueMoney;//欠费金额
@property (nonatomic,copy,nonnull)NSString *libiraryDate;//服务器时间
@property (nonatomic,copy,nonnull)NSString *PROP_NO;//图书财产号
@property (nonatomic,copy,nonnull)NSString *NUM;//借阅次数；

@property (nonatomic,copy,nonnull)NSString *CERT_ID; //学号/工号
@property (nonatomic,copy,nonnull)NSString *TOTAL_LEND_QTY;//总借阅数
@property (nonatomic,copy,nonnull)NSString *NAME ;//读者名字
@property (nonatomic,copy,nonnull)NSString *NOW_LEND_QYT;//当前借
@property (nonatomic,copy,nonnull)NSString *CALL_NO;//图书号

//热搜
@property (nonatomic,copy,nonnull)NSString *TYPE;//热搜类型 
@property (nonatomic,copy,nonnull)NSString *WORDS;//热搜名字
@property (nonatomic,copy,nonnull)NSString *TXDZ;
@end
