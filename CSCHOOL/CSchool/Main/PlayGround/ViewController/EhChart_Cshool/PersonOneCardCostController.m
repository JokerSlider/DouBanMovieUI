//
//  PersonOneCardCostController.m
//  CSchool
//
//  Created by mac on 17/5/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "PersonOneCardCostController.h"
#import "PYBarDemoOptions.h"
//#import "iOS-Echarts.h"
@interface PersonOneCardCostController ()
//@property(nonatomic, strong) PYEchartsView *kEchartView;

@end

@implementation PersonOneCardCostController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    [self  loadData];
}
-(void)loadData
{
//    [NetworkCore requestPOST:API_HOST3 parameters:@{@"rid":@"showStudentOneCard",@"userid":@"20140414040",@"type":@"3"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        NSDictionary *dic = responseObject[@"data"] ;
//        self.title = dic[@"title"];
//        [self loadBarViewWithDic:dic];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//
//    }];
}
-(void)loadBarViewWithDic:(NSDictionary *)dic
{
//    self.kEchartView = [[PYEchartsView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
//    PYOption *option = [PYBarDemoOptions basicColumnOptionwithDic:dic];
//    [_kEchartView setOption:option];
//    [_kEchartView loadEcharts];
//    [self.view addSubview:self.kEchartView];
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
