//
//  RepairDetailViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/8.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "RepairDetailViewController.h"
#import "BaseConfig.h"
#import "XGAlertView.h"
#import "ConfigObject.h"
#import "CallRepairViewController.h"
#import <YYModel.h>
#import "UIButton+BackgroundColor.h"

@interface RepairDetailViewController ()<UITableViewDelegate, UITableViewDataSource, XGAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *failtArr;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSString *lastReminTime;
@end

@implementation RepairDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的报修";
    _lastReminTime = _model.lastRemindTime;
    [self createViews];
    [self loadData];
}

- (void)loadData{
    //@property (nonatomic, copy) NSString *deviceTypeKey; //设备类型key -->NRIFACILITYTYPE
    //@property (nonatomic, copy) NSString *netStyleKey; //上网方式key -->NRIINTERNETCASE
    //@property (nonatomic, copy) NSString *faultAddress; //地址 -->ADDRESS
    //@property (nonatomic, copy) NSString *aroundFriendKey; //周围朋友上网key -->NRIOFACCESS
    //@property (nonatomic, copy) NSString *faultDes; //故障描述 -->NRIFAULTDESCRIPTION
    //@property (nonatomic, strong) NSString *username; //报修姓名 -->OIRINAME
    //@property (nonatomic, strong) NSString *repairPhone; //报修电话 -->OIRIPHONE

    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getRepairInfoById",@"repairId":_model.keyId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataDic = responseObject[@"data"];
        _titleArr = @[@[@"报修单号",@"目前状态",@"报修时间"],@[@"故障现象",@"终端类型",@"接入方式",@"故障地点",@"周围朋友的上网情况",@"故障描述"],@[@"报修人姓名",@"报修人电话"]];
        [_model yy_modelSetWithDictionary:_dataDic];
        _failtArr = @[@[_model.faultId,_model.faultState,_model.createTime],@[_model.questionType,_model.osType,_model.netFunction,_model.faultAddress,_model.netspeed,_model.faultDes],@[_model.username,_model.repairPhone]];

        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

//创建按钮视图
- (void)createViews{
    [_bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *btnArrays;
    if ([_model.faultState integerValue]<4) {
        btnArrays = @[@"编辑", @"撤销", @"催单"];
    }else if ([_model.faultState integerValue] == 4){
        btnArrays = @[@"评分"];
    }else{
        btnArrays = @[];
    }
    NSDictionary *dic = @{
                          @"评分":@"990",
                          @"编辑":@"991",
                          @"撤销":@"992",
                          @"催单":@"993"
                          };
    CGFloat width = (kScreenWidth-2)/btnArrays.count;
    
    for (int i=0; i<btnArrays.count; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        markBtn.frame = CGRectMake(width*i+i+1, 0.5, width, 40);
        [markBtn setTitle:btnArrays[i] forState:UIControlStateNormal];
        [markBtn setTitleColor:Title_Color1 forState:UIControlStateNormal];
        markBtn.titleLabel.font = Title_Font;
        [markBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        [markBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        [markBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];

        markBtn.tag = [[dic objectForKey:btnArrays[i]] integerValue];
        [_bottomView addSubview:markBtn];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _titleArr[section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleStr = _titleArr[indexPath.section][indexPath.row];
    cell.textLabel.font = Title_Font;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:     %@",titleStr,_failtArr[indexPath.section][indexPath.row]];
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@:     %@",titleStr,[FAULT_STATE_DIC objectForKey:_failtArr[indexPath.section][indexPath.row]]];
    }
    cell.textLabel.numberOfLines = 0;
    if (indexPath.section != 0) {
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if (indexPath.row == 5) {
            cell.textLabel.text = @"";

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth, 30)];
            titleLabel.textColor =  [UIColor darkGrayColor];
            titleLabel.font = Title_Font;
            titleLabel.text = _titleArr[indexPath.section][indexPath.row];
            [cell.contentView addSubview:titleLabel];
            
            NSString *str= _failtArr[indexPath.section][indexPath.row];
            CGFloat height = [BaseConfig heightForString:str width:kScreenWidth-24 withFont:Title_Font];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 26, kScreenWidth-24, height)];
            contentLabel.font = Title_Font;
            contentLabel.textColor = [UIColor darkGrayColor];
            contentLabel.text = str;
            contentLabel.numberOfLines = 0;
            [cell.contentView addSubview:contentLabel];
        }else if (indexPath.section == 1 &&indexPath.row == 3){
            cell.textLabel.text = titleStr;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, kScreenWidth-120, 33)];
            titleLabel.textColor =  [UIColor darkGrayColor];
            titleLabel.font = Title_Font;
            titleLabel.text = _failtArr[indexPath.section][indexPath.row];
            titleLabel.numberOfLines = 0;
            [cell.contentView addSubview:titleLabel];
        }
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5 && indexPath.section == 1) {
        NSString *str= _failtArr[indexPath.section][indexPath.row];
        CGFloat height = [BaseConfig heightForString:str width:kScreenWidth-24 withFont:Title_Font];
        return height+30;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return .1;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 30)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = Title_Font;
    titleLabel.textColor = [UIColor blackColor];
    [headerView addSubview:titleLabel];
    if (section == 1) {
        titleLabel.text = @"报修信息";
    }else if(section==2){
        titleLabel.text = @"报修人信息";
    }
    return headerView;
}

