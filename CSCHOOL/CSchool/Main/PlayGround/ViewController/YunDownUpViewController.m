//
//  YunDownUpViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "YunDownUpViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "YunDownloadListViewController.h"
#import "YunUploadViewController.h"

@interface YunDownUpViewController ()

@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;

@property (nonatomic, retain) YunDownloadListViewController *downloadVc;
@property (nonatomic, retain) YunUploadViewController *uploadVc;

@end

@implementation YunDownUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadsegMent];
}

//加载分段视图 并加载数据
-(void)loadsegMent
{
    _downloadVc = [[YunDownloadListViewController alloc]init];
    _uploadVc = [[YunUploadViewController alloc]init];
//    _news.funcType = _funcType;
//    _news2.funcType = _funcType;
//    [_news loadData];
    NSArray *controllers=@[_downloadVc,_uploadVc];
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:@[@"下载", @"上传"] withFont:13];
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

    }else{
        //        [_news2 loadNewData];
    }
    
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {

    }else{
        //        [_news2 loadNewData];
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
