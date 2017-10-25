//
//  OAMainViewController.m
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAMainViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OAMainCell.h"
#import "OAModel.h"
#import <YYModel.h>
#import "OAHeadView.h"

@interface OAMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArrry;
@end

@implementation OAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];

    self.title = @"移动办公";
//    [self loadData];
    [self alertToWriteNum];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reciveNotification:) name:@"OAHaveBeApprove" object:nil];
    
}

//*  输入下一步审批人的账号
-(void)alertToWriteNum
{
    XGAlertView *alert = [[XGAlertView alloc]initWithTitle:@"请输入下一步审批人的账号" withUnit:@"" click:^(NSString *index) {
        [AppUserIndex GetInstance].role_id = index;
        [self loadData];
    }];
    [alert show];
}

-(void)reciveNotification:(NSNotification *)notification
{
    [self loadBadgeValueData];
}

-(void)loadBadgeValueData
{
    NSArray *topData = @[
                         @{
                             @"title":@"待办事项",
                             @"tag":@"101",
                             @"isNotice":@"1",
                             @"badgeValue":@"0"
                             
                             },
                         @{
                             @"title":@"管理",
                             @"tag":@"102",
                             @"isNotice":@"0",
                             @"badgeValue":@"0"
                             },
                         @{
                             @"title":@"我的办公",
                             @"tag":@"103",
                             @"isNotice":@"0",
                             @"badgeValue":@"0"
                             }
                         
                         ];
    NSMutableArray *topArr = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@/getOrderCountByUserAndScode",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"in_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_yhbh,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);

        for (NSDictionary *dic in topData) {
            OAModel *model = [[OAModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            if ([dic[@"tag"] isEqualToString:@"101"]) {
                model.badgeValue = responseObject;
            }
            [topArr addObject:model];
        }
        OAHeadView *headView = [[OAHeadView alloc]initWithButtonArry:topArr];
        [self.view addSubview:headView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        for (NSDictionary *dic in topData) {
            OAModel *model = [[OAModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [topArr addObject:model];
        }
        OAHeadView *headView = [[OAHeadView alloc]initWithButtonArry:topArr];
        [self.view addSubview:headView];
    }];
}




-(void)loadData
{
    [self loadBadgeValueData];

    _modelArrry = [NSMutableArray array];
    
    [ProgressHUD show:@"正在加载首页..."];
    NSString *url = [NSString stringWithFormat:@"%@/getUserQx",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"zgh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"zgh,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [ProgressHUD dismiss];
            OAModel *model = [[OAModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArrry addObject:model];
        }
//        if (_modelArrry.count==0) {
//            [self showNonetWork];
//        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        NSLog(@"%@",error[@"content"]);
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:@"点击重新加载"];
    }];
}
#pragma mark  创建视图
-(void)createView
{
    self.view.backgroundColor = Base_Color2;
       self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80+2, kScreenWidth, kScreenHeight-64-80-2) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
}
#pragma mark UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _modelArrry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"OAFunctionCell";
    OAMainCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OAMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    OAModel *model = _modelArrry[indexPath.section];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [OAMainCell class];
    NSMutableArray *funtionArr = [NSMutableArray array];
    OAModel *model = _modelArrry[indexPath.section];
    for (NSDictionary *dic in model.data) {
        OAModel *model = [[OAModel alloc]init];
        [model yy_modelSetWithDictionary:dic];
        [funtionArr addObject:model];
    }
    if (funtionArr.count<=4) {
        return 160;
    }
    return 280;
//    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"OAHaveBeApprove" object:nil];
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
