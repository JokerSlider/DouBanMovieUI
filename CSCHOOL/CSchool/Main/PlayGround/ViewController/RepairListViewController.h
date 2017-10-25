//
//  RepairListViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/7.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseViewController.h"

@interface RepairListViewController : BaseViewController

@property (nonatomic, assign) BOOL isRepair; //是否是从报修界面跳过来（YES：是，需要移除nav栈中页面）

- (void)loadData;

@end
