//
//  BusListViewController.m
//  CSchool
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BusListViewController.h"
#import "UIView+SDAutoLayout.h"
#import "BusListCell.h"
#import "SchoolBusView.h"
@interface BusListViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)NSMutableArray *dataSourceArr;//model数组
@property (nonatomic,strong)NSMutableArray *locationArr;//位置信息
@property (nonatomic,strong)UITableView *busListTableview;
@property (nonatomic,copy)NSString *gropID;//公交路线ID


@end

@implementation BusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)addStationArr:(NSArray *)array
{
    _dataSourceArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        SchooBusModel *model = [SchooBusModel new];
        [model yy_modelSetWithDictionary:dic];
        [_dataSourceArr addObject:model];
    }
    [self.busListTableview reloadData];
}
-(void)addBusLocationArr:(NSArray *)array
{
    _locationArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        SchooBusModel *model = [SchooBusModel new];
        [model yy_modelSetWithDictionary:dic];
        [_locationArr addObject:model];
    }
    [self.busListTableview reloadData];
}
//-(void)loadBusListData
//{
//    _dataSourceArr = [NSMutableArray array];
//    [ProgressHUD show:@"正在加载站点信息..."];
//    [NetworkCore requestPOST:API_HOST2 parameters:@{@"rid":@"getBusStateInfo",@"devicegroupId":_busRodID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        [ProgressHUD dismiss];
//        for (NSDictionary *dic in responseObject[@"data"]) {
//            SchooBusModel *model = [SchooBusModel new];
//            [model yy_modelSetWithDictionary:dic];
//            [_dataSourceArr addObject:model];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        [self stopTimer];
//    }];
//
//}
//-(void)loadBusLocation{
//    _locationArr = [NSMutableArray array];
//    [NetworkCore requestPOST:API_HOST2 parameters:@{@"rid":@"getBusLocation",@"deviceGroupId":_busRodID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        for (NSDictionary *dic in responseObject[@"data"]) {
//            SchooBusModel *model = [SchooBusModel new];
//            [model yy_modelSetWithDictionary:dic];
//            [_locationArr addObject:model];
//        }
//        
//        [self.busListTableview reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        
//    }];
//
//}
-(void)createView
{
    _busListTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _busListTableview.delegate = self;
    _busListTableview.dataSource = self;
    _busListTableview.tableFooterView = [UIView new];
    [self.view addSubview:_busListTableview];
    _busListTableview.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(kScreenHeight-40-64-65);
}
#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idefiter = @"busListCell";
    BusListCell *cell = [tableView dequeueReusableCellWithIdentifier:idefiter ];
    if (!cell) {
        cell = [[BusListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idefiter];
    }
    cell.model = _dataSourceArr[indexPath.row];
    for (NSObject *obj  in _locationArr) {
        NSUInteger index = [_locationArr indexOfObject:obj];
        if(index != NSNotFound)
        {
            cell.locationModel =_locationArr[index];
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma  mark tableViewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
