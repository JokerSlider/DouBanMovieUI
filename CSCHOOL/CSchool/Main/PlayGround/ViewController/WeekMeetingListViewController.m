//
//  WeekMeetingListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WeekMeetingListViewController.h"
#import "SDAutoLayout.h"
#import "WeekMeetingListCell.h"
#import <YYModel.h>

@interface WeekMeetingListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *dataMutableArr;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation WeekMeetingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self createTableHeaderView];
    [self loadData];
}

- (void)createTableHeaderView{
    //如果没备注就不添加头视图
    if (_bz.length == 0) {
        return;
    }
    UIView *view = [UIView new];
    view.width = [UIScreen mainScreen].bounds.size.width;
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = RGB(85, 85, 85);
    [view addSubview:label];
    
    label.sd_layout
    .leftSpaceToView(view,19)
    .rightSpaceToView(view,19)
    .topSpaceToView(view,15)
    .autoHeightRatio(0);
    
    
    label.text = [NSString stringWithFormat:@"备注：%@",_bz];
    [view setupAutoHeightWithBottomView:label bottomMargin:2];
    [view layoutSubviews];
    _mainTableView.tableHeaderView = view;
}

- (void)loadData{
    
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showMeetOrReportInfoById",@"type":_typeString, @"uid":_uid} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataMutableArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            WeekMeetingListModel *model = [[WeekMeetingListModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataMutableArr addObject:model];
        }
        
        if (_dataMutableArr.count == 0) {
//            [self showErrorView:@"无会议活动安排" ];
            [self showErrorView:@"无会议活动安排"  andImageName:nil];

        }else{
            [_mainTableView reloadData];
        }
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"WeekMeetingListCell";
    WeekMeetingListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WeekMeetingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = self.dataMutableArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[WeekMeetingListCell class] contentViewWidth:kScreenWidth];
    
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
