//
//  MyFlowerPushDataVC.m
//  CSchool
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyFlowerPushDataVC.h"
#import <MJRefresh.h>

@interface MyFlowerPushDataVC ()
@property (nonatomic,assign)int  page;

@end

@implementation MyFlowerPushDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.FlowercollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMyPushNewData)];
    self.FlowercollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    [self.FlowercollectionView.mj_header beginRefreshing];
}
-(void)loadData
{
    [super loadData];
    [self loadMyPushNewData];
}
//加载以前的数据
-(void)loadPastData
{
    _page++;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithRID:@"findPhotowallInfoByUser" pageNum:pageNum];
}
//加载我发布的最新鲜花信息
-(void)loadMyPushNewData
{
    _page = 1;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithRID:@"findPhotowallInfoByUser" pageNum:pageNum];

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
