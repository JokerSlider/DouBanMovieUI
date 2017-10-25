//
//  FindViewController.m
//  CSchool
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FindViewController.h"
#import <MJRefresh.h>

@interface FindViewController ()
@property (nonatomic,copy)NSString *pushType;//信息发布类型:发布  or  求购
@property (nonatomic,assign)int  page;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPushData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPushPastData)];
//    [self.tableView.mj_header beginRefreshing];
}
-(void)loadData
{
    [super loadData];
    [self loadPushData];
}
-(void)loadPushData
{
    _pushType = @"1";//求购
    _page = 1;
    [ProgressHUD show:@"正在加载..."];
    [self loadDataWithMainFuncType:self.funcType andPushType:_pushType pageNum:@"1"];
}
-(void)loadPushPastData
{
    _pushType = @"1";
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithMainFuncType:self.funcType andPushType:_pushType pageNum:pageNum];

}
@end
