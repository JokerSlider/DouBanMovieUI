//
//  SchoolRecruitViewController.m
//  CSchool
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AllJobRecruitViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "JobRecuritCell.h"
#import <MJRefresh.h>
#import "JobMessageInfoViewController.h"
@interface AllJobRecruitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *modelArray;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,assign)int  page;

@end

@implementation AllJobRecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
//    [self loadData];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
}
-(void)loadPastData
{
    //    [ProgressHUD show:@"正在加载..."];
    _page++;
    [self loadDataPageNum:_page];
}
-(void)loadData
{
    //    [ProgressHUD show:@"正在加载..."];
    _page = 1;
    [self loadDataPageNum:_page];
}
-(void)loadDataPageNum:(int )page
{
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showRecruitByInput",@"type":@"1", @"page":@(page),@"pageCount":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        [self hiddenErrorView];
        if (_page==1) {
            _modelArray = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.tableView reloadData];
                [self showErrorViewLoadAgain:@"没有相关数据！"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            JobModel *model = [[JobModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArray addObjectsFromArray:_dataSourceArr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if (_page>=0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)createView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = Base_Color2;
    self.tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(kScreenHeight-64-40);
}
#pragma mark UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _modelArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString *ID =@"JobCell";
    JobRecuritCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[JobRecuritCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    JobModel  *model = self.modelArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    return 60;
    Class currentClass = [JobRecuritCell class];
    JobModel  *model = self.modelArray[indexPath.section];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor redColor];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JobMessageInfoViewController *vc = [[JobMessageInfoViewController alloc]init];
    JobModel  *model = _modelArray[indexPath.section];
    vc.newsID = model.newsId;
    [self.navigationController pushViewController:vc animated:YES];
    
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
