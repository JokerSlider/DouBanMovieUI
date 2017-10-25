//
//  PhoneListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhoneListViewController.h"
#import "PhoneListTableViewCell.h"
#import "PhoneDetailViewController.h"

@interface PhoneListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PhoneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    self.navigationItem.title = _dataDic[@"DD_NAME"];

    _mainTableView.tableFooterView = [UIView new];
}


- (void)loadData{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showDepartmentInfoById",@"sysRole":@"1",@"depId":_dataDic[@"DD_ID"]} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = responseObject[@"data"];
        [_mainTableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indenty = @"PhoneListTableViewCell";
    
    PhoneListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PhoneListTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.nameLabel.text = dic[@"DD_NAME"];
    cell.subTitleLabel.text = dic[@"FATHER_NAME"];
    cell.phone = dic[@"DP_PHONE"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:NO];
    PhoneDetailViewController *vc = [[PhoneDetailViewController alloc] init];
    vc.dataDic = _dataArray[indexPath.row];
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
