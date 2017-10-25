//
//  SchoolBusListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SchoolBusListViewController.h"
#import "AutoWebViewController.h"

@interface SchoolBusListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation SchoolBusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    [self loadData];
    _mainTableView.tableFooterView = [[UIView alloc] init];
}

- (void)loadData{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getSchoolBasicsInfo", @"type":_type} success:^(NSURLSessionDataTask * _Nullable task, NSDictionary *responseObject) {
        _dataArray = [responseObject valueForKeyPath:@"data"];
        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textColor = Color_Black;
    cell.textLabel.font = Title_Font;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CITITLE"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AutoWebViewController *vc = [[AutoWebViewController alloc] init];
    vc.commitDic = @{@"rid":@"showSchoolBasicsInfoById",@"uid":_dataArray[indexPath.row][@"CIID"]};
    vc.valueForKeyPath = @"data.cicontent";
    vc.navigationItem.title = _dataArray[indexPath.row][@"CITITLE"];
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