- (void)bottomBtnAction:(UIButton *)sender{
//    @"评分":@"990",
//    @"编辑":@"991",
//    @"撤销":@"992",
//    @"催单":@"993"
    switch (sender.tag) {
        case 990:
        {
            [self markBtnAction];
        }
            break;
        case 991:
        {
            [self editeBtnAction];
        }
            break;
        case 992:
        {
            [self deleteBtnAction];
        }
            break;
        case 993:
        {
            [self reminderRepairAction];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)editeBtnAction{
    CallRepairViewController *vc = [[CallRepairViewController alloc] init];
    vc.repairModel = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

//撤销
- (void)deleteBtnAction{
//    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withDropListTitle:[ConfigObject shareConfig].repairCancelResonArr];
//    [alert show];
    WEAKSELF;
//    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"撤销" withRemarkTitle:@[] withContentTitle:@"撤销原因" click:^(NSArray *markArr, NSString *moreText) {
//        [weakSelf deleteAction:moreText];
//    }];
    NSArray *titleArray = @[@"自动恢复",@"其他原因"];
    XGAlertView *alert = [[XGAlertView alloc] initSingleSelectWithTitle:@"撤销原因" withArray:titleArray click:^(NSInteger index) {
        NSLog(@"%ld",index);
        [weakSelf deleteAction:titleArray[index]];
    }];
    
    [alert show];
}

- (void)markBtnAction{
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withRemarkTitle:@[@"服务速度",@"服务态度",@"服务效果", @"业务能力"]];
    [alert show];
}

//撤销
- (void)deleteAction:(NSString *)deleteInfo{
    
    
    NSDictionary *commitDic = @{
                                @"rid":@"cancelRepairById",
                                @"repairId":_model.keyId,
                                @"repealing":deleteInfo
                                };
    [ProgressHUD show:@""];
    
    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:[responseObject objectForKey:@"msg"] Interaction:YES];
        [weakSelf.model yy_modelSetWithDictionary:responseObject[@"data"][0]];
        _failtArr = @[@[_model.faultId,_model.faultState,_model.createTime],@[_model.questionType,_model.osType,_model.netFunction,_model.faultAddress,_model.netspeed,_model.faultDes],@[_model.username,_model.repairPhone]];
        [self createViews];
        [weakSelf.mainTableView reloadData];
//        weakSelf.model.faultState = @"0x00004";
//        [_mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
}

//评价
- (void)alertView:(XGAlertView *)view didClickRemarkView:(NSArray *)markArr{
    NSLog(@"%@",markArr);
    NSDictionary *commitDic = @{
                          @"rid":@"evaluateRepair",
                          @"repairId":_model.keyId,
                          @"serviceSpeed":[NSString stringWithFormat:@"%f",[markArr[0] doubleValue]*5],
                          @"serviceAttitude":[NSString stringWithFormat:@"%f",[markArr[1] doubleValue]*5],
                          @"serviceEffect":[NSString stringWithFormat:@"%f",[markArr[2] doubleValue]*5],
                          @"operationalCapacity":[NSString stringWithFormat:@"%f",[markArr[3] doubleValue]*5]
                          };
    [ProgressHUD show:@""];

    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:[responseObject objectForKey:@"msg"] Interaction:YES];
        [weakSelf.model yy_modelSetWithDictionary:responseObject[@"data"][0]];
        _failtArr = @[@[_model.faultId,_model.faultState,_model.createTime],@[_model.questionType,_model.osType,_model.netFunction,_model.faultAddress,_model.netspeed,_model.faultDes],@[_model.username,_model.repairPhone]];
        [self createViews];
        [weakSelf.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
}

//催单
- (void)reminderRepairAction{
    [ProgressHUD show:nil];
    NSDictionary *commitDic = @{
                                @"rid":@"reminderRepair",
                                @"repairId":_model.keyId,
                                @"remindertime":_model.lastRemindTime
                                };
    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:[responseObject objectForKey:@"msg"] Interaction:YES];
        [weakSelf.model yy_modelSetWithDictionary:responseObject[@"data"][0]];
        _failtArr = @[@[_model.faultId,_model.faultState,_model.createTime],@[_model.questionType,_model.osType,_model.netFunction,_model.faultAddress,_model.netspeed,_model.faultDes],@[_model.username,_model.repairPhone]];
        [self createViews];
        [weakSelf.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
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
