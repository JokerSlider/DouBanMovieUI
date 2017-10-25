//
//  BusForNewChoseController.m
//  CSchool
//
//  Created by mac on 17/8/30.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BusForNewChoseController.h"
#import "UIView+SDAutoLayout.h"
#import "BusChoseModel.h"
#import <YYModel.h>
#import "OALeftChoseCell.h"
@interface BusForNewChoseController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain)UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *editArr;
@property (strong, nonatomic) NSMutableArray *modelArr;

@property (assign, nonatomic) NSInteger editNum;
@property (nonatomic,strong)UIButton *allSelectedBtn;//全选
@property (nonatomic,strong)UIButton *batchBySelctBtn;//批量审批
@end

@implementation BusForNewChoseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    self.title = @"请选择";
}

-(void)loadData
{
    
    self.editArr =[NSMutableArray array];
    if (!_isMoreSelct) {
        //单选  全选按钮禁用
        self.allSelectedBtn.enabled = NO;
    }
    self.modelArr = [NSMutableArray array];
    for (NSDictionary *dic in self.objArr) {
        BusChoseModel *model = [BusChoseModel new];
        [model yy_modelSetWithDictionary:dic];
        [self.modelArr addObject:model];
    }
//    [self setDefaultSelected];
    [self.mainTableView reloadData];
}
#pragma mark  设置默认选中  尚未完成  
-(void)setDefaultSelected
{
    if (self.defaultArr.count == self.objArr.count) {
        self.allSelectedBtn.selected = YES;
    }
    [self.editArr removeAllObjects];
    for (NSDictionary *dic in self.defaultArr) {
        BusChoseModel *model = [BusChoseModel new];
        [model yy_modelSetWithDictionary:dic];
        for (BusChoseModel *cmodel in self.modelArr) {
            if ([model.ta_id isEqualToString:cmodel.ta_id]) {
                NSUInteger  index = [self.modelArr indexOfObject:cmodel ];
                NSLog(@"%lu",(unsigned long)index);
            }
        }
    }
//    for (int i = 0; i < self.defaultArr.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
//        NSArray *subviews = [[self.mainTableView cellForRowAtIndexPath:indexPath] subviews];
//        for (id subCell in subviews) {
//            if ([subCell isKindOfClass:[UIControl class]]) {
//                for (UIImageView *circleImage in [subCell subviews]) {
//                    circleImage.image = [UIImage imageNamed:@"CellButtonSelected"];
//                }
//            }
//        }
//        
//    }
//    [self.editArr addObjectsFromArray:self.objArr];
//    self.editNum = self.objArr.count;
//    [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"选择(%lu)",self.editNum] forState:UIControlStateNormal];

}
-(void)createView
{
    self.view.backgroundColor = Base_Color2;
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-60) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.editing = YES;
    self.mainTableView.backgroundColor = Base_Color2;
    
    [self.view addSubview:self.mainTableView];
    UIView *backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    self.allSelectedBtn = ({
        UIButton *view = [UIButton new];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setBackgroundImage:[UIImage imageNamed:@"AllSelectedBtn"] forState:UIControlStateNormal];
        [view setBackgroundImage:[UIImage imageNamed:@"AllSelectedBtn_selected"] forState:UIControlStateSelected];
        [view setTitle:@"全选" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(allSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setTitle:@"取消全选" forState:UIControlStateSelected];
        view;
    });
    self.batchBySelctBtn =({
        UIButton *view = [UIButton new];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view setBackgroundImage:[UIImage imageNamed:@"delete_btn"] forState:UIControlStateNormal];
        [view setTitle:@"选择(0)" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(batchData) forControlEvents:UIControlEventTouchUpInside];
        view;
        
    });
    
    [backView sd_addSubviews:@[self.allSelectedBtn,self.batchBySelctBtn]];
    [self.view addSubview:backView];
    
    backView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(60);
    self.allSelectedBtn.sd_layout.leftSpaceToView(backView,50).centerYIs(backView.centerY).heightIs(30).widthIs((kScreenWidth-100-20)/2);
    self.batchBySelctBtn.sd_layout.rightSpaceToView(backView,50).centerYIs(backView.centerY).heightIs(30).widthIs((kScreenWidth-100-20)/2);
}
-(void)batchData
{
    if (self.editArr.count==0) {
        [JohnAlertManager showFailedAlert:@"请至少选择一项" andTitle:@"提示"];
        return;
    }
    
    if (self.mainTableView.editing) {
        //将存着ID的数组传递给下一个界面
        //跳转到填写意见界面
        if (self.BusChooseListBlock) {
            self.BusChooseListBlock(_editArr);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}
#pragma mark 全选
-(void)allSelectedAction:(UIButton *)sender{
    if (!self.allSelectedBtn.selected) {
        self.allSelectedBtn.selected = YES;
        [self.editArr removeAllObjects];
        for (int i = 0; i < self.objArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            NSArray *subviews = [[self.mainTableView cellForRowAtIndexPath:indexPath] subviews];
            for (id subCell in subviews) {
                if ([subCell isKindOfClass:[UIControl class]]) {
                    for (UIImageView *circleImage in [subCell subviews]) {
                        circleImage.image = [UIImage imageNamed:@"CellButtonSelected"];
                    }
                }
            }
            
        }
        [self.editArr addObjectsFromArray:self.objArr];
        self.editNum = self.objArr.count;
        [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"选择(%lu)",self.editNum] forState:UIControlStateNormal];
    }else{
        self.allSelectedBtn.selected = NO;
        [self.editArr  removeAllObjects];
        
        for (int i = 0; i < self.objArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.mainTableView  deselectRowAtIndexPath:indexPath animated:YES];
            NSArray *subviews = [[self.mainTableView cellForRowAtIndexPath:indexPath] subviews];
            for (id subCell in subviews) {
                if ([subCell isKindOfClass:[UIControl class]]) {
                    for (UIImageView *circleImage in [subCell subviews]) {
                        circleImage.image = [UIImage imageNamed:@"CellButtonUnSelected"];
                    }
                }
            }
            
        }
        self.editNum    = 0;
        [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"选择(%lu)",self.editNum] forState:UIControlStateNormal];
    }
}
#pragma mark
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"OAChoseNorLeftCell";
    OALeftChoseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OALeftChoseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = Color_Black;
    BusChoseModel *model  = _modelArr[indexPath.row];
    cell.textLabel.text = model.ta_name;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - tableViewDelegate

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isMoreSelct) {
        if (self.editArr.count>0) {
            [JohnAlertManager showFailedAlert:@"最多选择一项!" andTitle:@"提示"];
            [self.mainTableView  deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    }
    NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
    for (id subCell in subviews) {
        if ([subCell isKindOfClass:[UIControl class]]) {
            
            for (UIImageView *circleImage in [subCell subviews]) {
                
                circleImage.image = [UIImage imageNamed:@"CellButtonSelected"];
                
            }
        }
        
    }
    
    [self.editArr addObject:[self.objArr objectAtIndex:indexPath.row]];
    self.editNum += 1;
    [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"选择(%lu)",self.editNum] forState:UIControlStateNormal];
    if (self.editArr.count==self.objArr.count) {
        NSLog(@"此处显示取消全选！！！");
        self.allSelectedBtn.selected = YES;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
    for (id subCell in subviews) {
        if ([subCell isKindOfClass:[UIControl class]]) {
            
            for (UIImageView *circleImage in [subCell subviews]) {
                
                circleImage.image = [UIImage imageNamed:@"CellButtonUnSelected"];
                
            }
        }
        
    }
    [self.editArr removeObject:[self.objArr objectAtIndex:indexPath.row]];
    self.editNum -= 1;
    [self.batchBySelctBtn setTitle:[NSString stringWithFormat:@"选择(%lu)",self.editNum] forState:UIControlStateNormal];
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
