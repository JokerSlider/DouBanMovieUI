//
//  MyPusblisINViewController.m
//  CSchool
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyPusblisINViewController.h"
#import <MJRefresh.h>

@interface MyPusblisINViewController ()
@property (nonatomic,copy)NSString *pushType;//信息发布类型:发布  or  求购
@property (nonatomic,assign)int  page;

@end

@implementation MyPusblisINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMyRevePastData)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMyReveData)];
//    [self.tableView.mj_header beginRefreshing];
}
-(void)loadData
{
    [super loadData];
    [self loadMyReveData];
}

-(void)loadMyReveData
{
    _pushType = @"2";
    _page = 1;
    [ProgressHUD show:@"正在加载..."];
    [self loadDataWithFuncType:self.funcType andPushType:_pushType pageNum:@"1"];
  
}
//过去的数据
-(void)loadMyRevePastData
{
    _pushType = @"2";
    _page ++;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithFuncType:self.funcType andPushType:_pushType pageNum:pageNum];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
