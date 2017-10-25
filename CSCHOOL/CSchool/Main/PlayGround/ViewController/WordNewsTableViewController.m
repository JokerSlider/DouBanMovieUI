//
//  WordNewsTableViewController.m
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WordNewsTableViewController.h"
#import "WordNewsCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import <YYModel.h>
#import <MJRefresh.h>
#import "GoNewsInfoViewController.h"
#import "RxWebViewController.h"
@interface WordNewsTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)UITableView *tableView;
@property(assign, nonatomic)NSInteger index;

@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组

@property (nonatomic,strong)NSString *typeModel;

@property (nonatomic,copy)NSString *timestamp;//时间戳

@property (nonatomic,strong)NSMutableArray *timeStampArray;

@property (nonatomic,assign)int  page;
@end
static NSString * const cellId = @"worldNewsId";

@implementation WordNewsTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)zj_viewDidLoadForIndex:(NSInteger)index {
    _modelsArray = [NSMutableArray array];
    _typeModel = _selectIDArr[index];
    _timestamp  = @" ";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    [self.tableView.mj_header beginRefreshing];
}
//最新的
-(void)loadData
{
    _page = 1;
    _timestamp  = @" ";

    [self loadDataWithModel:_typeModel];
}
//以前的
-(void)loadPastData
{
    _page=2;
    _timestamp  = [_timeStampArray lastObject];
    if (!_timestamp) {
        _timestamp  = @" ";
    }
    [self loadDataWithModel:_typeModel];
}

/**
 加载数据
 schoolCode   学校识别码
 
 groupid      标签id, 0为从全部信息中获取
 
 timestamp    需要请求数据的时间范围 ----- ，默认为十分钟之前的数据
 
 refresh      1.下拉 2.上划 为1时获取数据为时间戳以后的时间（新的），2时获取数据为时间戳以前的时间，默认为1
 @param model 模块类型 */
-(void)loadDataWithModel:(NSString *)model{
    // 加载数据
#warning timeStamp  改为 @""  应改为
    [NetworkCore requestPOST: [AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showNewsBytimestamp",@"timestamp":_timestamp,@"groupid":model,@"refresh":@(_page),@"schoolCode":[AppUserIndex GetInstance].schoolCode} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *page = [NSString stringWithFormat:@"%d",_page];
        NSArray *dataArray = responseObject[@"data"];
        if ([page isEqualToString:@"1"]) {
            _modelsArray = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.tableView reloadData];
                [self showErrorViewLoadAgain:@"没有相关数据！"];
                return ;
            }else{
                _timeStampArray = [NSMutableArray array];
                _dataSourceArr = [NSMutableArray array];
            }
         }
        else{
            if (dataArray.count!=0) {
                _timeStampArray = [NSMutableArray array];
                _dataSourceArr = [NSMutableArray array];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        for (NSDictionary *dic in dataArray) {
            WorldNewsModel   *model = [[WorldNewsModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_timeStampArray addObject:model.CREATETIME];
            [_dataSourceArr addObject:model];
        }
        [_modelsArray addObjectsFromArray:_dataSourceArr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
        [self.tableView.mj_header endRefreshing];;
        [self.tableView.mj_footer endRefreshing];;
    }];

}
- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    self.index = index;
    
}
//- (void)zj_viewDidDisappearForIndex:(NSInteger)index {
//    NSLog(@"已经消失   标题: --- %@  index: -- %ld", self.title, index);
//
//}


#pragma mark- UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordNewsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[WordNewsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    WorldNewsModel *model = self.modelsArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [WordNewsCell class];
    WorldNewsModel *model = self.modelsArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //打开
    WorldNewsModel *model = self.modelsArray[indexPath.row];
//    GoNewsInfoViewController *newsInfoVC = [[GoNewsInfoViewController alloc]init];
//    newsInfoVC.baseUrl= model.ARTICLEURL;
    
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:model.ARTICLEURL]];//
    [self.navigationController pushViewController:vc animated:YES];
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
