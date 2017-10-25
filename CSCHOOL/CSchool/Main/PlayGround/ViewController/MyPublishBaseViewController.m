//
//  MyPublishBaseViewController.m
//  CSchool
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyPublishBaseViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "FindInfoViewController.h"
#import "MyPublishCell.h"
#import "FindLoseModel.h"
#import <MJRefresh.h>
#import "MarketSendViewController.h"
#import "FinfLosedViewController.h"
#import "MyPublishViewController.h"
@interface MyPublishBaseViewController ()<UITableViewDelegate,UITableViewDataSource,XGAlertViewDelegate>
{
    NSString *_reyid;//单子号
    NSString *_stateNum;//状态  下架
}
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic,strong)NSArray *iconImageNamesArray;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;
@property (nonatomic,strong)NSIndexPath *index;
@end

@implementation MyPublishBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  createView];
}
//创建view
-(void)createView
{
    self.view.backgroundColor = Base_Color2;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11,*)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
        }
    }
    self.tableView.sd_layout.leftSpaceToView(self.view,7).rightSpaceToView(self.view,7).topSpaceToView(self.view,0).heightIs(kScreenHeight-64-7);
    _modelsArray = [NSMutableArray array];
}
-(void)loadData
{
}
//此处为加载数据入口
-(void)loadDataWithFuncType:(NSString *)type andPushType:(NSString *)pushType pageNum:(NSString *)page;
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getReleaseInfoByUserid",@"module":_funcType,@"auitype":pushType,@"username":user.role_id,@"page":page,@"pageCount":Message_Num} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        NSArray *dataArray = responseObject[@"data"];
        if ([page isEqualToString:@"1"]) {
            _modelsArray = [NSMutableArray array];
            if (dataArray.count==0) {
                [self.tableView reloadData];
                [self showErrorViewLoadAgain:@"暂时没有您的发布消息，快去发布吧"];
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
        //撤销的放到最后显示
//        self.modelsArray = [self compareArrayByCompartens:self.modelsArray];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (dataArray.count<[Message_Num intValue]) {
            if ([page intValue]>=0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:@"没有相关数据！"];
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
    
    static  NSString *ID =@"myPublish";
    MyPublishCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MyPublishCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    FindLoseModel *model = self.modelsArray[indexPath.section];
    cell.model = model;
    [cell.deletMenu addTarget:self action:@selector(deletMessage:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.dropMenu addTarget:self action:@selector(dropMenuMess:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editMenu addTarget:self action:@selector(editMenuMessage:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [MyPublishCell class];
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
    vc.model = model;
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
#pragma  mark 删除  编辑  下架  
-(void)deletMessage:(UIButton *)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        _index = indexPath;
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"确定要删除？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
        alert.delegate = self;
        [alert show];
    
    }
}
//删除弹窗
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    FindLoseModel *model = self.modelsArray[_index.section];
    [ProgressHUD show:@"正在加载..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"deleteReleaseInfoByUuid",@"relid":model.ID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:responseObject[@"msg"]];
        FindLoseModel *model = self.modelsArray[_index.section];
        [self.modelsArray removeObjectAtIndex:_index.section];
        if (self.modelsArray.count==0) {
            [self showErrorViewLoadAgain:@"暂时没有您的发布消息，快去发布吧"];
        }
        [self.tableView reloadData];

        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in marr) {
            if ([vc isKindOfClass:[MyPublishViewController  class]]) {
                __weak  MyPublishViewController *wself =(MyPublishViewController *)vc;
                wself.block(model.infoType);
                break;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:@"操作失败!"];
    }];
}
-(void)dropMenuMess:(UIButton *)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    MyPublishCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (indexPath!= nil)
    {
        //下架
        FindLoseModel *model = self.modelsArray[indexPath.section];
        if ([model.state isEqualToString:@"1"]) {
            _stateNum = @"2";
        }else{
            _stateNum = @"1";
        }
        //state  状态（ 1：标示已下架 ，2：标示正在热卖）
        [ProgressHUD show:@"正在操作..."];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"updateFromSaleByUuid",@"relid":model.ID,@"state":_stateNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD showSuccess:responseObject[@"msg"]];
            
            model.state =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"state"]];
            if ([model.state isEqualToString:@"1"]) {
                cell.dropNoticeView.hidden = NO;
            }else{
                cell.dropNoticeView.hidden = YES;
            }
            sender.selected =!sender.selected;
            [self.modelsArray replaceObjectAtIndex:indexPath.section withObject:model];
            //排序  撤销的下移  在线移动到最上边  此处不是按照时间排序 
//            self.modelsArray = [self compareArrayByCompartens:self.modelsArray];
            
            [self.tableView reloadData];
            NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            for (UIViewController *vc in marr) {
                if ([vc isKindOfClass:[MyPublishViewController  class]]) {
                    __weak  MyPublishViewController *wself =(MyPublishViewController *)vc;
                    wself.block(model.infoType);
                    break;
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD showError:@"操作失败!"];
            sender.layer.borderColor = Base_Orange.CGColor;
        }];
     }
    
}
-(NSMutableArray *)compareArrayByCompartens:(NSMutableArray *)Array{
    NSArray *nerCourse = [Array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        FindLoseModel   *model = obj1;
        if ([model.state isEqualToString:@"1"]) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    return [NSMutableArray arrayWithArray:nerCourse];
}
//编辑
-(void)editMenuMessage:(UIButton *)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath= [_tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        //编辑
        FindLoseModel *model = self.modelsArray[indexPath.section];
//        NSLog(@"%@",model.ID);
        MarketSendViewController *vc = [[MarketSendViewController alloc] init];
        vc.model = model;
        vc.module = _funcType;
        vc.reltype = model.infoType;
        WEAKSELF;
        vc.sendSucessBlock = ^(NSString *relType){
            [weakSelf.tableView.mj_header beginRefreshing];
            
            NSArray *vcArray = self.navigationController.viewControllers;
            if ([vcArray[vcArray.count-3] isKindOfClass:[FinfLosedViewController class]]) {
                FinfLosedViewController *vc = vcArray[vcArray.count-3];
                if ([relType isEqualToString:@"1"]) {
                    [vc.news loadPushData];
                }else{
                    [vc.news2 loadReData];
                }
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }

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
