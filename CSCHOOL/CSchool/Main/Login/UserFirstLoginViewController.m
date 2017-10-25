//
//  UserFirstLoginViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/7/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "UserFirstLoginViewController.h"
#import "SDAutoLayout.h"
#import <UIImageView+WebCache.h>
#import "LoginTextField.h"
#import "UserPhoneInputViewController.h"

@interface UserFirstLoginViewController ()
@property (nonatomic, retain) UIScrollView *mainScrollView;

@property (nonatomic, retain) LoginTextField *usernameTextField;
@property (nonatomic, retain) LoginTextField *passwordTextField;

@end

@implementation UserFirstLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = Base_Orange;
    
    [self createViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];//backIndicatorImage
    
    CGSize titleSize = self.navigationController.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
    UIImage *image = [UIImage imageNamed:@"newLogin_huan"];
    
    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, 64));
    [image drawInRect:CGRectMake(0, 0, titleSize.width, 227)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [self.navigationController.navigationBar setBackgroundImage:scaledImage forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage=[UIImage imageNamed:@"newLogin_huan"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

}

- (void)dealloc{
}

- (void)createViews{

    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.backgroundColor = RGB(245, 245, 245);
    
    [self.view addSubview:_mainScrollView];
    
    UIImageView *bacImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_huan"]];
    
    
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_bg"]];
    
    _usernameTextField = ({
        LoginTextField *view = [LoginTextField new];
        view.placeholder = @"请输入高考考生号";
        view.font = [UIFont systemFontOfSize:14];
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_zhun"]];
        view.leftView = leftView;
        view.leftViewMode=UITextFieldViewModeAlways;
        view.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
        view.layer.borderWidth = .5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        //关闭首字母大写
        view.autocapitalizationType =  UITextAutocapitalizationTypeNone;
        view.clearButtonMode = UITextFieldViewModeAlways;
        view.returnKeyType = UIReturnKeyNext;
        view.autocorrectionType=UITextAutocorrectionTypeNo;
        
        view;
    });
    
    _passwordTextField = ({
        LoginTextField *view = [LoginTextField new];
        view.placeholder = @"请输入身份证号后8位";
        view.font = [UIFont systemFontOfSize:14];
        view.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_shen"]];
        view.leftViewMode=UITextFieldViewModeAlways;
        view.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
        view.layer.borderWidth = .5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        view.clearButtonMode = UITextFieldViewModeAlways;
        view.returnKeyType = UIReturnKeyNext;
        view.secureTextEntry = YES;
        view.autocorrectionType=UITextAutocorrectionTypeNo;
        
        view;
    });
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"登   录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = Base_Orange;
    loginButton.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *newLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [newLoginButton setTitle:@"我是新生" forState:UIControlStateNormal];
//    [newLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    newLoginButton.backgroundColor = RGB(217,45,45);
//    newLoginButton.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
    
    [_mainScrollView sd_addSubviews:@[bgView, _usernameTextField, _passwordTextField, loginButton]];
    
    [bgView addSubview:bacImageView];
    
    bgView.sd_layout
    .leftSpaceToView(_mainScrollView, 0)
    .topSpaceToView(_mainScrollView, 0)
    .rightSpaceToView(_mainScrollView, 0)
    .heightIs(NewLayoutHeightCGFloat(288));
    
    bacImageView.sd_layout
    .leftSpaceToView(bgView, 0)
    .topSpaceToView(bgView, -40)
    .rightSpaceToView(bgView, 0)
    .heightIs(NewLayoutHeightCGFloat(227));
    
    _usernameTextField.sd_layout
    .leftSpaceToView(_mainScrollView, 45)
    .rightSpaceToView(_mainScrollView, 45)
    .heightIs(NewLayoutHeightCGFloat(40))
    .topSpaceToView(bgView, NewLayoutHeightCGFloat(8));
    
    _passwordTextField.sd_layout
    .leftSpaceToView(_mainScrollView, 45)
    .rightSpaceToView(_mainScrollView, 45)
    .heightIs(NewLayoutHeightCGFloat(40))
    .topSpaceToView(_usernameTextField, NewLayoutHeightCGFloat(15));
    
    loginButton.sd_layout
    .leftEqualToView(_usernameTextField)
    .rightEqualToView(_usernameTextField)
    .heightRatioToView(_usernameTextField, 1)
    .topSpaceToView(_passwordTextField, NewLayoutHeightCGFloat(42));
    
//    newLoginButton.sd_layout
//    .leftEqualToView(_usernameTextField)
//    .rightEqualToView(_usernameTextField)
//    .heightRatioToView(_usernameTextField, 1)
//    .topSpaceToView(loginButton, NewLayoutHeightCGFloat(15));
    
    [_mainScrollView setupAutoContentSizeWithBottomView:loginButton bottomMargin:20];
    
}

- (void)loginAction:(UIButton *)sender{
    [self.view endEditing:YES];
    
    if ([_usernameTextField.text length]<1) {
        [ProgressHUD showError:@"请输入用户名"];
        return;
    }
    if ([_passwordTextField.text length]<1) {
        [ProgressHUD showError:@"请输入密码"];
        return;
    }
    [ProgressHUD show:nil];
    NSDictionary *commitDic = @{
                                @"rid":@"checkNewAccountByIDcard",
                                @"accountid":_usernameTextField.text,
                                @"password":_passwordTextField.text,
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        AppUserIndex *user = [AppUserIndex GetInstance];
        user.passWord = _passwordTextField.text;
        [AppUserIndex GetInstance].isNewEntry = YES; //登录成功设置新生标识
        [self queryUserInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];

   
}

/*
 *获取用户信息
 */
-(void)queryUserInfo{
    WEAKSELF;
    [NetworkCore queryUserInfoWithName:_usernameTextField.text success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //更新成功-----保存用户ID  密码
        AppUserIndex *user = [AppUserIndex GetInstance];
        user.passWord = _passwordTextField.text;
        
        
        [AppUserIndex GetInstance].appListArray = responseObject[@"newEntry"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationLoginSuccess" object:self];
        [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];

//        if ([AppUserIndex GetInstance].phoneNum) {
//            //验证成功  登陆-----
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationLoginSuccess" object:self];
//            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
//        }else{
//            UserPhoneInputViewController *vc = [[UserPhoneInputViewController alloc] init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }
        [ProgressHUD dismiss];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        //        _loginBtn.backgroundColor=Base_Color3;
        //        _loginBtn.enabled=NO;
        //        [self showCheckNum];
    }];
}

//根据角色信息返回账号显示套餐
- (void)getAppInfo{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAppSystemInfoForIos"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [AppUserIndex GetInstance].appListArray = responseObject[@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationLoginSuccess" object:self];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}


@end
