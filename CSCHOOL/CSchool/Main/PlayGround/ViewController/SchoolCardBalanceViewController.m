//
//  SchoolCardBalanceViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/2.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SchoolCardBalanceViewController.h"

@interface SchoolCardBalanceViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation SchoolCardBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _nameLabel.text = @"小明明";//[AppUserIndex GetInstance].userName;
    _logoImageView.layer.cornerRadius = 50;
//    _mainScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+10);
    [self loadData];
}

- (void)loadData{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"oneCardPass",@"stuNo":stuNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *balanceStr = responseObject[@"data"][0][@"KYE"];
        CGFloat balNum = [balanceStr doubleValue]/100.0;
        _balanceLabel.text = [NSString stringWithFormat:@"%.2f",balNum];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

- (IBAction)weChatAction:(UIButton *)sender {
}
- (IBAction)alipayAction:(id)sender {
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
