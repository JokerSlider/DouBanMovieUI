//
//  HaveReturnViewController.m
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "HaveReturnViewController.h"
#import "UIView+SDAutoLayout.h"
#import "HaveReturnCell.h"
#import <MJRefresh.h>
#import "LibiraryModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface HaveReturnViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *mainTableview;
@property (nonatomic,copy)NSMutableArray *modelArr;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组

@end

@implementation HaveReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _modelArr = [NSMutableArray array];
    _page = 1;
    [self setupView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
-(void)loadPastData
{
    _page++;
    [self loadDataPageNum:_page];
}
-(void)loadData
{
    _page = 1;
    [self loadDataPageNum:_page];
}
-(void)loadDataPageNum:(int )page
{
    [ProgressHUD show:@"正在加载..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showMyBorrowList",@"state":@"1",@"page":@(_page),@"pageCount":Message_Num,@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        [self hiddenErrorView];
        if (_page==1) {
            _modelArr = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.mainTableview reloadData];
                [self showErrorViewLoadAgain:@"没有相关数据！"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            LibiraryModel   *model = [[LibiraryModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArr addObjectsFromArray:_dataSourceArr];
        [self.mainTableview reloadData];
        [self.mainTableview.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if (_page>=0) {
                [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.mainTableview.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
        [self.mainTableview.mj_header endRefreshing];
        [self.mainTableview.mj_footer endRefreshing];
    
    }];
}

-(void)setupView
{
    _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    [self.view addSubview:_mainTableview];
    _mainTableview.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(kScreenHeight-64-40-80);
    
    _mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    [_mainTableview.mj_header beginRefreshing];
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modelArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString *ID =@"haveReturnCell";
    HaveReturnCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HaveReturnCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    LibiraryModel *model = _modelArr[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 8*15+7*5+10+10;

    Class currentClass = [HaveReturnCell class];
    LibiraryModel *model = _modelArr[indexPath.section];
    return [self.mainTableview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor redColor];
    return headView;
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
