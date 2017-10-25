//
//  RepairListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/7.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "RepairListViewController.h"
#import "RepairListTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "RepairDetailViewController.h"
#import "NSDate+Extension.h"
#import <YYModel.h>
#import "ConfigObject.h"
#import "PlayGroundNewViewController.h"
#import <MJRefresh.h>

#define RepairListID @"RepairListTableViewCell"
@interface RepairListViewController ()<UITableViewDataSource, UITableViewDelegate,XGAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArr;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation RepairListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setEmptyView:_mainTableView withString:@"暂无维修信息" withImageName:@""];
    
    self.navigationItem.title = @"我的报修";
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /**
     *  如果是从报修界面进来的，需要将navVCs除了PlayGroundNewViewController和self的控制器移除，其他控制器都从导航堆栈中移除。
     */
    if (_isRepair) {
        NSMutableArray *tempMutableArray = [[NSMutableArray alloc] init];
        NSMutableArray *navVCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        for(int i=0;i<[navVCs count]-1;i++){
            UIViewController *aVC = [navVCs objectAtIndex:i];
            if ([aVC class] != [PlayGroundNewViewController class] && [aVC class] != [self class]) {
                [tempMutableArray addObject:aVC];
            }
        }
        [navVCs removeObjectsInArray:tempMutableArray];
        [self.navigationController setViewControllers:navVCs animated:NO];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [self setEmptyView:_mainTableView withString:@"暂无报修" withImageName:@""];
}

- (void)loadData{
    
    NSDictionary *commitDic = @{
                                @"rid":@"getRepairinfoList",
//                                @"faultState":@"0x00009",
                                @"stuNo":[AppUserIndex GetInstance].accountId
                                };
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        DLog(@"%@",responseObject);
        _dataArr = [responseObject objectForKey:@"data"];
        _dataMutableArr = [NSMutableArray array];

        for (NSDictionary *dic in _dataArr) {
            RepairListModel *model = [[RepairListModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataMutableArr addObject:model];
        }
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];

    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"RepairListTableViewCell";
    RepairListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RepairListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataMutableArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[RepairListTableViewCell class] contentViewWidth:kScreenWidth];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RepairDetailViewController *vc = [[RepairDetailViewController alloc] init];
    vc.model = [_dataMutableArr objectAtIndex:indexPath.row];
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
