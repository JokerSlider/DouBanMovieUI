//
//  ActivityListController.m
//  CSchool
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ActivityListController.h"
#import "ActivityModel.h"
#import <YYModel.h>
#import "ActivityListCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "LotterDrawController.h"
#import <MJRefresh.h>

@interface ActivityListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;//主要的tableView
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation ActivityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动列表";
    [self createView];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadActivityData)];
    [self.mainTableView.mj_header beginRefreshing];
}
-(void)loadData
{
    [self loadActivityData];
}
-(void)loadActivityData
{
    _modelArr =  [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showLuckyActivityList"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [self.mainTableView.mj_header endRefreshing];

        NSArray *sourceArr = responseObject[@"data"];
        if (sourceArr.count==0) {
            [self showErrorViewLoadAgain:@"暂时没有活动哦"];
            return ;
        }
        for (NSDictionary *dic in sourceArr) {
            ActivityModel *model = [ActivityModel new];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self.mainTableView.mj_header endRefreshing];
        [self showErrorViewLoadAgain:@"暂时没有活动哦"];
    }];
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
}
#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"activityID";
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ActivityListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.modelArr[indexPath.row];
    cell.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ActivityListCell class];
    ActivityModel *model = self.modelArr[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ActivityModel *model = self.modelArr[indexPath.row];
    int  status = [model.status  intValue];
    LotterDrawController *vc = [[LotterDrawController alloc]init];
    switch (status) {
            case 0:
            vc.activityID = model.activietyID;
            vc.isUse = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
            case 1:
            vc.activityID = model.activietyID;
            vc.isUse = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
            case 2:            
            vc.activityID = model.activietyID;
            vc.isUse = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        default:
            break;
    }
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
