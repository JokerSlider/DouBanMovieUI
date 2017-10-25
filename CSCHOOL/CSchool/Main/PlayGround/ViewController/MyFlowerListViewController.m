//
//  MyFlowerListViewController.m
//  CSchool
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyFlowerListViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "MyFlloweFlowerDataVC.h"
#import "MyFlowerPushDataVC.h"
#import "PhotoWallSendViewController.h"

@interface MyFlowerListViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;

@property (nonatomic, strong)MyFlowerPushDataVC *myPushVc;//我得主页

@property (nonatomic, strong)MyFlloweFlowerDataVC *myFllowVc;//我得足迹
@end

@implementation MyFlowerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isMemberOfClass:[PhotoWallSendViewController class]]) {
            [arr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = arr;
    
    self.title = @"个人主页";
    [self createView];

    }
-(void)createView
{
    _myPushVc = [[MyFlowerPushDataVC alloc]init];
    _myFllowVc = [[MyFlloweFlowerDataVC alloc]init];
    //初始化时加载第一页的数据
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 50) withDataArray:@[@"我的发布",@"我的足迹"] withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, self.view.frame.size.height - 50) withArray:@[_myPushVc,_myFllowVc] withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];

}
#pragma mark -------- SegmentTapView delegate
-(void)selectedIndex:(NSInteger)index
{
    if (index==0) {

        [_myPushVc loadMyPushNewData];
    }else{
//        [_myFllowVc loadMyFllowNewData];
    }
    
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {
        [_myPushVc loadMyPushNewData];

    }else{
//        [_myFllowVc loadMyFllowNewData];

    }
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
