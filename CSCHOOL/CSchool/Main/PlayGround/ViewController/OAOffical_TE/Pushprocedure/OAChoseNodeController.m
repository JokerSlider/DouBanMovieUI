//
//  OAChoseNodeController.m
//  CSchool
//
//  Created by mac on 17/7/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAChoseNodeController.h"
#import "OAModel.h"
#import <YYModel.h>
#import "OANormalChoseController.h"
#import "MyOAProcedureController.h"
@interface OAChoseNodeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)UITableView *mainTableView;
@property (nonatomic,strong )NSMutableArray *modelArr;
@end

@implementation OAChoseNodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择节点";
    [self createView];
    [self loadData];
}
-(void)loadData
{
    self.modelArr = [NSMutableArray array];
    [ProgressHUD show:@"正在加载..."];
    //判断是通过还是退回
    if ([self.state isEqualToString:@"4"]) {
        //驳回
        NSString *url = [NSString stringWithFormat:@"%@/getAllFlowNodeByOid",OABase_URL];
        if (!_oi_id) {
            _oi_id  = @"";
        }
        [NetworkCore requestMD5POST:url parameters:@{@"in_oi_id":_oi_id,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_oi_id,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            for (NSDictionary *dic in responseObject) {
                OAModel *model = [OAModel new];
                [model yy_modelSetWithDictionary:dic];
                [self.modelArr addObject:model];
            }
            [self.mainTableView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD dismiss];
        }];
        
    }else {
    NSString *url = [NSString stringWithFormat:@"%@/getFlowNextNode",OABase_URL];
    if (!_oi_id) {
        _oi_id  = @"";
    }
    [NetworkCore requestMD5POST:url parameters:@{@"in_fi_id":_fi_id,@"in_oi_id":_oi_id,@"scode":[AppUserIndex GetInstance].schoolCode,@"flag":@"in_fi_id,in_oi_id,scode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        for (NSDictionary *dic in responseObject) {
            OAModel *model = [OAModel new];
            [model yy_modelSetWithDictionary:dic];
            [self.modelArr addObject:model];
        }
        [self.mainTableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];

    }];
    }
}
-(void)createView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.mainTableView = tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellID = @"OAChoseNodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = Color_Black  ;
    cell.accessoryType =[_state boolValue]?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
    OAModel *model = _modelArr[indexPath.row];
    cell.textLabel.text = model.ni_name;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (model.t_name) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = Color_Gray;
        cell.detailTextLabel.text =[NSString stringWithFormat:@"操作人:%@",model.t_name];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OAModel *model = _modelArr[indexPath.row];
    if ([_state isEqualToString:@"4"]) {

        UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要驳回该流程申请？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = [NSString stringWithFormat:@"%@/editBackUpNode",OABase_URL];
            if (!_oi_id) {
                _oi_id  = @"";
            }
            if (!model.ni_xh) {
                [JohnAlertManager showFailedAlert:@"工单有问题,请联系客服!" andTitle:@"提示!"];
                return ;
            }
            [NetworkCore requestMD5POST:url parameters:@{@"in_oi_id":_oi_id,@"scode":[AppUserIndex GetInstance].schoolCode,@"in_my_yhbh":OATeacherNum,@"in_node_id":model.ni_id,@"in_ho_de":_in_ho_de,@"in_ni_xh":model.ni_xh,@"flag":@"in_my_yhbh,scode,in_oi_id,in_node_id,in_ho_de,in_ni_xh"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                [JohnAlertManager showFailedAlert:@"驳回成功!" andTitle:@"提示"];
                //发送驳回处理单据的通知
                [[NSNotificationCenter defaultCenter]postNotificationName:@"OAHaveBeApprove" object:nil];

                [self popMyOAOffice];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:sureAction];
        [alert addAction:cancelAction];
        [self.navigationController presentViewController:alert animated:YES completion:^{
            
        }];
    }else{
        //跳转到选择部门负责人
        OANormalChoseController *vc = [[OANormalChoseController alloc]init];
        vc.in_node_id = model.ni_id;
        vc.state = _state;//
        vc.strs = _strs;
        vc.in_fi_id = _fi_id;
        vc.in_oi_id = _oi_id;
        vc.in_ho_de = _in_ho_de;//审批意见
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}
//驳回的时候跳转到我得办公首页
-(void)popMyOAOffice
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
