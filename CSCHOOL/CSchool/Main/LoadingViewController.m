//
//  LoadingViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/7.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "LoadingViewController.h"
#import "XGAlertView.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUpdate:) name:NotificationUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutShow:) name:NotificationRelogin object:nil];

    [self checkUpdate:nil];
    
}

- (void)logoutShow:(NSNotification *)notice{
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:notice.object WithCancelButtonTitle:@"确定" withOtherButton:nil];
    alert.isBackClick = YES;
    alert.tag = 3002;
    [alert show];
}

- (void)checkUpdate:(NSNotification *)notice{
    
//    NSString *schoolCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"schoolCode"];
    if (![AppUserIndex GetInstance].schoolCode) {
        return;
    }
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAppUpdateInfo",@"osType":@"ios",@"schoolCode":[AppUserIndex GetInstance].schoolCode} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *versionNum = [responseObject valueForKeyPath:@"data.versionNum"];
        if ([versionNum length]>0) {
            if ([[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"] compare:versionNum] == NSOrderedAscending){
               //有新版本
                [AppUserIndex GetInstance].isUpdate = YES;
                if ([[responseObject valueForKeyPath:@"data.isBind"] isEqualToString:@"true"]) {
                    
                    NSString *note = [responseObject valueForKeyPath:@"data.note"];
                    if ([note isEqual:[NSNull null]]) {
                        note = @"";
                    }
                    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:[NSString stringWithFormat:@"发现新版本，请更新后使用\n %@",note] WithCancelButtonTitle:@"更新" withOtherButton:nil];
                    alert.tag = 3001;
                    alert.viewString = [responseObject valueForKeyPath:@"data.url"];
                    alert.isMustShow = YES;
                    [alert show];
                }else{
                    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"发现新版本，是否更新" WithCancelButtonTitle:@"更新" withOtherButton:@"取消"];
                    alert.tag = 3001;
                    alert.viewString = [responseObject valueForKeyPath:@"data.url"];
                    [alert show];
                }
            }else if ([notice.object isEqualToString:@"HUD"]){
                [ProgressHUD showSuccess:@"已经是最新版本" Interaction:NO];
            }
        }else if ([notice.object isEqualToString:@"HUD"]){
            [ProgressHUD showSuccess:@"已经是最新版本" Interaction:NO];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag==3001) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:view.viewString]];
    }else if (view.tag == 3002){
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
    }
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
