
//
//  ReaderListViewController.m
//  CSchool
//
//  Created by mac on 17/1/4.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ReaderListViewController.h"
#import "LibraryBottonView.h"
#import "UIView+SDAutoLayout.h"
#define leftWidth 10
@interface ReaderListViewController ()

@end

@implementation ReaderListViewController
{
    LibraryBottonView  *_bottomView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"读者排行榜";
    [self setUpBottomView];
    [self loadData];
}
-(void)loadData
{
    [ProgressHUD show:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [_bottomView loadNewData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [_bottomView relodTableViewData];
        });
    });

}
//读者阅读榜
-(void)setUpBottomView
{
    _bottomView  = [LibraryBottonView new];
    [self.view sd_addSubviews:@[_bottomView]];
    _bottomView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,10).heightIs(kScreenHeight-76);
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
