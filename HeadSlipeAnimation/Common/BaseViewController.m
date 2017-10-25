//
//  BaseViewController.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/23.
//  Copyright © 2017年 Joker. All rights reserved.
//

//
//  BaseViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface BaseViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSString *_emptyStr;
    NSString *_emptyImage;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
#else
    float barHeight =0;
    if (!isIPad()&& ![[UIApplication sharedApplication] isStatusBarHidden]) {
        barHeight+=([[UIApplication sharedApplication]statusBarFrame]).size.height;
    }
    if(self.navigationController &&!self.navigationController.navigationBarHidden) {
        barHeight+=self.navigationController.navigationBar.frame.size.height;
    }
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height - barHeight);
        } else {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height);
        }
    }
#endif
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = Base_Orange;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setEmptyView:(UITableView *)tableView withString:(NSString *)emptyStr withImageName:(NSString *)imageName{
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    _emptyStr = emptyStr;
    _emptyImage = imageName;
    // A little trick for removing the cell separators
    if (!tableView.tableFooterView) {
        tableView.tableFooterView = [UIView new];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (!_emptyStr) {
        _emptyStr = @"";
    }
    NSString *text = _emptyStr;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:_emptyImage];
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
