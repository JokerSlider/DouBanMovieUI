
//
//  MyPublishViewController.m
//  CSchool
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyPublishViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "MyPublishOutViewController.h"
#import "MyPusblisINViewController.h"
@interface MyPublishViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
{
    MyPublishOutViewController *vc1;
    MyPusblisINViewController *vc2;
}
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@end

@implementation MyPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的发布";
    [self createView];
}
-(void)createView
{
   vc1 = [[MyPublishOutViewController alloc]init];
   vc2 = [[MyPusblisINViewController alloc]init];
   
    vc1.funcType = _funcType;
    vc2.funcType = _funcType;
    [vc1 loadData];
    NSArray *controllers=@[vc1,vc2];
    self.view.backgroundColor = [UIColor whiteColor];
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:_titleArray withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height - 40) withArray:controllers withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    if (index==0) {
//        [vc1 loadDMyPushata];
    }else{
        [vc2 loadMyReveData];
    }
    
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {
//        [vc1 loadDMyPushata];
    }else{
        [vc2 loadMyReveData];
    }
    [self.segment selectIndex:index];
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
