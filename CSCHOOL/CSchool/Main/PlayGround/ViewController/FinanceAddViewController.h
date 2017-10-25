//
//  FinanceAddViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/8/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface FinanceAddViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *firstDic;

//单个添加元素
- (void)addNewDataDic:(NSDictionary *)dic;
//批量添加
- (void)addDataWithArray:(NSArray *)array;
@end
