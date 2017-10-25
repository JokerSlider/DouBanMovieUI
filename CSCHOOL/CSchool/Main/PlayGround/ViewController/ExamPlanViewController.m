//
//  ExamPlanViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/6/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ExamPlanViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import <YYModel.h>
#import "ExamListTableViewCell.h"
#import "TePopList.h"
#import "XGTempNoticeView.h"
#import "XGAlertView.h"

@interface ExamPlanViewController ()<UITableViewDelegate, UITableViewDataSource, XGAlertViewDelegate>

{
    UIButton *_selTermBtn;
    NSMutableDictionary *_termInfoDic; //存放学期名称与字段对应信息
    NSMutableArray *_termInfoArray; //存放学期信息
}
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *dataMutableArr;

@property (nonatomic, copy) NSString *termString;

@property (nonatomic, assign) NSInteger selIndex;
@end

@implementation ExamPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"考试安排";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createViews];
    _termString = @"";
//    [self loadTermInfo];
    [self loadData];
    [self showAlert];
}

- (void)createViews{
//    XGTempNoticeView *tempView = [[XGTempNoticeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) WithText:@"本数据仅供参考，请以学校实际公布为准。" WithFlashTime:5];
//    [self.view addSubview:tempView];
    
    _mainTableView =[[UITableView alloc] init];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:_mainTableView];
    _mainTableView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
    [self setEmptyView:_mainTableView withString:@"暂无本学期考试安排" withImageName:@"sad"];
}

- (void)showAlert{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"ExamShow"] isEqualToString:@"1"]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"本数据仅供参考，请以学校实际公布为准。" WithCancelButtonTitle:@"不再提示" withOtherButton:nil];
        alert.isBackClick = YES;
        [alert show];
    }
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ExamShow"];
}

- (void)loadData{
    
    NSDictionary *commitDic = @{
                                @"rid":@"getStudentExamInformation",
                                @"stuNo":stuNum,
//                                @"term":_termString
                                };
    [ProgressHUD show:nil];

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {

        NSArray *dataArray = responseObject[@"data"];
        _dataMutableArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArray) {
            ExamListModel *model = [[ExamListModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataMutableArr addObject:model];
        }
        [_mainTableView reloadData];
        [ProgressHUD dismiss];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        [self setEmptyView:_mainTableView withString:error[@"msg"] withImageName:@"sad"];
        [self showErrorViewLoadAgain:error[@"msg"]];

        _dataMutableArr = [NSMutableArray array];
        [_mainTableView reloadData];
    }];
}

//加载学期信息
- (void)loadTermInfo{
    _termInfoArray = [NSMutableArray array];
    [_termInfoArray addObject:@"全部"];
    
    [ProgressHUD show:nil];
    NSDictionary *commitDic = @{
                                @"rid":@"getTermsAboutScore",
                                @"stuNo":stuNum
                                };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        _termInfoDic = [NSMutableDictionary dictionary];
        [_termInfoDic setObject:@"" forKey:@"全部"];
        for (NSDictionary *termDic in responseObject[@"data"]) {
            [_termInfoArray addObject:termDic[@"XNXQMC"]];
            [_termInfoDic setObject:termDic[@"XNXQDM"] forKey:termDic[@"XNXQMC"]];
        }
        
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

//弹出列表选择
- (void)selTermBtnBtnClick:(UIButton *)sender{
    WEAKSELF;
    TePopList *pop = [[TePopList alloc] initWithListDataSource:_termInfoArray withTitle:@"选择学期" withSelectedBlock:^(NSInteger select) {
        _termString = [_termInfoDic objectForKey:_termInfoArray[select]];
        _selIndex = select;
        [_selTermBtn setTitle:_termInfoArray[select] forState:UIControlStateNormal];
        [weakSelf loadData];
    }];
    [pop selectIndex:_selIndex];
    pop.isAllowBackClick = YES;
    [pop show];
}

#pragma mark TableView delegate&datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    [self.mainTableView startAutoCellHeightWithCellClass:[ExamListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return self.dataMutableArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ExamListTableViewCell";
    ExamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ExamListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataMutableArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model" cellClass:[ExamListTableViewCell class] contentViewWidth:kScreenWidth];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
