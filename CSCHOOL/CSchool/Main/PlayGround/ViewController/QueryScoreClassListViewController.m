//
//  QueryScoreClassListViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/26.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "QueryScoreClassListViewController.h"
#import "TePopList.h"

@interface QueryScoreClassListViewController ()
{
    UIButton *_selTermBtn;
    NSMutableDictionary *_termInfoDic; //存放学期名称与字段对应信息
    NSMutableArray *_termInfoArray; //存放学期信息
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *termString;

@property (nonatomic, assign) NSInteger selIndex;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong) UIButton *termBtn; //选择学期按钮

@end

@implementation QueryScoreClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"办公电话";
    [self loadTermInfo];
    [self loadData];
    _mainTableView.tableFooterView = [UIView new];
}

- (void)loadData{
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showDepartmentsInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = responseObject[@"data"];
        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}


//加载学期信息
- (void)loadTermInfo{
    
    _termBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _termBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_termBtn setBackgroundColor:[UIColor whiteColor]];
    _termBtn.frame = CGRectMake(kScreenWidth/2-80, 2, 160, 30);
//    [_termBtn setTitle:@"1层" forState:UIControlStateNormal];
    [_termBtn setTitleColor:Color_Gray forState:UIControlStateNormal];
    
    [_termBtn addTarget:self action:@selector(selTermBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _termBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _termBtn.layer.borderWidth = 0.5;
    _termBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _termBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_termBtn setTitleColor:Color_Gray forState:UIControlStateNormal];
    
    [_headerView addSubview:_termBtn];
    
    
    
    
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
        [_termBtn setTitle:responseObject[@"data"][1][@"XNXQMC"] forState:UIControlStateNormal];

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
        [_termBtn setTitle:_termInfoArray[select] forState:UIControlStateNormal];
        [weakSelf loadData];
    }];
    [pop selectIndex:_selIndex];
    pop.isAllowBackClick = YES;
    [pop show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = Color_Black;
    }
    cell.textLabel.text = _dataArray[indexPath.row][@"DD_NAME"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:NO];
//    [self.navigationController pushViewController:vc animated:YES];
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
