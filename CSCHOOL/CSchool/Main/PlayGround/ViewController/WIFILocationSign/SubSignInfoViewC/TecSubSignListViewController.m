//
//  TecSubSignListViewController.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecSubSignListViewController.h"
#import <YYModel.h>
#import "WIFICellModel.h"
#import "TecSubSignInfoController.h"
#import "WIFISIgnToolManager.h"
@interface TecSubSignListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation TecSubSignListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补签申请列表";
    [self createView];
    [self loadData];
    self.view.backgroundColor = Base_Color2;
}
-(void)loadData
{
    _modelArr = [NSMutableArray array];
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    
    [NetworkCore requestPOST:url parameters:@{@"rid":@"showRetroactiveListById",@"id":_signID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            
            WIFICellModel *model = [WIFICellModel new];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
    
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
}

#pragma mark  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID  =  @"stuSignInfocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    cell.textLabel.textColor = Color_Black ;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = Color_Black ;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    WIFICellModel *model = _modelArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@申请补签",model.bjm,model.xm];
    NSString* string = model.aci_creattime;
    NSString *str =  [[WIFISIgnToolManager shareInstance]tranlateDateString:string withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];
    cell.detailTextLabel.text = str;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TecSubSignInfoController   *vc = [TecSubSignInfoController new];
    vc.infoModel = _modelArr[indexPath.row];
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
