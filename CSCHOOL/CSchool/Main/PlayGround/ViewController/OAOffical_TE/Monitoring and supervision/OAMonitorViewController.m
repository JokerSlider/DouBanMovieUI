//
//  OAMonitorViewController.m
//  CSchool
//
//  Created by mac on 17/6/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAMonitorViewController.h"
#import "OAModel.h"
#import <YYModel.h>
#import "NSDate+Extension.h"
@interface OAMonitorViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView *mainTableview;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation OAMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阅办监控";
    [self createView];
    [self loadData];
}
-(void)loadData
{
    NSString *url = [NSString stringWithFormat:@"%@/getFlowHistoryByOid",OABase_URL];
    _modelArr = [NSMutableArray array];
    [NetworkCore requestMD5POST:url parameters:@{@"in_oi_id":_oi_id,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_oi_id,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject) {
            OAModel *model = [OAModel new];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        if (_modelArr.count==0) {
            [self showErrorViewLoadAgain:@"暂无数据哦"];
            return ;
        }
        [self.mainTableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)createView
{
    self.mainTableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableview.delegate = self;
    self.mainTableview.dataSource = self;
    self.mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableview];
}
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString   *cellID = @"OAMonitorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OAModel *model = _modelArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@操作了该流程",model.xm];
    cell.textLabel.textColor = RGB(40, 40, 40);
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    NSString *time = [NSDate dateTranlateStringFromTimeString:model.create_time andformatterString:@"yyyy-MM-dd HH:mm"];
    cell.detailTextLabel.text = time;
    cell.detailTextLabel.textColor = RGB(40, 40, 40);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
