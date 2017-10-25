//
//  MyOAProcedureController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MyOAProcedureController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "MyProcedureViewController.h"
#import "MyApproveController.h"
#import "MyOAManagerController.h"
#import "BatchToSolveController.h"

@interface MyOAProcedureController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic,strong)MyProcedureViewController *myProcedureVC;//我发起的流程
@property (nonatomic,strong)MyApproveController      *myapproveVc;//我审批的
@property (nonatomic,strong)MyOAManagerController     *myoaManagerVC;//我管理的

//分段
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@end

@implementation MyOAProcedureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"我的掌上办公";
    [self loadsegMent];

}
//加载分段视图 并加载数据
-(void)loadsegMent
{
    //功能列表由上一页面传过来
    NSArray *titleArr = @[@"我发起的流程",@"我审批的流程",@"我管理的流程"];
    self.myProcedureVC = [[MyProcedureViewController alloc]init];
    self.myapproveVc = [[MyApproveController alloc]init];
    self.myoaManagerVC = [[MyOAManagerController alloc]init];
    NSArray *controllers=@[self.myProcedureVC,self.myapproveVc,self.myoaManagerVC];// 我发起的流程    我审批的流程     我管理的流程
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:titleArr withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height - 40) withArray:controllers withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
//    //根据传入的名字滑动到相关的标签页
//    __block MyOAProcedureController/*主控制器*/ *weakSelf = self;
//    
//    if (_sliderName) {
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            [weakSelf getIndexByName:_sliderName andTitleArr:titleArr];
//        });
//    }
  
    if (_sliderName) {
    [self getIndexByName:_sliderName andTitleArr:titleArr];
    }
}
-(void)getIndexByName:(NSString *)name andTitleArr:(NSArray *)arr
{
    NSInteger index =  [arr indexOfObject:name];
    dispatch_after(0, dispatch_get_main_queue(), ^{
        [self scrollChangeToIndex:index+1];
        [self selectedIndex:index];
    });


}
-(void)createNavBarBtn
{
    UIButton *allSelecBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(0, 0, 60, 40);
        view.titleLabel.font = [UIFont systemFontOfSize:13];
        [view setTitle:@"批量编辑" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(openOABatchALlVc:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:allSelecBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
}
#pragma mark 打开批量审批
-(void)openOABatchALlVc:(UIButton *)sender
{
    BatchToSolveController *vc = [[BatchToSolveController alloc]init];
    vc.fi_id = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    [self.flipView selectIndex:index];
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    [self.segment selectIndex:index];
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
