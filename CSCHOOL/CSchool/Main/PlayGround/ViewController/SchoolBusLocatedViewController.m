//
//  SchoolBusLocatedViewController.m
//  CSchool
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SchoolBusLocatedViewController.h"
#import "UIView+SDAutoLayout.h"
#import "SchoolBusInfoViewController.h"
#import "SchoolBusView.h"
#import "BusLoadListCell.h"
@interface SchoolBusLocatedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,copy)NSMutableArray *schooBusArr;
@property (nonatomic,copy)NSMutableArray *idArr;
@end

@implementation SchoolBusLocatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createView];
}

//加载数据
-(void)loadData
{
    _schooBusArr = [NSMutableArray array];
    _idArr   = [NSMutableArray array];
    [ProgressHUD show:@"正在加载路线信息..."];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAllBusLines",@"schoolCode":@"sdmu",@"searchText":@""} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSLog(@"%@",responseObject);
        for (NSDictionary *dic in responseObject[@"data"]) {
            SchooBusModel *model = [SchooBusModel new];
            [model yy_modelSetWithDictionary:dic];
            [_schooBusArr addObject:model];
            }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
//创建界面
-(void)createView
{
    self.title = @"班车列表";
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:_mainTableView];
    _mainTableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(kScreenHeight-64);
}


#pragma  mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _schooBusArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenfiter = @"BusCell";
    BusLoadListCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfiter ];
    if (!cell) {
        cell = [[BusLoadListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfiter];
    }
    
    cell.model = _schooBusArr[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark TableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SchooBusModel *model = _schooBusArr[indexPath.row];
    SchoolBusInfoViewController *vc = [[SchoolBusInfoViewController alloc]init];
    vc.model  = model;
    [self.navigationController pushViewController:vc animated:YES];
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
