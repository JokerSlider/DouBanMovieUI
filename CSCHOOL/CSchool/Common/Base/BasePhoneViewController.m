//
//  BasePhoneViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/8/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BasePhoneViewController.h"
#import "SDAutoLayout.h"
#import <UIImageView+WebCache.h>
#import "LoginTextField.h"
#import "UserFirstLoginViewController.h"
#import "UserPhoneInput2ViewController.h"
#import "JKCountDownButton.h"
#import "ConfigObject.h"
#import "PaySelectViewController.h"

@interface BasePhoneViewController ()
{
    JKCountDownButton *_countDownCode;
}
@property (nonatomic, retain) UIScrollView *mainScrollView;

@property (nonatomic, retain) LoginTextField *usernameTextField;
@property (nonatomic, retain) LoginTextField *passwordTextField;
@property (nonatomic, retain) UIButton *getCodeBtn;

@property (nonatomic, strong) NSDictionary *showInfoDic; //存放展示提示文字内容

@end

@implementation BasePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手机验证";
    self.view.backgroundColor = Base_Orange;
    
    [self createViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPhone:)];
//    self.navigationItem.rightBarButtonItem = leftItem1;
}

- (void)cancelPhone:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPayInfo{
    NSString *key = [NSString stringWithFormat:@"%@-oder",[AppUserIndex GetInstance].role_id];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:key]);
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        NSTimeInterval time1 = [dic[@"time"] doubleValue];
        NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval time = timeNow - time1;
        
        if ((time/86400)<3) {
            NSLog(@"小于三天");
            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"近期您已购买过上网套餐，请确认后购买！" WithCancelButtonTitle:@"确定" withOtherButton:nil];
            alert.tag = 3003;
            alert.delegate = self;
            [alert show];
        }
    }
    
}

- (void)createViews{
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.backgroundColor = RGB(245, 245, 245);
    
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newLogin_bg"]];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    switch (_phoneType) {
        case XGPayPhone:{
          
            noticeLabel.text = [ConfigObject shareConfig].trip1;;
            [self showPayInfo];
        }
            break;
        case XGChangePhone:
            noticeLabel.text = [ConfigObject shareConfig].trip2;
            break;
        default:
            break;
    }
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
        sender.userInteractionEnabled = NO;
        [weakSelf sendMsgCodeAction:sender];
        
    }];
    
    
    
    _countDownCode.sd_layout
    .rightSpaceToView(_passwordTextField, 0)
    .topSpaceToView(_passwordTextField, 0)
    .heightRatioToView(_passwordTextField, 1)
    .widthIs(100);
    
    UIButton *newLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [newLoginButton setTitle:@"完 成" forState:UIControlStateNormal];
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

- (void)alertView:(XGAlertView *)view didClickIdCode:(NSString *)idCode{
    [ConfigObject shareConfig].msgCodeNum = 1;
    [self sendMsgCodeAction:_countDownCode];
}

- (void)sendMsgCodeAction:(JKCountDownButton *)sender{
    if ([_usernameTextField.text length]<1) {
        [ProgressHUD showError:@"请输入手机号"];
        return;
    }
    [ConfigObject shareConfig].msgCodeNum++;
    
    if ( [ConfigObject shareConfig].msgCodeNum > 2) {
        XGAlertView *alert  = [[XGAlertView alloc]initWithTarget:self withIdCode:@""];
        alert.tag = 3101;
        [alert show];
        return;
    }
    
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"sendSmsVerificationCode",@"userid":[AppUserIndex GetInstance].role_id,@"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"发送成功"];
        
        sender.userInteractionEnabled = NO;
        
        [sender startCountDownWithSecond:60];
        
        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            return title;
        }];
        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
            sender.userInteractionEnabled = YES;
            return @"点击重新获取";
            
        }];
        
        
        [_passwordTextField becomeFirstResponder];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        [ProgressHUD showError:error[@"msg"]];
        if ([error[@"code"] isEqualToString:@"CcpRestController_class_0x000123400000"]) {
            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:error[@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            alert.tag = 3001;
            alert.delegate = self;
            [alert show];
        }else if ([error[@"code"] isEqualToString:@"CcpRestController_class_0x000123600000"]) {
//            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:error[@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
//            alert.tag = 3003;
//            alert.delegate = self;
//            [alert show];
            [ProgressHUD dismiss];
            WEAKSELF;
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:error[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
               sender.userInteractionEnabled = YES;
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               
                [ProgressHUD show:nil];
                [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"bindingNewStudentPhone", @"userid":[AppUserIndex GetInstance].role_id, @"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                    [weakSelf sendMsgCodeAction:_countDownCode];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                    ;
                }];
            }];
            
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:^{
                //do nothing
            }];
            
        
        }else{
            sender.userInteractionEnabled = YES;
        }
    }];
    
}

- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    WEAKSELF;
    if (view.tag == 3001) {
        [ProgressHUD show:nil];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"bindingNewPhone", @"userid":[AppUserIndex GetInstance].role_id, @"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [weakSelf sendMsgCodeAction:_countDownCode];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            ;
        }];
    }else if (view.tag == 3002){
        PaySelectViewController *vc = [[PaySelectViewController alloc] init];
        [ConfigObject shareConfig].phoneNum = _usernameTextField.text;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }else if (view.tag == 3003) {
        [ProgressHUD show:nil];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"bindingNewStudentPhone", @"userid":[AppUserIndex GetInstance].role_id, @"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [weakSelf sendMsgCodeAction:_countDownCode];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            ;
        }];
    }
}

- (void)newLoginAction:(UIButton *)sender{
    //    UserFirstLoginViewController *vc = [[UserFirstLoginViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
//    PaySelectViewController *vc = [[PaySelectViewController alloc] init];
//    [ConfigObject shareConfig].phoneNum = _usernameTextField.text;
//    [self.navigationController pushViewController:vc animated:YES];
    
    if ([_usernameTextField.text length]<1) {
        [ProgressHUD showError:@"请输入验证码"];
        return;
    }
    WEAKSELF;
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"checkSmsVerificationCode",@"chkNum":_passwordTextField.text,@"userid":[AppUserIndex GetInstance].role_id, @"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //        [weakSelf savePhoneNum];
//        [ProgressHUD showSuccess:@"验证完成"];
        
        switch (_phoneType) {
            case XGPayPhone:{
//                [ProgressHUD dismiss];
//                XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:responseObject[@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:nil];
//                alert.tag = 3002;
//                alert.delegate = self;
//                [alert show];
                PaySelectViewController *vc = [[PaySelectViewController alloc] init];
                [ConfigObject shareConfig].phoneNum = _usernameTextField.text;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case XGChangePhone:{
                [weakSelf postPayChangeInfo];
            }
                break;
            default:
                break;
        }
        
//        [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
}

- (void)postPayChangeInfo{
    WEAKSELF;
//    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"updateUserPakageName", @"phone":_usernameTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];

        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [ConfigObject shareConfig].isShowChangePhone = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}

@end
