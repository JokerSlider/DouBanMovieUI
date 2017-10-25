//
//  FlowerListViewController.m
//  CSchool
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FlowerListViewController.h"
#import "FlowerListCell.h"  
#import "PhotoCarView.h"
#import <MJRefresh.h>
#import <YYModel.h>
#import "AboutUsViewController.h"
#import "PhotoWallDetailViewController.h"
@interface FlowerListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,copy)NSMutableArray *modelArr;//
@end

@implementation FlowerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"鲜花榜";
    [self setupView];
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.mainTableView.mj_header beginRefreshing];
    
}

-(void)loadData
{
    /*
     @property (nonatomic,copy)NSString *name;//姓名
     @property (nonatomic,copy)NSString *address;//地址
     @property (nonatomic,copy)NSString *flowerNum;//鲜花数
     @property (nonatomic,copy)NSString *sex;//性别;
     @property (nonatomic,copy)NSString *photoImgaurl;//头像地址
     @property (nonatomic,copy)NSString *listNum;//排行  1 、  2 、3 、 4
     */
    _modelArr = [NSMutableArray array];
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getPhotowallRankList",@"page":@"1",@"pageCount":@"10"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            PhotoCarModel *model = [[PhotoCarModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }

        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}
-(void)setupView{
    self.mainTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate  = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  _modelArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static  NSString *ID =@"flowerCell";
    FlowerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[FlowerListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    PhotoCarModel *model  = _modelArr[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //点击某个cell跳转到对应的照片墙信息墙页面。
    PhotoWallDetailViewController *vc = [[PhotoWallDetailViewController alloc] init];
    PhotoCarModel *model = _modelArr[indexPath.section];
    NSLog(@"%@",model.picId);
    vc.model = _modelArr[indexPath.section];
    //    vc.carView = _container.currentCards[0];
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
