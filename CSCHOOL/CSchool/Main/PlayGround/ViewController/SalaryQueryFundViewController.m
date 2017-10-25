//
//  SalaryQueryFundViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SalaryQueryFundViewController.h"
#import "SDAutoLayout.h"
#import "QueryFundCell.h"

@interface SalaryQueryFundViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
//余额
@property (nonatomic, strong)UILabel *balanceLabel;
@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation SalaryQueryFundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createViews];
    [self loadData];
}

- (void)loadData{
    NSDictionary *commitDic = @{
                                @"rid":@"getFundInfo",
                                @"userid":[AppUserIndex GetInstance].salaryUserName,
                                @"password":[AppUserIndex GetInstance].salaryPWD
                                };
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataDic = responseObject[@"data"];
        [_tableView reloadData];
        _balanceLabel.text = _dataDic[@"当前余额"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:@"暂无数据"];
    }];

}

- (void)createViews{
    self.title = @"公积金查询";
    self.view.backgroundColor = Base_Color2;

    UIView *backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    UIImageView *imageV = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"wallet_ico"];
        view;
    });
    //当前余额(元)
    UILabel *nowMoneyLabel=({
        UILabel *view = [UILabel new];
        view.text=@"当前余额(元)";
        view.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
        view.textColor = Color_Black;
        view;
    });
    self.balanceLabel =({
        UILabel *view = [UILabel new];
        view.font = [UIFont fontWithName:@"Arial-BoldMT" size:50.0f];
        view.text = @"正在加载...";
        view.textAlignment = NSTextAlignmentCenter;
        view.textColor = Base_Orange;
        view;
    });
    self.tableView = ({
        UITableView *view = [UITableView new];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        view;
    });
    //        [self.view addSubview:noticeL];
    [self.view addSubview:self.tableView];
    //    [self.view addSubview:backView];
    [backView addSubview:imageV];
    [backView addSubview:nowMoneyLabel];
    [backView addSubview:self.balanceLabel];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView *headerView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        view;
    });
    [headerView addSubview:backView];
    
    headerView.sd_layout.leftSpaceToView(self.tableView,0).rightSpaceToView(self.tableView,0).topSpaceToView(self.tableView,0).heightIs(204);
    
    self.tableView.tableFooterView = [UIView new];
    //        noticeL.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(50).topSpaceToView(self.view,0);
    backView.sd_layout.leftSpaceToView(headerView,10).rightSpaceToView(headerView,10).topSpaceToView(headerView,5).heightIs(199);
    imageV.sd_layout.leftSpaceToView(backView,10).topSpaceToView(backView,10).widthIs(20).heightIs(20);
    nowMoneyLabel.sd_layout.leftSpaceToView(imageV,0).topEqualToView(imageV).widthIs(110).heightIs(20);
    self.balanceLabel.sd_layout.topSpaceToView(backView,100).leftSpaceToView(backView,0).rightSpaceToView(backView,0).heightIs(50);
    self.tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    self.tableView.tableHeaderView = headerView;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indenty = @"QueryFundCell";
    
    QueryFundCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    
    if (cell == nil) {
        
        cell = [[QueryFundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenty];
    }

    
    NSArray *arr = @[@"公积金帐号",@"月初余额",@"本月缴存",@"年度"];
    NSArray *imageArr = @[@"fund_zhanghao",@"fund_monthLeft",@"fund_monthGiv",@"fund_year"];
    
    cell.nameLabel.text = arr[indexPath.row];
    cell.valueLabel.text = _dataDic[arr[indexPath.row]];
    cell.iconImageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    return 0;
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
