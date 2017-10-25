//
//  WifiSignSureController.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WifiSignSureController.h"
#import "WIFIClassSureCell.h"
#import "WIFICellModel.h"
#import <YYModel.h>
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "WIFIChoseClassController.h"
#import "WIFISignInfoNormalCell.h"
#import "WIFIEditFooterView.h"
#import "WifiSignEditController.h"
#import "TechInitSignViewController.h"
@interface WifiSignSureController ()<UITableViewDelegate,UITableViewDataSource,WIFIEditFoterDelegate>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
//@property (nonatomic,strong)NSMutableArray *classArr;

@end

@implementation WifiSignSureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    [self createView];
    [self loadData];
    self.title = @"开始签到";
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
}
-(void)loadData
{
    
    _modelArr = [NSMutableArray array];
    NSMutableArray *classArr = [NSMutableArray array];
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    
    [ProgressHUD show:@"正在加载..."];
    [NetworkCore requestPOST:url parameters:@{@"rid":@"confirmCourse",@"userid":teacherNum,@"role":[AppUserIndex GetInstance].role_type,@"searchtime":@""} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSArray *zrr = responseObject[@"data"];
        if (zrr.count==0) {
            [self showErrorViewLoadAgain:responseObject[@"msg"]];
            return ;
        }
        for (NSDictionary *dic in responseObject[@"data"]) {
            WIFICellModel *model = [[WIFICellModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [classArr addObject:model];
        }
        WIFICellModel *model = [WIFICellModel new];
        model.titleArr = classArr;
        [_modelArr addObject:model];
        
        WIFICellModel *countModel = [WIFICellModel new];
        countModel.subtitle  = responseObject[@"count"];
        countModel.title  = @"应到人数:";
        [_modelArr addObject:countModel];
        
        WIFICellModel *classNameModel = [WIFICellModel new];
        classNameModel.title = @"签到课程:";
        classNameModel.subtitle = responseObject[@"kcmc"];
        classNameModel.kch = responseObject[@"kch"];
        [_modelArr addObject:classNameModel];
        //创建
        [self createFooterView];
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];

}
-(void)createFooterView
{
    WIFIEditFooterView *footerView = [[WIFIEditFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-45*6+15)];
    footerView.delegate = self;
    footerView.isEdit = NO;
    self.mainTableView.tableFooterView = footerView;

}
#pragma mark 确定完信息  打开开始签到界面
-(void)openStartSignViewController
{
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    WIFICellModel *model = _modelArr[0];
    NSMutableArray *classArr = [NSMutableArray array];
    NSMutableArray *classNameArr = [NSMutableArray array];
    for (WIFICellModel *newmodel in model.titleArr) {
        [classArr addObject:newmodel.bjdm];
        [classNameArr addObject:newmodel.bjm];
    }
    NSString *class = [classArr componentsJoinedByString:@","];
    WIFICellModel *courseModel = _modelArr[2];
    [ProgressHUD show:@"正在验证..."];
    [NetworkCore requestPOST:url parameters:@{@"rid":@"startPoint",@"userid":teacherNum,@"role":[AppUserIndex GetInstance].role_type,@"class":class,@"courseid":courseModel.kch} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSString *result = responseObject[@"msg"];
        if ([result containsString:@"code=0x0000"]) {
            [JohnAlertManager showFailedAlert:@"发起签到成功" andTitle:@"提示"];
        }
        TechInitSignViewController *vc = [[TechInitSignViewController alloc]init];
        vc.courseID = courseModel.kch;
        vc.classArr = classArr;
        vc.classNameArr =classNameArr;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [JohnAlertManager showFailedAlert:@"发起签到成功" andTitle:@"提示"];
//        [JohnAlertManager showFailedAlert:@"请重试" andTitle:@"提示"];
        TechInitSignViewController *vc = [[TechInitSignViewController alloc]init];
        vc.courseID = courseModel.kch;
        vc.classArr = classArr;
        vc.classNameArr =classNameArr;
        [self.navigationController pushViewController:vc animated:YES];
    }];
 
}
#pragma mark footerDelegate
-(void)openEditViewController {

    WifiSignEditController   *vc = [WifiSignEditController new];
    vc.modelArr = _modelArr;
    vc.finishEditBlock = ^(NSArray *modelArr){
        //返回数组
        _modelArr = [NSMutableArray arrayWithArray:modelArr];
        [self.mainTableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark Delegate  z  Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellID = @"SignSureCell";
        WIFIClassSureCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[WIFIClassSureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model  = _modelArr[indexPath.row];
        return cell;
        
    }
    static NSString *cellID = @"SignEditPeopleNumCell";
    WIFISignInfoNormalCell *cell = [tableView cellForRowAtIndexPath:indexPath];;
    if (!cell) {
        cell = [[WIFISignInfoNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    WIFICellModel *model = _modelArr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.editBtn.hidden = YES;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        Class currentClass = [WIFIClassSureCell class];
        WIFICellModel *model = _modelArr[indexPath.row];
        return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    return 45;
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
