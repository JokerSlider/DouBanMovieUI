//
//  TecSubSignInfoController.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TecSubSignInfoController.h"
#import <YYModel.h>
#import "WIFICellModel.h"
#import "UIView+SDAutoLayout.h"
#import "UIColor+HexColor.h"
#import "WIFISIgnToolManager.h"
@interface TecSubSignInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *subTitleArr;
@property (nonatomic,strong)NSMutableArray *titleArr;

@end

@implementation TecSubSignInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"补签详情";
    [self createView];
    [self loadData];
    self.view.backgroundColor = Base_Color2;
}
-(void)loadData
{
    self.titleArr = [NSMutableArray array];
    [ self.titleArr addObjectsFromArray:@[@"申请人:",@"申请班级:",@"签到课程:",@"课程时间:",@"申请理由:"]];
    self.subTitleArr = [NSMutableArray array];
    NSString* string = _infoModel.aci_creattime;
    NSString *str =  [[WIFISIgnToolManager shareInstance]tranlateDateString:string withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"];
    [self.subTitleArr addObjectsFromArray:@[_infoModel.xm,_infoModel.bjm,_infoModel.kcmc,str,_infoModel.aci_remark]];
    self.mainTableView.tableFooterView =  [self createFooterView];
    
    [self.mainTableView reloadData];

}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
}
-(UIView *)createFooterView
{
    UIView *backView = [UIView new];
    UIButton *sureBtn = ({
        UIButton *view = [UIButton new];
        [view setTitle:@"同意" forState:UIControlStateNormal];
        view.layer.cornerRadius = 2;
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(agreeSubSign:) forControlEvents:UIControlEventTouchUpInside];
        [view setBackgroundColor:Base_Orange];
        view;
    });
    
    UIButton *rejectBtn = ({
        UIButton *view = [UIButton new];
        [view setTitle:@"拒绝" forState:UIControlStateNormal];
        view.layer.cornerRadius = 2;
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(rejectSubSign:) forControlEvents:UIControlEventTouchUpInside];

        [view setBackgroundColor:[UIColor colorWithHexString:@"ff5c5b"]];
        view;
    });
    
    [backView sd_addSubviews:@[sureBtn,rejectBtn]];
    sureBtn.sd_layout.leftSpaceToView(backView,36).bottomSpaceToView(backView,64).heightIs(28).widthIs((kScreenWidth-36*2-58)/2);
    rejectBtn.sd_layout.rightSpaceToView(backView,36).bottomEqualToView(sureBtn).heightIs(28).widthIs((kScreenWidth-36*2-58)/2);
    
    
    backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight- self.titleArr.count*45-15);
    return backView;
}
#pragma mark  DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID  =  @"stuSignInfocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font =[UIFont systemFontOfSize:15];
    cell.textLabel.textColor = Color_Black ;
    cell.textLabel.text = [NSString stringWithFormat:@"%@              %@",self.titleArr[indexPath.row], self.subTitleArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
#pragma mark 点击方法   同意或者拒绝补签申请
-(void)agreeSubSign:(UIButton *)sender
{
    
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL

    [NetworkCore requestPOST:url parameters:@{@"rid":@"handleRetroactiveById",@"id":_infoModel.aci_id,@"state":@"1",@"content":@""} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [JohnAlertManager showFailedAlert:responseObject[@"msg"] andTitle:@"提示"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
-(void)rejectSubSign:(UIButton *)sender
{
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    
    [NetworkCore requestPOST:url parameters:@{@"rid":@"handleRetroactiveById",@"id":_infoModel.aci_id,@"state":@"0",@"content":@""} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [JohnAlertManager showFailedAlert:responseObject[@"msg"] andTitle:@"提示"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
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
