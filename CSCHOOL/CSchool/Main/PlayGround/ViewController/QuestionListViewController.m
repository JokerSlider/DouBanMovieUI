//
//  QuestionListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "QuestionListViewController.h"
#import "QuestionDetailViewController.h"
#import "CallRepairViewController.h"
#import "QuestionDetailNewViewController.h"
#import "UIButton+BackgroundColor.h"

@interface QuestionListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIButton *repairBtn;

@end

@implementation QuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"常见问题与解决方案";

    [self loadData];
    _mainTableView.tableFooterView = [[UIView alloc] init];
//    _repairBtn.backgroundColor = [UIColor whiteColor];
    [_repairBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repairBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];

}

- (void)loadData{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getCommonFaultInfo"} success:^(NSURLSessionDataTask * _Nullable task, NSDictionary *responseObject) {
        [ProgressHUD dismiss];
        _dataArr = [NSMutableArray arrayWithArray:[responseObject valueForKeyPath:@"data"]];
        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}
- (IBAction)repairAction:(UIButton *)sender {
    CallRepairViewController *vc = [[CallRepairViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textColor = Title_Color1;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = Title_Font;
    cell.textLabel.text = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"CF_TITLE"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    QuestionDetailNewViewController *vc = [[QuestionDetailNewViewController alloc] init];
    vc.questionId = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"CF_ID"];
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
