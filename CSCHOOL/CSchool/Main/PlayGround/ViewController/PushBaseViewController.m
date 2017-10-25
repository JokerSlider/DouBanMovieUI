//
//  PushBaseViewController.m
//  CSchool
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PushBaseViewController.h"
#import "FindLoseModel.h"
#import "FindLose2Cell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "FindInfoViewController.h"
#import <MJRefresh.h>
#import "TableViewAnimationKitHeaders.h"

@interface PushBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic,strong) NSArray *iconImageNamesArray;//缩略图数组
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组

@property (nonatomic,assign)int  totalCount;//总数
@end

@implementation PushBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11,*)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        }
    }
    
    _modelsArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = Base_Color2;
    self.tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(kScreenHeight-64);
}

-(void)loadData
{
    
}
//数据请求
-(void)loadDataWithMainFuncType:(NSString *)type andPushType:(NSString *)pushType pageNum:(NSString *)page
{

    [NetworkCore requestPOST: [AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showReleaseInfoByModule",@"module":_funcType,@"isdivide":@"0",@"reltype":pushType,@"page":page,@"pageCount":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        [self hiddenErrorView];
        if ([page isEqualToString:@"1"]) {
            _modelsArray = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.tableView reloadData];
                [self showErrorViewLoadAgain:@"没有相关数据！"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            FindLoseModel   *model = [[FindLoseModel alloc] init];
            model.type = _funcType;
            model.thumb  = responseObject[@"thumb"];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelsArray addObjectsFromArray:_dataSourceArr];
        [self.tableView reloadData];
        if ([page intValue]==1) {
            [self starAnimationWithTableView:self.tableView];
        }

        [self.tableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if ([page intValue]>=0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.modelsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString *ID =@"lostCell";
    FindLose2Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[FindLose2Cell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    FindLoseModel *model = self.modelsArray[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [FindLose2Cell class];
    FindLoseModel *model = self.modelsArray[indexPath.section];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindInfoViewController *vc = [[FindInfoViewController alloc]init];
    FindLoseModel *model = self.modelsArray[indexPath.section];
    vc.imageArr = model.thumblicArray;
    vc.reiId = model.ID;
    vc.model= model;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (void)starAnimationWithTableView:(UITableView *)tableView {
    
    [TableViewAnimationKit showWithAnimationType:3 tableView:tableView];
}
////隐藏导航栏
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//
//}
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if(velocity.y>0)
//    {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        CGRect frame = CGRectMake(0, 10, kScreenWidth,kScreenHeight-40-20);
//        self.tableView.frame = frame;
//    }
//    else
//    {
//
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        CGRect frame = CGRectMake(0, 10, kScreenWidth,kScreenHeight-40-20-64);
//        self.tableView.frame = frame;
//    }
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
