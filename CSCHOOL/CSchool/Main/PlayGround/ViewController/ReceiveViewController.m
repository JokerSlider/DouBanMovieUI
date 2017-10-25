//
//  ReceiveViewController.m
//  CSchool
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ReceiveViewController.h"
#import <MJRefresh.h>
@interface ReceiveViewController ()
@property (nonatomic,copy)NSString *pushType;//信息发布类型:发布  or  求购
@property (nonatomic,assign)int  page;
@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadReData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRePastData)];
    [self.tableView.mj_header beginRefreshing];

}
-(void)loadData
{
    [super loadData];
    [self loadReData];
}
//最新的
-(void)loadReData
{
    _pushType = @"2";
    _page = 1;
    [ProgressHUD show:@"正在加载..."];
    [self loadDataWithMainFuncType:self.funcType andPushType:_pushType pageNum:@"1"];
}
//以前的
-(void)loadRePastData
{
    _pushType = @"2";
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithMainFuncType:self.funcType andPushType:_pushType pageNum:pageNum];
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
