//
//  SportsMainViewController.m
//  CSchool
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "SportsMainViewController.h"
#import "MineSportView.h"
#import "SportGroupView.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface SportsMainViewController ()
{
    MineSportView *_oneVC;
    SportGroupView *_twoVC;

}
@property (nonatomic,strong) UISegmentedControl *segmentedControl;
@property (nonatomic,assign) NSInteger  currentIndex;

@end

@implementation SportsMainViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavSegmentView];
    [_oneVC.danmuTimer setFireDate:[NSDate date]];
    if (!_currentIndex) {
        _currentIndex = 0;
    }
    _segmentedControl.selectedSegmentIndex = _currentIndex;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.segmentedControl removeFromSuperview];
    [_oneVC.danmuTimer setFireDate:[NSDate  distantFuture]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  initView];
}

-(void)initView
{
    _oneVC = [[MineSportView alloc] initWithFrame:self.view.frame];
    _twoVC = [[SportGroupView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_oneVC];
}
-(void)setNavSegmentView
{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"好友榜",@"群组",nil];
    _segmentedControl  = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake((kScreenWidth-135)/2,10, 135, 25);
    _segmentedControl.tintColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    NSDictionary *noseDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont systemFontOfSize:14.0],UITextAttributeFont,nil];
    [_segmentedControl setTitleTextAttributes:noseDic forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_segmentedControl];
}
#pragma mark
-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            //第一个界面
            [self.view addSubview:_oneVC];
            [_oneVC.danmuTimer setFireDate:[NSDate date]];
            [_twoVC removeFromSuperview];
            break;
        case 1:
            [self.view addSubview:_twoVC];
            [_oneVC.danmuTimer setFireDate:[NSDate  distantFuture]];
            [_oneVC removeFromSuperview];
            
            break;
        default:
            break;
    }
    self.currentIndex = segment.selectedSegmentIndex;

}
#pragma clang diagnostic pop

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
