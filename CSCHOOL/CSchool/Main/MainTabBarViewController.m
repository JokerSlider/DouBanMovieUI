//
//  MainTabBarViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "PlayGroundNewViewController.h"
#import "SettingViewController.h"
#import "IQKeyboardManager.h"
#import "XGAlertView.h"
#import "SettingNewViewController.h"

@interface MainTabBarViewController ()<XGAlertViewDelegate>
{
    SettingNewViewController *setVc;
}
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubVies];
}

- (void)createSubVies{
    //操场
    PlayGroundNewViewController *playVc = [[PlayGroundNewViewController alloc] init];
    UINavigationController *playNav = [[UINavigationController alloc] initWithRootViewController:playVc];
    playNav.navigationItem.title = @"操场";
    playNav.tabBarItem.title = @"操场";
    playNav.tabBarItem.image = [UIImage imageNamed:@"shouye"];
    playNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"首页"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    [self addChildViewController:playNav];
    
    //设置
    setVc = [[SettingNewViewController alloc] init];
    UINavigationController *setNav = [[UINavigationController alloc] initWithRootViewController:setVc];
    setVc.navigationItem.title = @"设置";
    setVc.tabBarItem.title = @"设置";
    setVc.tabBarItem.image = [UIImage imageNamed:@"shezhi"];
    setVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"设置"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:setNav];
    
    CGRect tabFrame = self.tabBar.frame;

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = Base_Color2;
    CGFloat lineX = ceilf(0.5 * tabFrame.size.width);
    CGFloat lineY = ceilf(0.05 * tabFrame.size.height);
    lineView.frame = CGRectMake(lineX, lineY, 1, ceilf(0.9 * tabFrame.size.height));
    [self.tabBar addSubview:lineView];
    if ([AppUserIndex GetInstance].isUpdate) {
        [self addRedView];
    }
}

- (void)addRedView{
    UIImageView *dotImage = [[UIImageView alloc] init];
    dotImage.backgroundColor = [UIColor redColor];
    CGRect tabFrame = setVc.tabBarController.tabBar.frame;
    CGFloat x = ceilf(0.8 * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    dotImage.frame = CGRectMake(x, y, 10, 10);
    dotImage.layer.cornerRadius = 5;
    setVc.isUpdate = YES;
    [setVc.tabBarController.tabBar addSubview:dotImage];
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
