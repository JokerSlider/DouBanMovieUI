//
//  BatchToSolveController.m
//  CSchool
//
//  Created by mac on 17/6/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BatchToSolveController.h"
#import "OABatchCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OASuggestionController.h"
#import <MJRefresh.h>
@interface BatchToSolveController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//传递数组
@property (nonatomic,assign)int  page;

@property (nonatomic,strong)UIButton *allSelectedBtn;//全选
@property (nonatomic,strong)UIButton *batchBySelctBtn;//批量审批

@property (strong, nonatomic) NSMutableArray *editArr;
@property (assign, nonatomic) NSInteger editNum;


@end

@implementation BatchToSolveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"批量审批";
    self.editArr = [[NSMutableArray alloc]init];
    [self createView];
    [self loadData];
}
-(void)createView
{
    self.mainTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-66) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.editing = YES;
    self.mainTableView.allowsMultipleSelectionDuringEditing = YES;
    [self.view addSubview:self.mainTableView];
    
    UIView *backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    self.allSelectedBtn = ({
        UIButton *view = [UIButton new];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setBackgroundImage:[UIImage imageNamed:@"AllSelectedBtn"] forState:UIControlStateNormal];
        [view setBackgroundImage:[UIImage imageNamed:@"AllSelectedBtn_selected"] forState:UIControlStateSelected];
        [view setTitle:@"全选" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(allSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setTitle:@"取消全选" forState:UIControlStateSelected];
        view;
    });
    self.batchBySelctBtn =({
        UIButton *view = [UIButton new];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setBackgroundImage:[UIImage imageNamed:@"delete_btn"] forState:UIControlStateNormal];
        [view setTitle:@"批量审批(0)" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(batchData) forControlEvents:UIControlEventTouchUpInside];
        view;
        
    });
    
    [backView sd_addSubviews:@[self.allSelectedBtn,self.batchBySelctBtn]];
    [self.view addSubview:backView];
    
    backView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(60);
    self.allSelectedBtn.sd_layout.leftSpaceToView(backView,50).centerYIs(backView.centerY).heightIs(30).widthIs((kScreenWidth-100-20)/2);
    self.batchBySelctBtn.sd_layout.rightSpaceToView(backView,50).centerYIs(backView.centerY).heightIs(30).widthIs((kScreenWidth-100-20)/2);
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.mainTableView.mj_header beginRefreshing];
}

-(void)loadNewData
{
    self.editNum = 0;
    self.editArr = [NSMutableArray array];
    [self.batchBySelctBtn setTitle:@"批量审批(0)" forState:UIControlStateNormal];

    self.page = 0;
    [self loadDatawithPage:self.page];
}
-(void)loadOldData{
    self.page ++;
    [self loadDatawithPage:self.page];
}

-(void)loadDatawithPage:(int)page
{
    self.modelArr = [NSMutableArray array];
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
    [NetworkCore requestMD5POST:url parameters:@{@"in_state":@"2",@"in_fi_id":_fi_id,@"in_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"begin_num":pageString,@"num":@"15",@"in_sp_state":@"1",@"flag":@"in_state,in_fi_id,in_yhbh,scode,begin_num,num,in_sp_state"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss ];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject;
        [self hiddenErrorView];
        if (page==0) {
            _modelArr = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.mainTableView reloadData];
                [JohnAlertManager showFailedAlert:@"未查询到相关数据!" andTitle:@"提示"];
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
        [JohnAlertManager showFailedAlert:@"未查询到相关数据!" andTitle:@"提示"];
        [ProgressHUD dismiss ];
        
    }];
}

-(void)batchData
{
    if (self.editArr.count==0) {
        [JohnAlertManager showFailedAlert:@"请至少选择一项" andTitle:@"提示"];
        return;
    }
    
    if (self.mainTableView.editing) {
        //将存着ID的数组传递给下一个界面
        //跳转到填写意见界面
        NSMutableArray *oi_idArr = [NSMutableArray array];
        for (NSString  *oi_id  in self.editArr) {
            [oi_idArr addObject:oi_id];
        }
        OASuggestionController   *vc = [[OASuggestionController alloc]init];
        vc.oi_id =[oi_idArr componentsJoinedByString:@","];
        vc.fi_id = _fi_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}
#pragma mark 全选
-(void)allSelectedAction:(UIButton *)sender{
    if (!self.allSelectedBtn.selected) {
        self.allSelectedBtn.selected = YES;
        [self.editArr removeAllObjects];
        self.editNum = self.modelArr.count;
        [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"批量审批(%lu)",self.editNum] forState:UIControlStateNormal];
        for (int i = 0; i < self.modelArr.count; i++) {
            OAModel *model = _modelArr[i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            [self.editArr addObject:model.oi_id];
        }
    }else{
        self.allSelectedBtn.selected = NO;
        [self.editArr  removeAllObjects];

        for (int i = 0; i < self.modelArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.mainTableView  deselectRowAtIndexPath:indexPath animated:YES];
        }
        self.editNum    = 0;
        [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"批量审批(%lu)",self.editNum] forState:UIControlStateNormal];
    }
}
#pragma mark
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _modelArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString   *cellID = @"OABatchCell";
    OABatchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OABatchCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.model = _modelArr[indexPath.section];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [OABatchCell class];
    OAModel *model = _modelArr[indexPath.section];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.001;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 14;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = Base_Color2;
    return headView;
}
#pragma mark 选择
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OAModel *model = _modelArr[indexPath.section];
    [self.editArr addObject:model.oi_id];
    self.editNum += 1;
    [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"批量审批(%lu)",self.editNum] forState:UIControlStateNormal];
    if (self.editArr.count==self.modelArr.count) {
        NSLog(@"此处显示取消全选！！！");
        self.allSelectedBtn.selected = YES;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    OAModel *model = _modelArr[indexPath.section];
    [self.editArr removeObject:model.oi_id];
    self.editNum -= 1;
    [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"批量审批(%lu)",self.editNum] forState:UIControlStateNormal];
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
