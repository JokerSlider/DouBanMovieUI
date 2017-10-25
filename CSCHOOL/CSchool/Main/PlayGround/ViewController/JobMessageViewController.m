//
//  JobMessageViewController.m
//  CSchool
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "JobMessageViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "SchoolRecruitViewController.h"
#import "AllJobRecruitViewController.h"
#import "PracticeJobViewController.h"
@interface JobMessageViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
@property (nonatomic, retain) SchoolRecruitViewController *schooRecritVC;//校内招聘

@property (nonatomic, retain) AllJobRecruitViewController *allJobRecritVC;//全职招聘

@property (nonatomic,retain) PracticeJobViewController    *practiceJobVC;//实习兼职

@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;
@end

@implementation JobMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}
-(void)createView
{
    self.title = @"就业资讯";
    _schooRecritVC = [[SchoolRecruitViewController alloc]init];
    _allJobRecritVC = [[AllJobRecruitViewController alloc]init];
    _practiceJobVC = [[PracticeJobViewController alloc]init];

    NSArray *controllers=@[_schooRecritVC,_allJobRecritVC,_practiceJobVC];
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:@[@"校内招聘",@"全职招聘",@"实习兼职"] withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height - 40) withArray:controllers withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
}
#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    if (index==0) {
        [_schooRecritVC loadData];
    }else if(index==1){
        [_allJobRecritVC loadData];
    }else{
        [_practiceJobVC loadData];
    }
    
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {
        [_schooRecritVC loadData];
    }else if(index==1){
        [_allJobRecritVC loadData];
    }else{
        [_practiceJobVC loadData];
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
