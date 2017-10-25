//
//  SportGroupView.m
//  CSchool
//
//  Created by mac on 17/3/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SportGroupView.h"
#import "SportsMainCell.h"
#import <YYModel.h>
#import "MineSportListViewController.h"
#import "UIView+UIViewController.h"
@interface SportGroupView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,copy )NSMutableArray *modelArray;
@end
@implementation SportGroupView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        self.mainTableView.delegate =self;
        self.mainTableView.dataSource =self;
        self.mainTableView.tableFooterView = [UIView new];
        [self addSubview:self.mainTableView];
        [self loadData];
    }
    return self;
}
-(void)loadData
{
    _modelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getGroupsByPerson",@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *dataSar = responseObject[@"data"];
        if (dataSar.count==0) {
            [JohnAlertManager showFailedAlert:@"没有查询到您所在的群组信息" andTitle:@"提示"];
            return ;
        }
        for (NSDictionary *dic in responseObject[@"data"]) {
            SportModel *model = [[SportModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArray addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [JohnAlertManager showFailedAlert:@"没有查询到您所在的群组信息" andTitle:@"提示"];
    }];
    
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"sportGroupCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    SportModel *model = _modelArray[indexPath.row];
    cell.textLabel.text = model.GROUPNAME;
    cell.textLabel.textColor = Color_Black;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MineSportListViewController *vc = [[MineSportListViewController alloc]init];
    vc.model = _modelArray[indexPath.row];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
@end
