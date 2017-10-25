//
//  ZanPersonViewController.m
//  CSchool
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ZanPersonViewController.h"
#import "ZanPersonCell.h"
#import "SportsMainCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h" 
#import <YYModel.h>
@interface ZanPersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation ZanPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%d人赞了你",_zanPersonNum];
    [self createView];
    [self loadData];
}
#pragma mark 加载数据
-(void)loadData
{
    _modelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getPersonPraiseList",@"userid":[AppUserIndex GetInstance].role_id,@"time":self.currentTime} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            SportModel *model = [[SportModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArray addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
#pragma mark 创建视图
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource =self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
}
#pragma mark UITableViewDelegate && UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *zanCellId = @"zanCell";
    ZanPersonCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[ZanPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zanCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =_modelArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ZanPersonCell class];
    SportModel  *model =_modelArray[indexPath.row];
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
