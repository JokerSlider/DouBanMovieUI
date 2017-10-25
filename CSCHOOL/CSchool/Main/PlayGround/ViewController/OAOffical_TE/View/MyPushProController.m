//
//  MyPushProController.m
//  CSchool
//
//  Created by mac on 17/8/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

//
//  MyOAManagerController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MyPushProController.h"
#import "OAModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OAOwnCell.h"
#import <YYModel.h>
#import "OAProdureInfoController.h"
#import <MJRefresh.h>
@interface MyPushProController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentData1Index;
    
    NSMutableArray *_termInfoArray; //存放学期信息
    
}
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组
@property (nonatomic,assign)int  page;

@property (nonatomic,strong)NSMutableArray *produceModelArr;//用于筛选的数据
//@property (nonatomic,copy )NSString *fi_id;//流畅ID
@end

@implementation MyPushProController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = [NSString stringWithFormat:@"%@",_procedureName];
    [self createView];
}
-(void)loadData{
    [self loadNewData];
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
    [NetworkCore requestMD5POST:url parameters:@{@"in_state":@"1",@"in_fi_id":_procedureID,@"in_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"begin_num":pageString,@"num":Message_Num,@"in_sp_state":@"1",@"flag":@"in_state,in_fi_id,in_yhbh,scode,begin_num,num,in_sp_state"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
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
            model.segmentName =@"我发起的流程";
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        [_modelArr addObjectsFromArray:_dataSourceArr];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        if (dataArray.count<=[Message_Num intValue]) {
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
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight-64) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.mainTableView.mj_header beginRefreshing];
    [self.view addSubview:self.mainTableView];
    
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
