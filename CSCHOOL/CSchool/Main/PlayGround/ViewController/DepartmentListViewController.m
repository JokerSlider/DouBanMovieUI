//
//  DepartmentListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/6/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DepartmentListViewController.h"
#import "DepartmentListCell.h"
#import "PhoneSearchViewController.h"
#import "PhoneListViewController.h"

@interface DepartmentListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DepartmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"办公电话";
    [self loadData];
    _mainTableView.tableFooterView = [UIView new];
}

- (void)loadData{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showDepartmentsInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
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

    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = Color_Black;
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"DD_NAME"];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:NO];
    PhoneListViewController *vc = [[PhoneListViewController alloc] init];
    vc.dataDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma -mark UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    PhoneSearchViewController *vc = [[PhoneSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
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
