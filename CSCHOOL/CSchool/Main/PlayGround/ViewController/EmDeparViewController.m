//
//  EmDeparViewController.m
//  CSchool
//
//  Created by mac on 16/12/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "EmDeparViewController.h"
#import "WSDropMenuView.h"
#import "OfficePersonInfoViewController.h"
#import "UIView+SDAutoLayout.h"

@interface EmDeparViewController ()<WSDropMenuViewDataSource,WSDropMenuViewDelegate>
{
    NSArray *_originData;
    UIWindow *_window;
    UIView *_leadBackView;//引导底部视图
}
@end

@implementation EmDeparViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if (_leadBackView) {
        [_leadBackView removeFromSuperview];
    }
}
-(void)showLeadView
{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"emLeadView"] isEqualToString:@"1"]) {
        _window  = [UIApplication sharedApplication].keyWindow;
        UIImageView *image = [UIImageView new];
        image.image = [UIImage imageNamed:@"em_Lead"];
        _leadBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _leadBackView.userInteractionEnabled = YES;
        [self.view addSubview:_leadBackView ];
        [_leadBackView addSubview:image];
        image.sd_layout.widthIs(200).heightIs(100).centerXIs(_leadBackView.centerX).topSpaceToView(_leadBackView,(kScreenHeight-64-100-40)/2);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HiddenLeadView)];

        [_leadBackView addGestureRecognizer:tap];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    _originData = [NSArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getDepartInfo" } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _originData = [responseObject objectForKey:@"data"];
        if (_originData.count==0) {
            [ProgressHUD dismiss];
            [self showErrorViewLoadAgain:@"获取通讯录信息失败"];
        }
        else{
            WSDropMenuView *dropMenu = [[WSDropMenuView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40)];
            dropMenu.dataSource = self;
            dropMenu.delegate  =self;
            [self.view addSubview:dropMenu];
            [dropMenu reloadLeftTableView ];
            [self showLeadView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];

}
#pragma mark - WSDropMenuView DataSource -
- (NSInteger)dropMenuView:(WSDropMenuView *)dropMenuView numberWithIndexPath:(WSIndexPath *)indexPath{
    
    //WSIndexPath 类里面有注释
    
    if (indexPath.column == 0 && indexPath.row == WSNoFound) {
        
        return _originData.count;
    }
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item == WSNoFound) {
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        return arr.count;
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank == WSNoFound) {
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        NSDictionary *departDic = arr[indexPath.item];
        NSArray *perArr = departDic[@"personname"];
        return perArr.count;
    }
    
    return 0;
}

- (NSString *)dropMenuView:(WSDropMenuView *)dropMenuView titleWithIndexPath:(WSIndexPath *)indexPath{
    
    //return [NSString stringWithFormat:@"%ld",indexPath.row];
    
    //左边 第一级
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item == WSNoFound) {
        
        return _originData[indexPath.row][@"seniorname"];
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank == WSNoFound) {
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        return arr[indexPath.item][@"departname"];
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank != WSNoFound) {
        
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        NSDictionary *departDic = arr[indexPath.item];
        NSArray *perArr = departDic[@"personname"];
        
        return perArr[indexPath.rank][@"name"];
    }
    
    
    return @"";
    
}

#pragma mark - WSDropMenuView Delegate -

- (void)dropMenuView:(WSDropMenuView *)dropMenuView didSelectWithIndexPath:(WSIndexPath *)indexPath{
    
    OfficePersonInfoViewController *classPhoneVC = [[OfficePersonInfoViewController alloc]init];
    
    NSDictionary *dic = _originData[indexPath.row];
    NSArray *arr = dic[@"departments"];
    NSDictionary *departDic = arr[indexPath.item];
    NSArray *perArr = departDic[@"personname"];    
    classPhoneVC.nameID = perArr[indexPath.rank][@"nameid"];
    [self.navigationController pushViewController:classPhoneVC animated:YES];
}
#pragma mark  私有方法
-(void)HiddenLeadView
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"emLeadView"];
    [_leadBackView removeFromSuperview];
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
