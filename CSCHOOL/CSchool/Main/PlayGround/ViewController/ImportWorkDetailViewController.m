//
//  ImportWorkDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ImportWorkDetailViewController.h"
#import "ImportWorkDetailCell.h"
#import <YYModel.h>
#import "SDAutoLayout.h"

@interface ImportWorkDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation ImportWorkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"重点工作详情";
    [self createTableHeaderView];
    [self loadData];
}

- (void)loadData{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showZdgzInfo",@"wid":_workId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            ImportWorkDetailModel *model = [[ImportWorkDetailModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [_mainTableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
    
}

- (void)createTableHeaderView{
    //如果没备注就不添加头视图
    if (_workName.length == 0) {
        return;
    }
    UIView *view = [UIView new];
    view.width = [UIScreen mainScreen].bounds.size.width;
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = Base_Orange;
    [view addSubview:label];
    
    label.sd_layout
    .leftSpaceToView(view,19)
    .rightSpaceToView(view,19)
    .topSpaceToView(view,15)
    .autoHeightRatio(0);
    
    
    label.text = [NSString stringWithFormat:@"工作名称：%@",_workName];
    [view setupAutoHeightWithBottomView:label bottomMargin:10];
    [view layoutSubviews];
    _mainTableView.tableHeaderView = view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ImportWorkDetailCell";
    ImportWorkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ImportWorkDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[ImportWorkDetailCell class] contentViewWidth:kScreenWidth];
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
