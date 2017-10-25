//
//  OAInfoViewController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAInfoViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "OAInfoCell.h"
#import "OAModel.h"
#import <YYModel.h>
#import "UIView+SDAutoLayout.h"
#import "OASuggestionController.h"
#import "UIColor+HexColor.h"
#import "PushprocedureController.h"
@interface OAInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *mainTableview;
@property (nonatomic,strong)NSMutableArray *modelArr;
@end

@implementation OAInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self loadData];
}
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    _modelArr = [NSMutableArray new];
    NSString *url = [NSString stringWithFormat:@"%@/getFlowFormInfoByFidAndOid",OABase_URL];
    [NetworkCore requestMD5POST:url parameters:@{@"in_oi_id":_oi_id,@"in_fi_id":_fi_id,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_oi_id,in_fi_id,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        for (NSDictionary *dic in responseObject) {
            OAModel *model =[OAModel new];
            [model yy_modelSetWithDictionary:dic];
            [_modelArr addObject:model];
        }
        
        [self.mainTableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
}
-(void)createView
{
    
    if (_isExamine) {
        self.mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40-40) style:UITableViewStylePlain];
        self.mainTableview.delegate = self;
        self.mainTableview.dataSource = self;
        [self.mainTableview  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.mainTableview];
        if (_listState) {
            UIButton *procedureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            procedureBtn.backgroundColor = RGB(237, 120, 14);
            procedureBtn.frame = CGRectMake(0, kScreenHeight-64-40-40, kScreenWidth, 40);
            [procedureBtn setTitle:@"前往审批" forState:UIControlStateNormal];
            [procedureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            procedureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [procedureBtn addTarget:self action:@selector(OpenProceduceVC:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:procedureBtn];
        }
       
        
//        UIView *lineV = [UIView new];
//        lineV.frame =CGRectMake((kScreenWidth-0.5)/2, kScreenHeight-64-40-40, 0.5, 0.5 );
//        [self.view addSubview:lineV];
//        UIButton *EditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        EditBtn.backgroundColor = [UIColor colorWithHexString:@"ff5c5b"];
//        EditBtn.frame = CGRectMake((kScreenWidth-0.5)/2+0.5, kScreenHeight-64-40-40, (kScreenWidth-0.5)/2, 40);
//        [EditBtn setTitle:@"修改" forState:UIControlStateNormal];
//        [EditBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        EditBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [EditBtn addTarget:self action:@selector(OpenEditVC:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:EditBtn];
    }else{
        self.mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40) style:UITableViewStylePlain];
        self.mainTableview.delegate = self;
        self.mainTableview.dataSource = self;
        [self.mainTableview  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:self.mainTableview];

    }
    
}
#pragma mark  
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"OAInfoCell";
    OAInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OAInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _modelArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [OAInfoCell class];
    OAModel *model = _modelArr[indexPath.row];
    
    return [self.mainTableview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
#pragma mark 打开审批
-(void)OpenProceduceVC:(UIButton *)sender
{
    if (!_listState) {
        [JohnAlertManager showFailedAlert:@"该流程已经审批,请勿重复审批!" andTitle:@"提示"];
        return;
    }
    OASuggestionController  *suggesVC  = [[OASuggestionController alloc]init];
    suggesVC.oi_id = _oi_id;
    suggesVC.fi_id = _fi_id;
    [self.navigationController pushViewController:suggesVC animated:YES];
}
#pragma mark 打开编辑界面
-(void)OpenEditVC:(UIButton *)sender
{
    [JohnAlertManager showFailedAlert:@"功能尚在开发" andTitle:@"提示!"];
    return;
    //点击某个cell跳转到对应的照片墙信息墙页面。
    PushprocedureController *vc = [PushprocedureController new];
//    vc.flowtype = @"yongyin";
    vc.isEdit = YES;
    vc.listMArr = @[
                    
                   ];
    vc.oaEditBlock = ^(NSArray *modelArr){
        _modelArr =[NSMutableArray arrayWithArray:modelArr];
        [self.mainTableview reloadData];
        
    };
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
