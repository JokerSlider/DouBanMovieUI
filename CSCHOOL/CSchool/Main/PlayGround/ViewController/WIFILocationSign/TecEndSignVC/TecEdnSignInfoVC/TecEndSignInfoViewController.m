//
//  TecEndSignInfoViewController.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecEndSignInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import "TecEndTableHeaderView.h"
#import <YYModel.h>
#import "TecEndInfoHeadView.h"
#import "TecEndInfoCell.h"
@interface TecEndSignInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableview;
@property (nonatomic,strong) TecEndInfoHeadView *headView;
@property (nonatomic,strong) TecEndTableHeaderView *tabheadview;
@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) CGFloat lastTableViewOffsetY;//记录上一个偏移量
@end

@implementation TecEndSignInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:Base_Color2];
    self.title = @"签到统计";
    [self createView];
    [self loadData];
}
-(void)createView
{
    [self.view addSubview:self.mainTableview];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tabheadview];
}
-(TecEndInfoHeadView *)headView
{
    if (!_headView) {
        _headView = [[TecEndInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    }
    return _headView;
}
-(UITableView *)mainTableview
{
    if (!_mainTableview) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 250+45, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        self.currentTableView = _mainTableview;
        _mainTableview.tableFooterView = [UIView new];
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [ _mainTableview addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
    return _mainTableview;
}
-(TecEndTableHeaderView *)tabheadview
{
    if (!_tabheadview) {
        _tabheadview = [[TecEndTableHeaderView alloc]initWithFrame:CGRectMake(0, 250, kScreenWidth, 45)];
    }
    return _tabheadview;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    
    UITableView *tableView = (UITableView *)object;
    
    
    if (!(self.currentTableView == tableView)) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    
    self.lastTableViewOffsetY = tableViewoffsetY;
    
    if ( tableViewoffsetY>=0 && tableViewoffsetY<=250) {
        
        self.headView.frame = CGRectMake(0, 0-tableViewoffsetY, kScreenWidth, 250);
        self.tabheadview.frame = CGRectMake(0, 250-tableViewoffsetY, kScreenWidth, 45);
        self.mainTableview.frame = CGRectMake(0, (250+45)-tableViewoffsetY, kScreenWidth, kScreenHeight-64);
        
    }else if( tableViewoffsetY < 0){
        
        self.headView.frame = CGRectMake(0, 0, kScreenWidth, 250);
        self.tabheadview.frame = CGRectMake(0, 250, kScreenWidth, 45);
        self.mainTableview.frame = CGRectMake(0, (250+45), kScreenWidth, kScreenHeight-64);
        
    }else if (tableViewoffsetY > 250){
        self.tabheadview.frame = CGRectMake(0, 0, kScreenWidth, 45);
        self.headView.frame = CGRectMake(0, -250, kScreenWidth, 250);
        self.mainTableview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        
    }
}

-(void)loadData
{
    _modelArr = [NSMutableArray array];
    WIFICellModel *model = [[WIFICellModel alloc]init];
    model.titleArr = @[@"时间",@"次数",@"结果"];
    self.tabheadview.model = model;
    
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    [ProgressHUD show:@"正在加载..."];
    [NetworkCore requestPOST:url parameters:@{@"rid":@"showStuInfoByTeacherNo",@"stuId":_stuID,@"teacherId":teacherNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        for (NSDictionary *dic in responseObject[@"info"]) {
            WIFICellModel *model = [WIFICellModel new];
            [model yy_modelSetWithDictionary:dic];
            self.headView.model = model;
        }
        for (NSDictionary *dic  in responseObject[@"data"]) {
            WIFICellModel *model = [WIFICellModel new];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        [self.mainTableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];

}
#pragma mark Delegate  And  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TecEndSignInfoCell";
    TecEndInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[TecEndInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = _modelArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark
-(void)dealloc
{
    [_mainTableview removeObserver:self forKeyPath:@"contentOffset" context:nil];
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
