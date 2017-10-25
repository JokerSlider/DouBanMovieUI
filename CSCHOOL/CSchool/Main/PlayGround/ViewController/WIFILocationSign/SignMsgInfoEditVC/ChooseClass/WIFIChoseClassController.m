//
//  WIFIChoseClassController.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WIFIChoseClassController.h"
#import "WIFICellModel.h"
#import <YYModel.h>
@interface WIFIChoseClassController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation WIFIChoseClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    self.title = @"请选择";
    [self loadData];
}
-(void)loadData
{
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    _modelArr = [NSMutableArray array];
    switch (_chooseType) {
        case CouresType:
        {
            [NetworkCore requestPOST:url parameters:@{@"rid":@"showCourseByClass",@"userid":teacherNum,@"role":[AppUserIndex GetInstance].role_type,@"classid":_classID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [ProgressHUD dismiss];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    WIFICellModel *model = [[WIFICellModel alloc]init];
                    [model yy_modelSetWithDictionary:dic];
                    [_modelArr addObject:model];
                }
                [self.mainTableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
            }];
        }
            break;
            case ClassType:
        {
            [NetworkCore requestPOST:url parameters:@{@"rid":@"showCourseByUserid",@"userid":teacherNum,@"role":[AppUserIndex GetInstance].role_type} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [ProgressHUD dismiss];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    WIFICellModel *model = [[WIFICellModel alloc]init];
                    [model yy_modelSetWithDictionary:dic];
                    [_modelArr addObject:model];
                }
                [self.mainTableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
            }];
        }
            break;
        default:
            break;
    }
    
    [ProgressHUD show:@"正在加载..."];
    
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource =self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
    
    switch (_chooseType) {
            case ClassType:
            
            break;
            case CouresType :
            
            break;
            
        default:
            break;
    }
}
#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"wifichooseClass";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = Color_Black;
    WIFICellModel *model = _modelArr[indexPath.row];
    switch (_chooseType) {
        case ClassType:
            cell.textLabel.text =[NSString stringWithFormat:@"%@(%@)",model.bjm,model.zymm];
            break;
            case CouresType:
            cell.textLabel.text = model.kcmc;

            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50   ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_chooseType) {
        case CouresType:
            if (_courseBlock) {
                WIFICellModel *model = _modelArr[indexPath.row];
                _courseBlock(model.kcmc,model.kch);
            }
            break;
            case ClassType:
            if (_classBlock) {
                WIFICellModel *model = _modelArr[indexPath.row];
                _classBlock(model);
            }
            break;
        default:
            break;
    }
  
    [self.navigationController popViewControllerAnimated:YES];
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
