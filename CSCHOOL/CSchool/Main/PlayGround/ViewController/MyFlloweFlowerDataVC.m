//
//  MyFlloweFlowerDataVC.m
//  CSchool
//
//  Created by mac on 16/11/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyFlloweFlowerDataVC.h"
#import <MJRefresh.h>

@interface MyFlloweFlowerDataVC ()
@property (nonatomic,assign)int  page;

@end

@implementation MyFlloweFlowerDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    self.FlowercollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMyFllowNewData)];
    self.FlowercollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    [self.FlowercollectionView.mj_header beginRefreshing];
}
-(void)loadData
{
    [super loadData];
    [self loadMyFllowNewData];
}
-(void)loadPastData
{
    _page ++;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithRID:@"findPersonComment" pageNum:pageNum];
}

-(void)loadMyFllowNewData
{
    _page = 1;
    NSString *pageNum = [NSString stringWithFormat:@"%d",_page];
    [self loadDataWithRID:@"findPersonComment" pageNum:pageNum];
    
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
