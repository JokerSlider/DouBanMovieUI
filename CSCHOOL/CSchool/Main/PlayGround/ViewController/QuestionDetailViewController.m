//
//  QuestionDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "CallRepairViewController.h"

@interface QuestionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _titleLabel.text = @"这里是标题";
    self.navigationItem.title = @"详情";
    _contentTextView.font = Title_Font;
    _titleLabel.textColor = Title_Color1;
    [self loadData];
}

- (void)loadData{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getCommonFaultById", @"commonFaultId":_questionId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"][0];
        _titleLabel.text = dic[@"CF_TITLE"];
        _contentTextView.text = dic[@"CF_DESCRIPTION"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

- (IBAction)solvedAction:(UIButton *)sender {
    
}
- (IBAction)cantSolveAction:(UIButton *)sender {
    CallRepairViewController *vc = [[CallRepairViewController alloc] init];
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
