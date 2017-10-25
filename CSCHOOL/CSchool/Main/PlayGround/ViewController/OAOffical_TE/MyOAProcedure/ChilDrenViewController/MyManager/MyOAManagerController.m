//
//  MyOAManagerController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MyOAManagerController.h"
#import "OAModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OAOwnCell.h"
#import <YYModel.h>
#import "OAProdureInfoController.h"
#import <MJRefresh.h>
#import "JSDropDownMenu.h"
@interface MyOAManagerController ()<UITableViewDelegate,UITableViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    NSInteger _currentData1Index;

    
    NSMutableArray *_termInfoArray; //存放学期信息

}
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组
@property (nonatomic,assign)int  page;

@property (nonatomic,strong)JSDropDownMenu *menu;
@property (nonatomic,strong)NSMutableArray *produceModelArr;//用于筛选的数据
@property (nonatomic,copy )NSString *fi_id;//流畅ID
@end

@implementation MyOAManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"我管理的流程";
    [self createView];
    [self loadProduceName];
}
-(void)loadData
{
    [self loadNewData];
    [self loadProduceName];
}
//获取流程名称
-(void)loadProduceName
{
    self.produceModelArr = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@/getMyFlowName",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject) {
            [ProgressHUD dismiss];
            OAModel *model = [[OAModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_termInfoArray addObject:model.fi_name];
            [_produceModelArr addObject:model];
        }
        OAModel *model = [OAModel new];
        model.fi_id = @"0";
        model.fi_name = @"全部流程";
        [_produceModelArr insertObject:model atIndex:0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        NSLog(@"%@",error[@"content"]);
        [self showErrorViewLoadAgain:@"点击重新加载"];
    }];
    
}

-(void)loadNewData
{
    self.page = 0;
    self.modelArr = [NSMutableArray array];
    [self loadDatawithPage:self.page];
}
-(void)loadOldData{
    self.page ++;
    [self loadDatawithPage:self.page];
}

-(void)loadDatawithPage:(int)page
{
    /*
     in_state  1 查询我的发起 2 查询我的审批 3 查询我的管理
     in_fi_id  流程编号 0 查询全部
     in_yhbh  用户编号
     scode    学校code
     begin_num  开始行数
     num        影响行数
     in_sp_state  审批状态 1 待审批 2 已审批
     
     */
    [ProgressHUD show:@"正在加载..."];
    NSString *url = [NSString stringWithFormat:@"%@/getMyFormList",OABase_URL];
    NSString *pageString = [NSString stringWithFormat:@"%d",page];
    [NetworkCore requestMD5POST:url parameters:@{@"in_state":@"3",@"in_fi_id":_fi_id,@"in_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"begin_num":pageString,@"num":Message_Num,@"in_sp_state":@"3",@"flag":@"in_state,in_fi_id,in_yhbh,scode,begin_num,num,in_sp_state"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss ];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject;
        [self hiddenErrorView];
        if (page==0) {
            _modelArr = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.mainTableView.mj_header  endRefreshing];
                [self showErrorViewLoadAgain:@"未查询到相关数据"];
                return ;
            }
        }
        for (NSDictionary *dic in dataArray) {
            OAModel   *model = [[OAModel alloc] init];
            model.segmentName =@"我管理的流程";
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArr addObjectsFromArray:_dataSourceArr];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if (page>=0) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.mainTableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss ];
        [self showErrorViewLoadAgain:@"未查询到相关数据"];
    }];
}
-(void)createView
{
    _termInfoArray = [NSMutableArray array];
    [_termInfoArray addObject:@"全部流程"];
    //下拉按钮
    _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:35];
    _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    _menu.textColor = RGB(170, 170, 170) ;
    _menu.dataSource = self;
    _menu.delegate = self;
    _menu.backgroundColor = [UIColor whiteColor];
    // 指定默认选中
    _currentData1Index = 0;
    [self.view addSubview:_menu];
    
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35+2, kScreenWidth , kScreenHeight-40-64-35-2) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.mainTableView.mj_header beginRefreshing];
    [self.view addSubview:self.mainTableView];
    
    if (@available(iOS 11,*)) {
        if ([self.mainTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.mainTableView.estimatedRowHeight = 0;
            self.mainTableView.estimatedSectionHeaderHeight = 0;
            self.mainTableView.estimatedSectionFooterHeight = 0;
        }
    }
    _fi_id = @"0";//默认为查询全部

}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellID = @"OAOwnCell";
    OAOwnCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[OAOwnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    OAModel *model = self.modelArr[indexPath.section];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [OAOwnCell class];
    OAModel *model = _modelArr[indexPath.section];
    
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 14;
    }
    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16;
}
/*设置标题头的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = Base_Color2;
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OAProdureInfoController *vc = [[OAProdureInfoController alloc]init];
    vc.isExamine  = NO;
    OAModel *model = _modelArr[indexPath.section];
    vc.oi_id = model.oi_id ;
    vc.fi_id = model.fi_id;
    vc.listState = [model.sp_state isEqualToString:@"1"]?YES:NO;
    [self.navigationController pushViewController:vc animated:YES];
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
#pragma mark JSDropDownMene delegate & datasource

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 1;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    return _currentData1Index;

}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    return _termInfoArray.count;

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
  return _termInfoArray[_currentData1Index];
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    return [_termInfoArray objectAtIndex:indexPath.row];

}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        OAModel *model = _produceModelArr[indexPath.row];
        _fi_id = model.fi_id;
        
    }
    [self loadDatawithPage:0];
    
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
