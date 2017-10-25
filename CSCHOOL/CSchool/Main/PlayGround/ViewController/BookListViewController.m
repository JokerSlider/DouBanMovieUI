//
//  BookListViewController.m
//  CSchool
//
//  Created by mac on 17/1/4.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BookListViewController.h"
#import "LibraryMidView.h"
#import "UIView+SDAutoLayout.h"
#define leftWidth 10

@interface BookListViewController ()

@end

@implementation BookListViewController
{
    LibraryMidView *_midView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    self.title = @"书籍借阅榜";
    [self setUpMidView];
    [self loadData];
}
-(void)loadData
{
    [ProgressHUD show:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [_midView loadNewData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [_midView relodTableViewData];
        });
    });
}
//书籍借阅榜
-(void)setUpMidView
{
    _midView  = [LibraryMidView new];
    [self.view sd_addSubviews:@[_midView]];
    _midView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,leftWidth).heightIs(kScreenHeight-76);

    
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
