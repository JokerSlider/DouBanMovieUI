//
//  OAProdureInfoController.m
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "OAProdureInfoController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "OAInfoViewController.h"
#import "OATimeLineController.h"
@interface OAProdureInfoController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic,retain)OAInfoViewController *oaInfoVC;
@property (nonatomic,retain)OATimeLineController *oaTimeLine;

//分段
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@end

@implementation OAProdureInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"流程详情";
    [self loadsegMent];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
//加载分段视图 并加载数据
-(void)loadsegMent
{
    self.oaInfoVC = [[OAInfoViewController alloc]init];
    self.oaInfoVC.isExamine = _isExamine;
    self.oaInfoVC.oi_id = _oi_id;
    self.oaInfoVC.fi_id = _fi_id;
    self.oaInfoVC.listState = _listState;
    self.oaTimeLine = [[OATimeLineController alloc]init];
    self.oaTimeLine.oi_id =_oi_id;
    NSArray *controllers=@[self.oaInfoVC,self.oaTimeLine];
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:@[@"详情",@"总流程"] withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height - 40) withArray:controllers withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
    

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
