//
//  AppDelegate.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreNewFeatureVC.h"
#import "MainViewController.h"
#import "LoadingViewController.h"
@interface AppDelegate ()
@property (nonatomic,strong)LoadingViewController  *loadingViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    if (canShow) {
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"AAA.jpg"]];
        
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"BBB.jpg"]];
        
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"CCC.jpg"]];
        
        NewFeatureModel *m4 = [NewFeatureModel model:[UIImage imageNamed:@"DDD.jpg"]];
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3,m4] enterBlock:^{
            
            [self enter];
        }];
    }else{
        _loadingViewController = [[LoadingViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loadingViewController];
        nav.navigationBarHidden =  YES;
        [self.window setRootViewController:nav];
        
       
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            MainViewController *vc = [[MainViewController alloc] init];
            self.loadingViewController.navigationController.navigationBarHidden = NO;
            [self.loadingViewController.navigationController presentViewController:vc animated:NO completion:^{
                MainViewController *vc = [[MainViewController alloc]init];
                UINavigationController *playNav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.window setRootViewController:playNav];
            }];
        });
    }
     return YES;
}
//弹出
-(void)enter
{
    _loadingViewController = [[LoadingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loadingViewController];
    nav.navigationBarHidden = YES;
    [self.window setRootViewController:nav];
    
    [self presentLoginVC:_loadingViewController];
}
//弹出登录页面
-(void)presentLoginVC:(UIViewController *)ownerViewControler{
    
    MainViewController *vc = [[MainViewController alloc]init];
    UINavigationController *navlogin = [[UINavigationController alloc] initWithRootViewController:vc];
    [ownerViewControler presentViewController:navlogin  animated:YES completion:nil];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
