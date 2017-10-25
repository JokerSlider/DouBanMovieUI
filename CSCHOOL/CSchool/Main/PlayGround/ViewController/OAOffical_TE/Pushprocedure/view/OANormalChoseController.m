//
//  OANormalChoseController.m
//  CSchool
//
//  Created by mac on 17/7/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OANormalChoseController.h"
#import <YYModel.h>
#import "OAModel.h"
#import "UIView+SDAutoLayout.h"
#import "OALeftChoseCell.h"
#import "UIColor+HexColor.h"
#import "UIButton+BackgroundColor.h"
#import "MyOAProcedureController.h"
@interface OANormalChoseController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView *rightTaleView;

@property (nonatomic, strong) NSMutableArray *rightDataArray;

@property (nonatomic, strong) NSMutableArray *leftDataArray;

@property (nonatomic, strong) NSIndexPath *currentSelectIndexPath;

//@property (strong, nonatomic) NSMutableArray *editArr;

@property (strong,nonatomic)   NSMutableArray *editIDArr ;
@property (strong,nonatomic)  NSMutableArray *editNameArr ;

@property (assign, nonatomic) NSInteger editNum;

@property (assign,nonatomic) NSInteger  leftEditnum;//左边的数字

@property (nonatomic,weak)UIButton *finishBtn;//选中btn


@end

