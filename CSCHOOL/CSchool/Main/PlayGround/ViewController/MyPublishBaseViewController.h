//
//  MyPublishBaseViewController.h
//  CSchool
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface MyPublishBaseViewController : BaseViewController
@property(nonatomic,strong)UITableView *tableView;
-(void)loadDataWithFuncType:(NSString *)type andPushType:(NSString *)pushType pageNum:(NSString *)page;
@property (nonatomic,copy)NSString *funcType;//功能类型1,2,3（失物招领，二手市场，兼职招聘）

typedef void(^Block)(NSString *relType);
@property (nonatomic, copy) Block block;
@end
