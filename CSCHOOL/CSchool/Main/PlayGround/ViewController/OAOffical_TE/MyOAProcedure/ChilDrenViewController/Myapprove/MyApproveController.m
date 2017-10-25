//
//  MyApproveController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MyApproveController.h"
#import "OAModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OAOwnCell.h"
#import <YYModel.h>
#import "OAProdureInfoController.h"
#import "BatchToSolveController.h"
#import <MJRefresh.h>
#import "JSDropDownMenu.h"

@interface MyApproveController ()<UITableViewDelegate,UITableViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    
    NSInteger _currentData1Index;
    NSInteger _currentData1SelectedIndex;
    NSInteger _currentData2Index;

    NSMutableArray *_classStateArray; //存放科目状态（全部、通过、未通过）
    NSMutableDictionary *_termInfoDic; //存放学期名称与字段对应信息
    NSMutableArray *_termInfoArray; //存放学期信息
    NSString       *_nocticeWord;
}
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组
@property (nonatomic,assign)int  page;


@property (nonatomic,strong)JSDropDownMenu *menu;
@property (nonatomic,strong)NSMutableArray *produceModelArr;//用于筛选的数据
@property (nonatomic,copy )NSString *fi_id;//流程ID
@property (nonatomic,copy )NSString *sp_state;//审批状态 1，待审批  2，已审批

@property (nonatomic,strong)UIView *noticeView;

@end

@implementation MyApproveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"我审批的流程";
    [self createView];
    [self loadProduceName];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotification:) name:@"OAHaveBeApprove" object:nil];
}
#pragma mark 获取到工单处理的通知
-(void)reciveNotification:(NSNotification *)notification
{
    [self loadNewData];
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
//创建视图
-(void)createView
{
    _classStateArray = [NSMutableArray array];
    [_classStateArray addObjectsFromArray:@[@"审批状态",@"待审批",@"已审批"]];
    _termInfoArray = [NSMutableArray array];
    [_termInfoArray addObject:@"全部流程"];
    //下拉按钮
    _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:35];
    _menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    _menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    _menu.textColor = RGB(170, 170, 170) ;
    _menu.dataSource = self;
    _menu.delegate = self;
    // 指定默认选中
    _currentData1Index = 0;
    _currentData1SelectedIndex = 0;
    [self.view addSubview:_menu];
    
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35+2, kScreenWidth , kScreenHeight-40-64-35-2) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11,*)) {
        if ([self.mainTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.mainTableView.estimatedRowHeight = 0;
            self.mainTableView.estimatedSectionHeaderHeight = 0;
            self.mainTableView.estimatedSectionFooterHeight = 0;
        }
    }
    _fi_id = @"0";//默认为查询全部
    _sp_state = @"3";
}
//获取提示信息
-(void)loadBadgeValueData
{
   
    NSString *url = [NSString stringWithFormat:@"%@/getOrderCountByUserAndScode",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"in_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_yhbh,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject integerValue]>0) {
            if ([self.view.subviews containsObject:self.noticeView]) {
                [UIView transitionWithView:self.view duration:0.25 options:0 animations:^{
                    self.noticeView.center = CGPointMake(kScreenWidth / 2,25/2);
                } completion:^(BOOL finished) {
                    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:2];
                    
                }];
            }
            _nocticeWord =  [NSString stringWithFormat:@"有%@个待办流程需要您审批,请及时处理!",responseObject];
            [self performSelector:@selector(createNoticeView) withObject:nil afterDelay:0.5];
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        _nocticeWord = @"获取待办数量失败,您可以下拉重新获取!";
//        [self performSelector:@selector(createNoticeView) withObject:nil afterDelay:1.5];

    }];

}
-(void)createNoticeView
{
    
    self.noticeView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB_Alpha(230, 120, 12, 0.8);//RGB(230,120,12)
        view;
    });
    UILabel *noticeW = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor whiteColor];
        view.text = _nocticeWord;
        view.font = [UIFont systemFontOfSize:11];
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    [self.noticeView addSubview:noticeW];
    [self.view addSubview:self.noticeView];
    [self.view bringSubviewToFront:self.noticeView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAlert)];
    tapGesture.numberOfTapsRequired = 1;
    [self.noticeView addGestureRecognizer:tapGesture];
    
    noticeW.sd_layout.leftSpaceToView(self.noticeView,0).rightSpaceToView(self.noticeView,0).widthIs(kScreenWidth).heightIs(25);
    self.noticeView.frame = CGRectMake(0,-25,kScreenWidth, 25);
    [UIView transitionWithView:self.view duration:0.25 options:0 animations:^{
        self.noticeView.center = CGPointMake(kScreenWidth / 2,25/2);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeAlert) withObject:nil afterDelay:2];

    }];
    
}
#pragma mark - 移除提示框
- (void)removeAlert{
    [UIView transitionWithView:self.view duration:0.25 options:0 animations:^{
        self.noticeView .center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,-25);
    } completion:^(BOOL finished) {
        [self.noticeView  removeFromSuperview];
    }];
}

-(void)loadNewData
{
    self.page = 0;
    self.modelArr = [NSMutableArray array];
    [self loadBadgeValueData];
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
    [NetworkCore requestMD5POST:url parameters:@{@"in_state":@"2",@"in_fi_id":_fi_id,@"in_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"begin_num":pageString,@"num":Message_Num,@"in_sp_state":_sp_state,@"flag":@"in_state,in_fi_id,in_yhbh,scode,begin_num,num,in_sp_state"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
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
            model.segmentName =@"我审批的流程";
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


#pragma mark 打开批量编辑界面
-(void)openOABatchALlVc:(UIButton *)sender
{
    BatchToSolveController *vc = [BatchToSolveController new];
    
    [self.navigationController pushViewController:vc animated:YES];
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
    
    OAModel *model = _modelArr[indexPath.section];
    vc.oi_id = model.oi_id ;
    vc.fi_id = model.fi_id;
    vc.isExamine = YES;
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
    
    return 2;
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
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        
        return _termInfoArray.count;
        
    } else if (column==1){
        
        return _classStateArray.count;
        
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _termInfoArray[_currentData1Index];
            break;
        case 1: return _classStateArray[_currentData2Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return [_termInfoArray objectAtIndex:indexPath.row];
        
    } else {
        
        return _classStateArray[indexPath.row];
        
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        OAModel *model = _produceModelArr[indexPath.row];
        _fi_id = model.fi_id;
        
    } else{
        _currentData2Index = indexPath.row;
        NSArray *stateArr = @[@"3",@"1",@"2"];
        _sp_state = stateArr[indexPath.row];
    }
    [self loadDatawithPage:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    // 取消通知
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"OAHaveBeApprove"
                                                 object:nil];
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
