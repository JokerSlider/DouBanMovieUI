//
//  PaySuccessViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "SDAutoLayout.h"
#import "AdView.h"
#import "PlayGroundNewViewController.h"
#import "SettingNewViewController.h"
#import "XGAlertView.h"
#import "RxWebViewController.h"

@interface PaySuccessViewController ()<XGAlertViewDelegate>

@property (nonatomic, retain) UIScrollView *mainScrollView;

@property (nonatomic, retain) AdView *adView;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付结果";
    self.view.backgroundColor = RGB(247, 247, 247);
    
    [self createViews];
    [self saveOderInfo];
}

- (void)saveOderInfo{
    NSString *key = [NSString stringWithFormat:@"%@-oder",[AppUserIndex GetInstance].role_id];
    NSDictionary *dic = @{
                          @"oder":_orderStr,
                          @"time":@([[NSDate date] timeIntervalSince1970])
                          };
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:key];
}

- (void)createViews{
    _mainScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIView *bacView = [[UIView alloc] init];
    bacView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:bacView];
    
    UIImageView *yesImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_success"]];
    
    UILabel *showTextLabel = [[UILabel alloc] init];
    showTextLabel.font = [UIFont systemFontOfSize:15];
    showTextLabel.textColor = Base_Orange;
    showTextLabel.textAlignment = NSTextAlignmentCenter;
    showTextLabel.text = @"恭喜你，缴费成功！";
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = [UIFont systemFontOfSize:24];
    moneyLabel.textColor = Color_Black;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.text = _money;
    
    [bacView sd_addSubviews:@[yesImage, showTextLabel, moneyLabel]];
    
    bacView.sd_layout
    .leftSpaceToView(_mainScrollView,0)
    .topSpaceToView(_mainScrollView,0)
    .rightSpaceToView(_mainScrollView,0)
    .heightIs(210);
    
    yesImage.sd_layout
    .topSpaceToView(bacView, 49)
    .centerXEqualToView(bacView)
    .heightIs(50)
    .widthIs(50);
    
    showTextLabel.sd_layout
    .topSpaceToView(yesImage,10)
    .leftSpaceToView(bacView,10)
    .rightSpaceToView(bacView,10)
    .heightIs(15);
    
    moneyLabel.sd_layout
    .topSpaceToView(showTextLabel,18)
    .leftSpaceToView(bacView,10)
    .rightSpaceToView(bacView,10)
    .heightIs(19);
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:Base_Orange];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 5;
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView addSubview:sureButton];
    
    sureButton.sd_layout
    .leftSpaceToView(_mainScrollView, 10)
    .rightSpaceToView(_mainScrollView,10)
    .heightIs(45)
    .topSpaceToView(bacView,15);
    
    _adView = [[AdView alloc] initWithFrame:CGRectMake(0, kScreenHeight-100-64, kScreenWidth, 100) withStyle:AdViewImage withSource:@"1"];
//    [_mainScrollView addSubview:_adView];
}

- (void)sureButtonClick:(UIButton *)sender{
    
    if (_adView.model.photo_url) {
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withWebViewContent:_adView.model.photo_url];
//        alert.isBackClick = YES;
        alert.delegate = self;
        alert.tag = 1214;
//        alert.sub
        
        UIButton *btn = alert.subviews[1].subviews[2];
        [btn setImage:[UIImage imageNamed:@"alert_icon"] forState:UIControlStateNormal];
        
        WEAKSELF;
        alert.backViewClick = ^(XGAlertView *alertView){
            RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString: weakSelf.adView.model.jump_url]];//weakSelf.adView.model.jump_url
            [weakSelf.navigationController pushViewController:vc animated:YES];
            [alertView removeView];
        };
        
        [alert WebviewShow];
    }else{
        
        NSArray *vcArr = self.navigationController.viewControllers;
        for (NSInteger i=vcArr.count-1; i>-1; i--) {
            UIViewController *vc = vcArr[i];
            if ([vc isKindOfClass:[PlayGroundNewViewController class]] || [vc isKindOfClass:[SettingNewViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
    

}

#pragma XGAlertViewDelegate
-(void)alertViewDidClickNoticeImageView:(XGAlertView *)view
{
    if (view.tag == 1214) {
        NSArray *vcArr = self.navigationController.viewControllers;
        for (NSInteger i=vcArr.count-1; i>-1; i--) {
            UIViewController *vc = vcArr[i];
            if ([vc isKindOfClass:[PlayGroundNewViewController class]] || [vc isKindOfClass:[SettingNewViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
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
