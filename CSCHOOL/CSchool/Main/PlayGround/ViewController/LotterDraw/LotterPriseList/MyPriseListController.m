//
//  MyPriseListController.m
//  CSchool
//
//  Created by mac on 17/5/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MyPriseListController.h"
#import "MyPriseHeadView.h"
#import "MyPriseCell.h"
#import "PriseModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface MyPriseListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation MyPriseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的中奖纪录";
    [self loadData];
    [self createView];
}
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    self.modelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showMyWinPrizeInfo",@"stuNo":[AppUserIndex GetInstance].role_id,@"activityId":self.activityID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSArray *sourceArr = responseObject[@"data"];
        if (sourceArr.count==0) {
            [JohnAlertManager showFailedAlert:@"暂无您的中奖信息!" andTitle:@"提示"];
            
            return ;
        }
        for (NSDictionary *dic in sourceArr) {
            PriseModel *model = [[PriseModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [self.modelArray addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"获取列表失败,点击重新获取吧"];
    }];
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    MyPriseHeadView *headView = [[MyPriseHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    self.mainTableView.tableHeaderView = headView ;
    
    [self.view addSubview:self.mainTableView];
}
#pragma mark  
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"myPirseListCell";
    MyPriseCell     *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MyPriseCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = self.modelArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [MyPriseCell   class];
    PriseModel  *model = self.modelArray[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
