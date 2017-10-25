//
//  TecStartSignController.m
//  CSchool
//
//  Created by mac on 17/6/30.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecStartSignController.h"
#import "TecStatrSignCell.h"
#import "WIFICellModel.h"
#import <YYModel.h>
#import "WifiSignSureController.h"
#import <MJRefresh.h>
#import "TecEndSignController.h"
#import "TecSubSignListViewController.h"
@interface TecStartSignController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,assign)int  page;

@end

@implementation TecStartSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self loadData];
    _page = 1;
    self.title = @"签到列表";
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    [self.mainTableView.mj_header beginRefreshing];

}
//获取旧数据
-(void)loadPastData{
    _page ++;
    [self loadDataWithPage:_page];
}
//获取最新数据
-(void)loadData
{
    _modelArr = [NSMutableArray array];
    [self loadDataWithPage:_page];
}
-(void)loadDataWithPage:(int)page
{
    NSDictionary  *params = @{
                              @"rid":@"showSignForTeacherid",
                              @"userid":teacherNum,
                              @"role":[AppUserIndex GetInstance].role_type,
                              @"scoolCode":[AppUserIndex GetInstance].schoolCode,
                              @"page":@(page),
                              @"pageCount":Message_Num
                              };
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL

    [NetworkCore requestPOST:url parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        [self hiddenErrorView];
        if (page==1) {
            _modelArr = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.mainTableView reloadData];
                [self showErrorViewLoadAgain:@"没有相关数据！"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            WIFICellModel *model = [WIFICellModel new];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        [_modelArr addObjectsFromArray:_dataSourceArr];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if (page>=1) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.mainTableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];

}
//创建视图
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
}
#pragma mark DataSource  && Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellID = @"tecStartCell";
    TecStatrSignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TecStatrSignCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = _modelArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (_chooseType) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            TecEndSignController *vc = [TecEndSignController new];
            WIFICellModel *model = _modelArr[indexPath.row];
            vc.signID = model.tls_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            TecSubSignListViewController *vc = [TecSubSignListViewController new];
            WIFICellModel *model = _modelArr[indexPath.row];
            vc.signID = model.tls_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
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
