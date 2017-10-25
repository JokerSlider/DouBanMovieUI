//
//  UserPhoneInputViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/7/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "UserPhoneInputViewController.h"
#import "SDAutoLayout.h"
#import <UIImageView+WebCache.h>
#import "LoginTextField.h"
#import "UserFirstLoginViewController.h"
#import "UserPhoneInput2ViewController.h"
#import "JKCountDownButton.h"

@interface UserPhoneInputViewController ()
{
    JKCountDownButton *_countDownCode;
}
@property (nonatomic, retain) UIScrollView *mainScrollView;

@property (nonatomic, retain) LoginTextField *usernameTextField;
@property (nonatomic, retain) LoginTextField *passwordTextField;
@property (nonatomic, retain) LoginTextField *otherTelTextField;
@property (nonatomic, retain) UIButton *getCodeBtn;

@property (nonatomic, strong) NSDictionary *showInfoDic; //存放展示提示文字内容
@end

@implementation UserPhoneInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"验证第一张手机卡";
    self.view.backgroundColor = Base_Orange;
    
    [self loadShowInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"newLogin_bg"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPhone:)];
    self.navigationItem.rightBarButtonItem = leftItem1;
}

- (void)loadShowInfo{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showNewStudentTrip"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        _showInfoDic = responseObject[@"data"];
        [self createViews];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

- (void)cancelPhone:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createViews{
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.backgroundColor = RGB(245, 245, 245);
    
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_bg"]];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = _showInfoDic[@"trip1"];
    noticeLabel.textColor = Base_Orange;
    noticeLabel.font = [UIFont systemFontOfSize:15];
    
    _usernameTextField = ({
        LoginTextField *view = [LoginTextField new];
        view.placeholder = @"请输入手机号";
        view.font = [UIFont systemFontOfSize:14];
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_phone"]];
        view.leftView = leftView;
        view.leftViewMode=UITextFieldViewModeAlways;
        view.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
        view.layer.borderWidth = .5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.keyboardType = UIKeyboardTypePhonePad;
        view;
    });
    
    _passwordTextField = ({
        LoginTextField *view = [LoginTextField new];
        view.placeholder = @"请输入验证码";
        view.font = [UIFont systemFontOfSize:14];
        view.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_phone"]];
        view.leftViewMode=UITextFieldViewModeAlways;
        view.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
        view.layer.borderWidth = .5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.keyboardType = UIKeyboardTypeNumberPad;
        view;
    });
    
    _otherTelTextField = ({
        LoginTextField *view = [LoginTextField new];
        view.placeholder = @"紧急联系人电话";
        view.font = [UIFont systemFontOfSize:14];
        view.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_phone"]];
        view.leftViewMode=UITextFieldViewModeAlways;
        view.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
        view.layer.borderWidth = .5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view;
    });
    
    
    _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [_countDownCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_countDownCode setTitleColor:Base_Orange forState:UIControlStateNormal];
    _countDownCode.titleLabel.font = Title_Font;
    [_passwordTextField addSubview:_countDownCode];
    [_getCodeBtn addTarget:self action:@selector(sendMsgCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    WEAKSELF;
    [_countDownCode countDownButtonHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
        if ([_usernameTextField.text length]<1) {
            [ProgressHUD showError:@"请输入手机号"];
            return;
        }
        
        [weakSelf sendMsgCodeAction:sender];
        
    }];

        
    _countDownCode.sd_layout
    .rightSpaceToView(_passwordTextField, 0)
    .topSpaceToView(_passwordTextField, 0)
    .heightRatioToView(_passwordTextField, 1)
    .widthIs(100);
    
//    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [loginButton setTitle:@"登   录" forState:UIControlStateNormal];
//    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    loginButton.backgroundColor = Base_Orange;
//    loginButton.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
    
    UIButton *newLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newLoginButton setTitle:@"下一步" forState:UIControlStateNormal];
    [newLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newLoginButton.backgroundColor = Base_Orange;
    newLoginButton.sd_cornerRadius = @(NewLayoutHeightCGFloat(20));
    [newLoginButton addTarget:self action:@selector(newLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mainScrollView sd_addSubviews:@[noticeLabel, _usernameTextField, _passwordTextField, newLoginButton]];
    
    noticeLabel.sd_layout
    .leftSpaceToView(_mainScrollView, 30)
    .topSpaceToView(_mainScrollView, 30)
    .rightSpaceToView(_mainScrollView, 30)
    .autoHeightRatio(0);
    
    _usernameTextField.sd_layout
    .leftSpaceToView(_mainScrollView, 45)
    .rightSpaceToView(_mainScrollView, 45)
    .heightIs(NewLayoutHeightCGFloat(40))
    .topSpaceToView(noticeLabel, NewLayoutHeightCGFloat(20));
    
    _passwordTextField.sd_layout
    .leftSpaceToView(_mainScrollView, 45)
    .rightSpaceToView(_mainScrollView, 45)
    .heightIs(NewLayoutHeightCGFloat(40))
    .topSpaceToView(_usernameTextField, NewLayoutHeightCGFloat(25));
    
//    loginButton.sd_layout
//    .leftEqualToView(_usernameTextField)
//    .rightEqualToView(_usernameTextField)
//    .heightRatioToView(_usernameTextField, 1)
//    .topSpaceToView(_passwordTextField, NewLayoutHeightCGFloat(42));
    _otherTelTextField.sd_layout
    .leftSpaceToView(_mainScrollView, 45)
    .rightSpaceToView(_mainScrollView, 45)
    .heightIs(NewLayoutHeightCGFloat(40))
    .topSpaceToView(_passwordTextField, NewLayoutHeightCGFloat(25));
    
    
    newLoginButton.sd_layout
    .leftEqualToView(_usernameTextField)
    .rightEqualToView(_usernameTextField)
    .heightRatioToView(_usernameTextField, 1)
    .topSpaceToView(_passwordTextField, NewLayoutHeightCGFloat(25));
    
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
    
}



- (void)sendMsgCodeAction:(JKCountDownButton *)sender{
    if ([_usernameTextField.text length]<1) {
        [ProgressHUD showError:@"请输入手机号"];
        return;
    }
//    _getCodeBtn.hidden = YES;
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"sendValCodeToPhone",@"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"发送成功"];
        
        sender.enabled = NO;
        
        [sender startCountDownWithSecond:60];
        
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return @"点击重新获取";
            
        }];

        
        [_passwordTextField becomeFirstResponder];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
}

- (void)newLoginAction:(UIButton *)sender{
//    UserFirstLoginViewController *vc = [[UserFirstLoginViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    if ([_usernameTextField.text length]<1) {
        [ProgressHUD showError:@"请输入验证码"];
        return;
    }
    WEAKSELF;
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"validateChkPhone",@"chkNum":_passwordTextField.text,@"userid":[AppUserIndex GetInstance].role_id, @"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        UserPhoneInput2ViewController *vc = [[UserPhoneInput2ViewController alloc] init];
        vc.phoneNum1 = _usernameTextField.text;
        vc.showInfoDic = _showInfoDic;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        [AppUserIndex GetInstance].yanzhengPhoneArray = @[_usernameTextField.text];
        [ProgressHUD showSuccess:@"验证成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
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
