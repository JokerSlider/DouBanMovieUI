//
//  TecEndSignController.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecEndSignController.h"
#import "UIView+SDAutoLayout.h"
#import "TecEndTableHeaderView.h"
#import <YYModel.h>
#import "TecEndHeadView.h"
#import "TecEndSignCell.h"
#import "TecEndSignInfoViewController.h"
@interface TecEndSignController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableview;
@property (nonatomic,strong) TecEndHeadView *headView;
@property (nonatomic,strong) TecEndTableHeaderView *tabheadview;
@property (nonatomic,strong)NSMutableArray *modelArr;

@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, assign) CGFloat lastTableViewOffsetY;//记录上一个偏移量


@end

@implementation TecEndSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
    [self.view setBackgroundColor:Base_Color2];
    self.title = @"签到统计";

    [self loadData];
}
-(void)createView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableview];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tabheadview];
    //    self.headView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(71);
//    self.tabheadview.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.headView,0).heightIs(45);
//    self.mainTableview.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.tabheadview,0).bottomSpaceToView(self.view,0);
}
-(TecEndHeadView *)headView
{
    if (!_headView) {
        _headView = [[TecEndHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 71)];
    }
    return _headView;
}
-(UITableView *)mainTableview
{
    if (!_mainTableview) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 71+45, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
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
        _tabheadview = [[TecEndTableHeaderView alloc]initWithFrame:CGRectMake(0, 71, kScreenWidth, 45)];
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
    CGFloat  distance = 71;
    if ( tableViewoffsetY>=0 && tableViewoffsetY<=distance) {
        
        self.headView.frame = CGRectMake(0, 0-tableViewoffsetY, kScreenWidth, 71);
        self.tabheadview.frame = CGRectMake(0, 71-tableViewoffsetY, kScreenWidth, 45);
        self.mainTableview.frame = CGRectMake(0, (71+45)-tableViewoffsetY, kScreenWidth, kScreenHeight-64);

    }else if( tableViewoffsetY < 0){
        
        self.headView.frame = CGRectMake(0, 0, kScreenWidth, 71);
        self.tabheadview.frame = CGRectMake(0, 71, kScreenWidth, 45);
        self.mainTableview.frame = CGRectMake(0, (71+45), kScreenWidth, kScreenHeight-64);

    }else if (tableViewoffsetY > distance){
        self.tabheadview.frame = CGRectMake(0, 0, kScreenWidth, 45);
        self.headView.frame = CGRectMake(0, -71, kScreenWidth, 71);
        self.mainTableview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);

    }
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//}
//}

-(void)loadData
{
    _modelArr = [NSMutableArray array];
    WIFICellModel *model = [[WIFICellModel alloc]init];
    model.titleArr = @[@"学号",@"姓名",@"课程",@"签到",@"AP定位"];
    
    self.tabheadview.model = model;
    
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    if (!_signID) {
        return;
    }
    [NetworkCore requestPOST:url parameters:@{@"id":_signID,@"rid":@"showSignDetForTeacherNo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        WIFICellModel *headViewmodel= [WIFICellModel new];
        for (NSDictionary *dic in responseObject[@"info"]) {
            headViewmodel = [WIFICellModel new];
            [headViewmodel yy_modelSetWithDictionary:dic];
            self.headView.model = headViewmodel ;
        }
        for (NSDictionary *dic in responseObject[@"data"]) {
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
    static NSString *cellID = @"TecEndSignCell";
    TecEndSignCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[TecEndSignCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    TecEndSignInfoViewController    *vc = [TecEndSignInfoViewController new];
    WIFICellModel *model = _modelArr[indexPath.row];
    vc.stuID = model.yhbh;
    [self.navigationController pushViewController:vc animated:YES];

}
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
