//
//  UIViewController+KSNoNetController.m
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import "UIViewController+KSNoNetController.h"
#import "KSNetRequest.h"
#import "KSNoNetView.h"

@implementation UIViewController (KSNoNetController)

- (void)showNonetWork
{
    KSNoNetView* view = [KSNoNetView instanceNoNetView];
    view.delegate = self;
    [self.view addSubview:view];
}
- (void)hiddenNonetWork
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[KSNoNetView class]]) {
            [view removeFromSuperview];
        }
    }
}
- (void)reloadNetworkDataSource:(id)sender
{
    if ([self respondsToSelector:@selector(reloadData)]) {
        [self performSelector:@selector(reloadData)];
    }
}
- (void)showErrorView:(NSString *)showString andImageName:(NSString*)imageName{
    [self hiddenErrorView];
    FairlView *fView = [[FairlView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    fView.title = showString;
    fView.imageName = imageName;
    [self.view addSubview:fView];
}
//使用此方法  会有一个重新加载的按钮
- (void)showErrorViewLoadAgain:(NSString *)showString
{
    FairlView *fView = [[FairlView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    fView.title = showString;
    fView.loadBtn.hidden = NO;
    fView.delegate =self;
    fView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:fView];
}
-(void)reloadDataSource
{
    [self hiddenErrorView];
    if ([self respondsToSelector:@selector(loadData)]) {
        [self performSelector:@selector(loadData)];
    }
}
- (void)hiddenErrorView{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[FairlView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)loadData
{
    NSLog(@"必须由网络控制器(%@)重写这个方法(%@)，才可以使用再次刷新网络",NSStringFromClass([self class]),NSStringFromSelector(@selector(loadData)));
}
@end
