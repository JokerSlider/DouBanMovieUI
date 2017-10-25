//
//  StuSignInfoController.m
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "StuSignInfoController.h"
#import <YYModel.h>
#import "WIFICellModel.h"
#import "UIView+SDAutoLayout.h"
#import "WIFISIgnToolManager.h"
@interface StuSignInfoController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_beginSignBtn;
}
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)NSMutableArray *subTitleArr;

@end

@implementation StuSignInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到详情";
    [self createView];
    [self loadData];
    self.view.backgroundColor = Base_Color2;
}
-(void)loadData
{
    _modelArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];
    self.subTitleArr = [NSMutableArray array];
    [_titleArr addObjectsFromArray:@[@"签到课程:",@"课程时间",@"任课教师"]];
    
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    
    [NetworkCore requestPOST:url parameters:@{@"rid":@"getSignDetById",@"id":_aci_ID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            
            WIFICellModel *model = [WIFICellModel new];
            [model yy_modelSetWithDictionary:dic];
            [_subTitleArr addObjectsFromArray:@[model.kcmc, [[WIFISIgnToolManager shareInstance]tranlateDateString:model.aci_creattime withDateFormater:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ" andOutFormatter:@"yyyy-MM-dd HH:mm"]
,model.teacher]];
        }
        
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];

}
//-(NSString *)tranlateTime:(NSString *)time
//{
//    NSString* string = time;
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ"];
//    NSDate* inputDate = [inputFormatter dateFromString:string];
//    
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setLocale:[NSLocale currentLocale]];
//    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *str = [outputFormatter stringFromDate:inputDate];
//
//    return str;
//}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [self createFooterView];
    [self.view addSubview:self.mainTableView];
}
-(UIView *)createFooterView
{
    UIView *backView = [UIView new];
    _beginSignBtn = ({
        UIButton *view = [UIButton new];
        [view setTitle:@"点击签到" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:16];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setBackgroundColor:Base_Orange];
        [view addTarget:self action:@selector(beginSign:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [backView addSubview:_beginSignBtn];
    
    _beginSignBtn.sd_layout.leftSpaceToView(backView,14).rightSpaceToView(backView,14).heightIs(41).bottomSpaceToView(backView,20);
    backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-4*45-15);
    return backView;
}
#pragma mark  DataSource  
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subTitleArr.count;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@              %@",_titleArr[indexPath.row],_subTitleArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark 
-(void)beginSign:(UIButton *)sender
{
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    [ProgressHUD show:@"正在操作..."];
    [NetworkCore requestPOST:url parameters:@{@"rid":@"stuSignById",@"id":_aci_ID} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        if ([responseObject[@"data"] isEqualToString:@"1"]) {
            [_beginSignBtn setTitle:@"签到成功" forState:UIControlStateNormal];
            _beginSignBtn.enabled = NO;
            [_beginSignBtn setTitleColor:RGB(183, 183, 183) forState:UIControlStateNormal];
            _beginSignBtn.layer.borderColor = RGB(183, 183, 183).CGColor;
            [_beginSignBtn setBackgroundColor:[UIColor whiteColor]];
            _beginSignBtn.layer.borderWidth = 0.5;
            _beginSignBtn.layer.cornerRadius = 2;
            if (_signSucessBlock) {
                _signSucessBlock(@"签到成功");
            }
        }
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
