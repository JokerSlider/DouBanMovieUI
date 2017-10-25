//
//  FinanceIndexCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/8/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceIndexModel : NSObject

@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *numStr;
@property (nonatomic, copy) NSString *chuangkou;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *financeId;
@property (nonatomic, retain) NSArray *standardInfo;
@property (nonatomic, copy) NSMutableString *typeString; //根据数组拼接而成
@property (nonatomic, assign) NSInteger totalNum; //根据数组相加
@property (nonatomic,copy)NSString *CalenderEventS_Time;//日历开始时间
@property (nonatomic,copy)NSString *CalenderEventE_Time;//日历结束时间

- (void)modelSetDic:(NSDictionary *)dic;

@end

@interface FinanceIndexCell : UITableViewCell

@property (nonatomic, retain) FinanceIndexModel *model;


@end
