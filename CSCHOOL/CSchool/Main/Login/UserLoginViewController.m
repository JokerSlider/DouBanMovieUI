//
//  UserLoginViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/7/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "UserLoginViewController.h"
#import "SDAutoLayout.h"
#import <UIImageView+WebCache.h>
#import "LoginTextField.h"
#import "UserFirstLoginViewController.h"
#import "JohnAlertManager.h"
@interface UserLoginViewController ()

@property (nonatomic, retain) UIScrollView *mainScrollView;

@property (nonatomic, retain) LoginTextField *usernameTextField;
@property (nonatomic, retain) LoginTextField *passwordTextField;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.view.backgroundColor = Base_Orange;
    
    //检查更新
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdate object:@"update"];

    [self createViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"newLogin_bg"] forBarMetrics:UIBarMetricsDefault];

}

- (void)createViews{
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.backgroundColor = RGB(245, 245, 245);

    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_bg"]];
    
    _usernameTextField = ({
        LoginTextField *view = [LoginTextField new];
        view.placeholder = @"请输入你的账号";
        view.font = [UIFont systemFontOfSize:14];
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_name"]];
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
        view.placeholder = @"请输入你的密码";
        view.font = [UIFont systemFontOfSize:14];
        view.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_key"]];
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
    [loginButton addTarget:self action:@selector(postCheckNum) forControlEvents:UIControlEventTouchUpInside];

    UIButton *newLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newLoginButton setTitle:@"我是新生" forState:UIControlStateNormal];
    [newLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newLoginButton.backgroundColor = RGB(217,45,45);
    newLoginButton.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
    [newLoginButton addTarget:self action:@selector(newLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView sd_addSubviews:@[bgView, _usernameTextField, _passwordTextField, loginButton, newLoginButton]];
    
    bgView.sd_layout
    .leftSpaceToView(_mainScrollView, 0)
    .topSpaceToView(_mainScrollView, 0)
    .rightSpaceToView(_mainScrollView, 0)
    .heightIs(NewLayoutHeightCGFloat(288));
    
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
    
    newLoginButton.sd_layout
    .leftEqualToView(_usernameTextField)
    .rightEqualToView(_usernameTextField)
    .heightRatioToView(_usernameTextField, 1)
    .topSpaceToView(loginButton, NewLayoutHeightCGFloat(15));
    
    [_mainScrollView setupAutoContentSizeWithBottomView:newLoginButton bottomMargin:20];

    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].schoolLogo] placeholderImage:[UIImage imageNamed:@"newLogin_jing"]];
    
    UILabel *schoolLabel = [[UILabel alloc] init];
    schoolLabel.text = [AppUserIndex GetInstance].schoolName;
    schoolLabel.textAlignment = NSTextAlignmentCenter;
    schoolLabel.textColor = [UIColor whiteColor];
    
    [bgView sd_addSubviews:@[logoImageView, schoolLabel]];
    
    logoImageView.sd_layout
    .topSpaceToView(bgView, NewLayoutHeightCGFloat(21))
    .widthIs(NewLayoutHeightCGFloat(106))
    .heightIs(NewLayoutHeightCGFloat(106))
    .centerXEqualToView(bgView);
    
    schoolLabel.sd_layout
    .leftSpaceToView(bgView, 10)
    .rightSpaceToView(bgView, 10)
    .topSpaceToView(logoImageView, 19)
    .heightIs(16);
    
    newLoginButton.hidden = !_isShowNew;
}

- (void)newLoginAction:(UIButton *)sender{
    UserFirstLoginViewController *vc = [[UserFirstLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  将验证码 用户输入的用户名 密码 验证码 学校信息一起发过去
 */
-(void)postCheckNum{
    
    UIDevice *curDev = [UIDevice currentDevice];
    AppUserIndex *user = [AppUserIndex GetInstance ];
    //设备唯一编号
    NSString *rid =@"updateUser";
    NSString *simNum = @"0";
    NSString *subscriberNum = @"0";
    NSString *imsiNum = @"0";
    NSString *deviceMode = @"0";
    NSString *deviceNum = [NSString stringWithFormat:@"%@",[curDev.identifierForVendor UUIDString]];
    NSString *osType = [NSString stringWithFormat:@"ios%.1f",[[curDev systemVersion] floatValue]];
    NSString *username =_usernameTextField.text;
    NSString *password = _passwordTextField.text;
    
    if ([username length]<1) {
        [ProgressHUD showError:@"请输入用户名"];
        return;
    }
    if ([password length]<1) {
        [ProgressHUD showError:@"请输入密码"];
        return;
    }
    [ProgressHUD show:nil];
    [self.view endEditing:YES];
    NSDictionary *params = @{
                             @"rid" : rid,
                             @"username" :username,
                             @"password":password,
                             @"schoolId":[AppUserIndex GetInstance].schoolId,
                             @"deviceNum":deviceNum,
                             @"simNum":simNum,
                             @"subscriberNum":subscriberNum,
                             @"imsiNum":imsiNum,
                             @"deviceMode":deviceMode,
                             @"osType":osType,
                             @"phone":user.userInputPhonenum?user.userInputPhonenum:@""
                             };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:params success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"-----%@",responseObject[@"data"]);
        
        [AppUserIndex GetInstance].isNewEntry = NO;
        if (![[responseObject objectForKey:@"roleInfo"] isKindOfClass:[NSArray class]]) {
            [self queryUserInfo];
            return ;
        }
        NSArray *userArr = [responseObject objectForKey:@"roleInfo"];
        
        if (userArr.count!=0) {
            for (NSDictionary *dic in userArr) {
                user.role_type = [NSString stringWithFormat:@"%@",dic[@"ROLE_TYPE"]];
                user.role_id =[NSString stringWithFormat:@"%@",dic[@"ROLE_ID"]];
            }
        }else{
            //默认是学生
            user.role_id = @"";
            user.role_username = @"";
        }
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
        NSString *msg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"msg"]];
        //过期时间
        user.tokenTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tokenExpTime"]];
        //用户token
        user.token = [dic objectForKey:@"token"];
        user.loginId=[dic objectForKey:@"loginId"];
        [user saveToFile];
        //将服务器生成的设备唯一标识存到本地
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"deviceId"] forKey:@"deviceId"];
        if ([code isEqualToString:@"UserModel_class_0x00005100000"]) {
            [self queryUserInfo];
        }else{
            [ProgressHUD showError:msg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {        
        [ProgressHUD showError:error[@"msg"]];

    }];
}

/*
 *获取用户信息
 */
-(void)queryUserInfo{
    
    [NetworkCore queryUserInfoWithName:_usernameTextField.text success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //更新成功-----保存用户ID  密码
        AppUserIndex *user = [AppUserIndex GetInstance];
        
        user.accountId = _usernameTextField.text;
        user.passWord = _passwordTextField.text;
        
        //验证成功  登陆-----
        [self getAppInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
}

//根据角色信息返回账号显示套餐
- (void)getAppInfo{
#ifdef isNewVer
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getNewAppSystemInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //        [AppUserIndex GetInstance].appListArray = responseObject[@"data"];
        [AppUserIndex GetInstance].fileListArray = [responseObject valueForKeyPath:@"data.file"];
        [AppUserIndex GetInstance].hotListArray = [responseObject valueForKeyPath:@"data.hot"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationLoginSuccess" object:self];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
#else
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAppSystemInfoForIos"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [AppUserIndex GetInstance].appListArray = responseObject[@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationLoginSuccess" object:self];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
#endif

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
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
