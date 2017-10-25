//
//  WeekListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WeekListViewController.h"
#import "WeekListCell.h"
#import "WeekMeetingListViewController.h"
#import "SDAutoLayout.h"

@interface WeekListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSArray *dataArray;
@end

@implementation WeekListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if ([_typeString isEqualToString:@"1"]) {
        self.navigationItem.title = @"周会议列表";
    }else{
        self.navigationItem.title = @"报告厅列表";
    }
    
    [self loadData];
}


- (void)loadData{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showMeetOrReportByInput",@"type":_typeString} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = responseObject[@"data"];
        if (_dataArray.count == 0) {
            [self showErrorView:@"无会议活动安排" andImageName:nil];
        }else{
            [_mainTableView reloadData];
        }
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"WeekListCell";
    WeekListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WeekListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.dataDic = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    //    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WeekMeetingListViewController *vc = [[WeekMeetingListViewController alloc] init];
    vc.typeString = _typeString;
    vc.uid = _dataArray[indexPath.row][@"id"];
    vc.bz = _dataArray[indexPath.row][@"bz"];
    vc.navigationItem.title = [_dataArray[indexPath.row][@"title"] componentsSeparatedByString:@"（"][0];
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