@implementation OANormalChoseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请选择要转交的人员";
    [self.view setBackgroundColor:Base_Color2];
    [self crateView];
    [self loadData];
    [self createBottomView];
}
-(void)crateView{
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.6, kScreenHeight-64-45)];
    leftTableView.tableFooterView = [UIView new];
    leftTableView.backgroundColor = Base_Color2;
    [self.view addSubview:leftTableView];
    self.leftTableView = leftTableView;
    
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth*0.6, 0, kScreenWidth*0.4, kScreenHeight-64-45)];
    rightTableView.tableFooterView = [UIView new];
    rightTableView.editing = YES;
    rightTableView.allowsMultipleSelection = YES;
    [self.view addSubview:rightTableView];
    self.rightTaleView = rightTableView;
    
    rightTableView.delegate = leftTableView.delegate = self;
    rightTableView.dataSource = leftTableView.dataSource = self;
}
- (void)viewDidLayoutSubviews {
    
    if ([self.rightTaleView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        self.rightTaleView.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self.rightTaleView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        self.rightTaleView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==_rightTaleView) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }

    }
}
//创建右侧视图
-(void)createBottomView
{
    UIButton *finshBtn = [UIButton new];
    [finshBtn setTitle:@"选择转交人(0)" forState:UIControlStateNormal];
    [finshBtn addTarget:self action:@selector(uploadData) forControlEvents:UIControlEventTouchUpInside];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [finshBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [finshBtn setBackgroundColor:Base_Orange forState:UIControlStateSelected];
    [self.view addSubview:finshBtn];
    self.finishBtn = finshBtn;
    self.finishBtn.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(45).bottomSpaceToView(self.view,0);
}
-(void)loadData
{
    self.editIDArr = [NSMutableArray array];
    self.editNameArr = [NSMutableArray array];
    self.leftDataArray = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@/getUserTypeByNode",OABase_URL];
    [NetworkCore requestMD5POST:url  parameters:@{@"in_node_id":_in_node_id,@"in_oi_id":@"",@"yq_username":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_node_id,in_oi_id,yq_username,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary *dic in responseObject) {
            OAModel *model = [OAModel new];
            model.badgeValue = nil;
            [model yy_modelSetWithDictionary:dic];
            [self.leftDataArray addObject:model];
        }
        [self.leftTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _currentSelectIndexPath = indexPath;
        [self.leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionTop)];
        OALeftChoseCell *cell = [self.leftTableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = Base_Orange;
        if (_leftDataArray.count<=0) {
            return;
        }
        OAModel *model = [self.leftDataArray firstObject];
        [self loadRihtData:model];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
//获取右侧tableview数据
-(void)loadRihtData:(OAModel *)model
{
    self.rightDataArray = [NSMutableArray array];
    NSString *url = [NSString stringWithFormat:@"%@/getUserByUserType",OABase_URL];
    [NetworkCore requestMD5POST:url  parameters:@{@"in_yhbh":model.yhbh,@"scode":model.sds_code,@"in_state":model.state,@"in_oi_id":@"",@"yq_username":@"",@"in_node_id":@"6440",@"flag":@"in_yhbh,scode,in_state,in_oi_id,yq_username,in_node_id"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary *dic in responseObject) {
            OAModel *model = [OAModel new];
            model.selectState = NO;
            [model yy_modelSetWithDictionary:dic];
            [self.rightDataArray addObject:model];
        }
        [self.rightTaleView reloadData];
        [self isContaintObj];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
#pragma mark 上传数据
-(void)uploadData
{
    [ProgressHUD show:@"正在上传..."];
    if (self.editIDArr.count==0) {
        
        [JohnAlertManager showFailedAlert:@"请选择审批人" andTitle:@"提示"];
        [ProgressHUD dismiss];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/saveFlowForm",OABase_URL];
    NSString *yhbh = [self.editIDArr componentsJoinedByString:@","];
    [NetworkCore requestMD5POST:url parameters:@{@"in_my_yhbh":OATeacherNum,@"scode":[AppUserIndex GetInstance].schoolCode,@"in_oi_id":_in_oi_id,@"in_fi_id":_in_fi_id,@"in_close_node":@"",@"in_oi_state":@"1",@"strs":_strs,@"in_node_id":_in_node_id,@"in_yhbh":yhbh,@"in_sds_code":[AppUserIndex GetInstance].schoolCode,@"in_ho_state":_state,@"in_ho_de":_in_ho_de,@"flag":@"in_my_yhbh,scode,in_oi_id,in_fi_id,in_close_node,in_oi_state,strs,in_node_id,in_yhbh,in_sds_code,in_ho_state,in_ho_de"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [ProgressHUD dismiss];
        [JohnAlertManager showFailedAlert:@"提交成功!" andTitle:@"提示"];
        //处理成功发送一个通知   刷新首页
        [[NSNotificationCenter defaultCenter]postNotificationName:@"OAHaveBeApprove" object:nil];
        [self popToMainViewController];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        NSLog(@"%@",error);
        [ProgressHUD dismiss];
        [JohnAlertManager showFailedAlert:@"上传失败,请重新上传！" andTitle:@"提示"];
    }];
}
-(void)popToMainViewController
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *temArray = self.navigationController.viewControllers;
            for(UIViewController *temVC in temArray)
            {
                if ([temVC isKindOfClass:[MyOAProcedureController class]])
                {
                    [self.navigationController popToViewController:temVC animated:YES];
                }
            }
        });
    });
}
#pragma mark 判断选中状态
-(void)isContaintObj
{
     for (int i = 0; i < self.rightDataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        OAModel *model = self.rightDataArray[i];
        
        if ([self.editIDArr containsObject:model.zgh]) {
            [self.rightTaleView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        }else{
            
        }
    }

    
}
#pragma mark delegae
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return self.leftDataArray.count;
    }
    return self.rightDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"OAChoseNorLeftCell";
    OALeftChoseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[OALeftChoseCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    

    if (tableView == _leftTableView) {
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = Base_Color2;
        cell.textLabel.textColor = Color_Black;
        UILabel *badgeL = [UILabel new];
        badgeL.font= [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(9.0)];
        badgeL.textColor = [UIColor whiteColor];
        badgeL.layer.cornerRadius  = 10*0.5;
        badgeL.clipsToBounds = YES;
        badgeL.backgroundColor = [UIColor redColor];
        badgeL.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:badgeL];
        badgeL.sd_layout.rightSpaceToView(cell.contentView,10).topSpaceToView(cell.contentView,5).widthIs(16).heightIs(10);
    
        OAModel *model = _leftDataArray[indexPath.row];
        cell.textLabel.text = model.out_name;
        badgeL.text = model.badgeValue;
        if ([model.badgeValue integerValue]==0||model.badgeValue.length==0) {
            badgeL.hidden = YES;
        }else if ([model.badgeValue intValue]>99) {
            badgeL.sd_layout.widthIs(20).heightIs(10);
            badgeL.text = @"99+";
        }else if ([model.badgeValue integerValue]<10){
            badgeL.sd_layout.widthIs(13).heightIs(13);
            badgeL.layer.cornerRadius = badgeL.bounds.size.height*0.5;
        }
        return cell;
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = Color_Black;
        OAModel *model = _rightDataArray[indexPath.row];
        cell.textLabel.text = model.xm;
        cell.lineView.hidden = YES;
        return cell;
    }
    return nil;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _rightTaleView) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _rightTaleView) {
        OAModel *model = [self.rightDataArray objectAtIndex:indexPath.row];
        model.selectState = YES;
        [self.editIDArr addObject:model.zgh];
        [self.editNameArr addObject:model.xm];
        self.editNum += 1;//选择的总数
        self.finishBtn.selected = YES;
        [self.finishBtn setTitle:[NSString stringWithFormat:@"选好了,提交(%ld)",(long)self.editNum] forState:UIControlStateNormal];
        
        //修改左侧tableview的角标
        
        OAModel *leftmodel = self.leftDataArray[_currentSelectIndexPath.row];
        if (!leftmodel.badgeValue||[leftmodel.badgeValue isEqualToString:@"0"]) {
            self.leftEditnum = 1;
            leftmodel.badgeValue = [NSString stringWithFormat:@"%ld",(long)self.leftEditnum];
        }else{
            int index  = [leftmodel.badgeValue intValue];
            index += 1;
            leftmodel.badgeValue = [NSString stringWithFormat:@"%d",index];
        }
        [self.leftTableView reloadData];
        [self.leftTableView selectRowAtIndexPath:_currentSelectIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        OALeftChoseCell *cell = [self.leftTableView cellForRowAtIndexPath:_currentSelectIndexPath];
        cell.textLabel.textColor = Base_Orange;
    }else{
        OAModel *model = self.leftDataArray[indexPath.row];
        [self loadRihtData:model];
        OALeftChoseCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = Base_Orange;
        cell.backgroundColor = [UIColor whiteColor];
        _currentSelectIndexPath = indexPath;
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _rightTaleView) {
        OAModel *model = [self.rightDataArray objectAtIndex:indexPath.row];
        model.selectState = NO;
        [self.editIDArr removeObject:model.zgh];
        [self.editNameArr removeObject:model.xm];
        self.editNum -= 1;
        [self.finishBtn setTitle:[NSString stringWithFormat:@"选好了,提交(%ld)",(long)self.editNum] forState:UIControlStateNormal];
        if (self.editNum>0) {
            self.finishBtn.selected = YES;
        }else{
            self.finishBtn.selected = NO;
            [self.finishBtn setTitle:[NSString stringWithFormat:@"选择(%ld)",(long)self.editNum] forState:UIControlStateNormal];
        }

        //修改左侧tableview的角标
        OAModel *leftmodel = self.leftDataArray[_currentSelectIndexPath.row];
        int index  = [leftmodel.badgeValue intValue];
        index -= 1;
        leftmodel.badgeValue = [NSString stringWithFormat:@"%d",index];
        [self.leftTableView reloadData];
        [self.leftTableView selectRowAtIndexPath:_currentSelectIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        OALeftChoseCell *cell = [self.leftTableView cellForRowAtIndexPath:_currentSelectIndexPath];
        cell.textLabel.textColor = Base_Orange;
        cell.backgroundColor = Base_Color2;
    }else{//左边的  这时候选中的
        OALeftChoseCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = Color_Black;
        cell.backgroundColor = Base_Color2;
    }
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
