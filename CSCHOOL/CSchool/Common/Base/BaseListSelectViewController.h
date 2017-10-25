//
//  BaseListSelectViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/9/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectVcDelegate <NSObject>

- (void)selectVc:(UIViewController *)vc didSelectCellWithDic:(NSDictionary *)dic;

@end

@interface BaseListSelectViewController : BaseViewController

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSDictionary *commitDic; //提交服务器的字典

@property (nonatomic, retain) NSArray *totalDataArray; //所有数据

@property (nonatomic, retain) NSArray *currentDataArray; //当前选择展示的数据

@property (nonatomic, retain) id <SelectVcDelegate>delegate;

@end
