//
//  WordNewsPageViewController.m
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WordNewsPageViewController.h"
@interface WordNewsPageViewController ()

@end
//extern NSString *const ZJParentTableViewDidLeaveFromTopNotification;

@implementation WordNewsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    /// 利用通知可以同时修改所有的子控制器的scrollView的contentOffset为CGPointZero
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveFromTop) name:@"ZJParentTableViewDidLeaveFromTopNotification" object:nil];
}


- (void)leaveFromTop {
    _scrollView.contentOffset = CGPointZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = scrollView;
        //        _scrollView.bounces = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.delegate scrollViewIsScrolling:scrollView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
