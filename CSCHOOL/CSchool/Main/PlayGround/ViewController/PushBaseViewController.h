//
//  PushBaseViewController.h
//  CSchool
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface PushBaseViewController : BaseViewController
@property (nonatomic,strong)NSArray *infoButtonTitleArr;
@property (nonatomic,copy)NSString *funcType;//功能类型0，1，2（失物招领，二手市场，兼职招聘）
@property(nonatomic,strong)UITableView *tableView;
-(void)loadDataWithMainFuncType:(NSString *)type andPushType:(NSString *)pushType pageNum:(NSString *)page;

@end
