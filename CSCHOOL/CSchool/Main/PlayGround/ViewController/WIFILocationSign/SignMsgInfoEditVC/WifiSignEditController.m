//
//  WifiSignEditController.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WifiSignEditController.h"
#import "WifiClassEditCell.h"
#import "WIFICellModel.h"
#import <YYModel.h>
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "WIFIChoseClassController.h"
#import "WIFISignInfoNormalCell.h"
#import "WIFIEditFooterView.h"
@interface WifiSignEditController ()<UITableViewDelegate,UITableViewDataSource,WIFIClassEditDelegate,WIFICourseEditDelegate,WIFIEditFoterDelegate>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,copy)NSString *stuCount;//学生人数
@end

@implementation WifiSignEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    [self createView];
//    [self loadData];
    self.title = @"编辑签到信息";
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    WIFIEditFooterView *footerView = [[WIFIEditFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-45*6)];
    footerView.isEdit = YES;
    footerView.delegate = self;
    self.mainTableView.tableFooterView = footerView;
    [self.view addSubview:self.mainTableView];
}
-(BOOL)navigationShouldPopOnBackButton
{
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"是否放弃编辑？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
    alert.tag = 1012;
    [alert show];
    return NO;
}
#pragma mark Delegate  z  Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellID = @"SignEditCell";
        WifiClassEditCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[WifiClassEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model  = _modelArr[indexPath.row];
        return cell;

    }
    static NSString *cellID = @"SignEditPeopleNumCell";
    WIFISignInfoNormalCell *cell = [tableView cellForRowAtIndexPath:indexPath];;
    if (!cell) {
        cell = [[WIFISignInfoNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    WIFICellModel *model = _modelArr[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==1) {
        cell.editBtn.hidden = YES;
    }
    return cell;

}

#pragma mark  选择课程代理
-(void)openChooseCourseVC
{
    NSLog(@"更换课程   调整frame");
    WIFIChoseClassController *vc = [WIFIChoseClassController new];
    WIFICellModel *model = _modelArr[2];
    WIFICellModel *classModel = _modelArr[0];

    vc.chooseType = CouresType;//类型是选择班级
    NSMutableArray *classIDArr = [NSMutableArray array];
    for (WIFICellModel *newmodel in classModel.titleArr) {
        [classIDArr addObject:newmodel.bjdm];
    }
    vc.classID = [classIDArr componentsJoinedByString:@","];
    
    vc.courseBlock = ^(NSString *text,NSString *ID){
        model.subtitle = text;
        model.kch = ID;
        [self.mainTableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark 代理 ++ 添加新班级  更换人数
-(void)addClassAction:(UIButton *)sender
{
    NSLog(@"添加新的班级   调整frame");
    WIFIChoseClassController *vc = [WIFIChoseClassController new];
    WIFICellModel *classmodel = _modelArr[0];
    vc.chooseType = ClassType;//类型是选择班级
    NSMutableArray *classIDArr = [NSMutableArray array];
    for (WIFICellModel *newmodel in classmodel.titleArr) {
        [classIDArr addObject:newmodel.bjdm];
    }
    WIFICellModel *numModel = _modelArr[1];
    WEAKSELF;
    NSMutableArray *nameSourceArr = [NSMutableArray arrayWithArray:classmodel.titleArr];
    vc.classBlock = ^(WIFICellModel *model){
        [nameSourceArr addObject:model];
        classmodel.titleArr = nameSourceArr;
        int num = [numModel.subtitle intValue];
        num = num + [model.count intValue];
        numModel.subtitle = [NSString stringWithFormat:@"%d",num];
        [weakSelf.mainTableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark  代理 ++ 删除
-(void)deletAction:(UIButton *)sender
{
    WIFICellModel *model = _modelArr[0];
    NSMutableArray *nameSourceArr = [NSMutableArray arrayWithArray:model.titleArr];
    WIFICellModel *classModel = model.titleArr[sender.tag];
    //修改学生总数+++++++++++++
    WIFICellModel *numModel = _modelArr[1];
    int num = [numModel.subtitle intValue];
    num = num - [classModel.count intValue];
    numModel.subtitle = [NSString stringWithFormat:@"%d",num];
    //----------
    [nameSourceArr removeObjectAtIndex:sender.tag];
    [sender.superview removeFromSuperview];
    model.titleArr = nameSourceArr;
    [self.mainTableView reloadData];
}
#pragma mark 返回上个界面
-(void)openSureViewController
{
    if (_finishEditBlock) {
        
        WIFICellModel *model = _modelArr[1];
        NSLog(@"%@",model.count);
        _finishEditBlock(_modelArr);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        Class currentClass = [WifiClassEditCell class];
        WIFICellModel *model = _modelArr[indexPath.row];
        return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    }
    return 45;
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
#pragma mark 
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    
 if (view.tag == 1012){
        [self.navigationController popViewControllerAnimated:YES];
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
