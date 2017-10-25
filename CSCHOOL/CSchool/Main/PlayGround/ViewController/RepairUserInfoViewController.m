//
//  RepairUserInfoViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/7.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "RepairUserInfoViewController.h"
#import "IdCodeView.h"
#import "PlayGroundNewViewController.h"
#import "RepairListTableViewCell.h"
#import "RepairListViewController.h"
#import "XGAlertView.h"
#import "ValidateObject.h"

@interface RepairUserInfoViewController ()<IdCodeViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTelTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet IdCodeView *idCodeView;

@property (nonatomic, assign) BOOL isCorrectCode; //是否为正确的验证码
@end

@implementation RepairUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"填写报修人信息";
    
    _submitBtn.layer.cornerRadius = 5;
    _submitBtn.userInteractionEnabled = NO;

    _userNameTextField.text = [AppUserIndex GetInstance].repairName;
    _userTelTextField.text = [AppUserIndex GetInstance].repairPhoneNum;
    
    //注册通知的方法监听三个文本输入框的值
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.userNameTextField];
    [center addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.userTelTextField];
    [center addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.smsCodeTextField];
    
    _idCodeView.notAuto = YES;
    _idCodeView.delegate = self;
    
    if (_repairModel) {
        _userNameTextField.text = _repairModel.username;
        _userTelTextField.text = _repairModel.repairPhone;
    }
}

/**
 *  提交表单信息
 *
 *  @param sender
 */
- (IBAction)submitAction:(UIButton *)sender {
    
//    if ([_userTelTextField.text length] != 11) {
    if (![ValidateObject validateMobile:_userTelTextField.text]) {

        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"手机号码不合法!" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *commitDic = [NSMutableDictionary dictionaryWithDictionary:_repairInfoDic];
    [commitDic setObject: _userNameTextField.text forKey:@"faultContact"];
    [commitDic setObject: _userTelTextField.text forKey:@"faultPhone"];
    [commitDic setObject:[AppUserIndex GetInstance].accountId forKey:@"stuNo"];
    
    if (!_repairModel) {
        [commitDic setObject:@"saveRepair" forKey:@"rid"];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            DLog(@"%@",responseObject);
            [AppUserIndex GetInstance].repairName = _userNameTextField.text;
            [AppUserIndex GetInstance].repairPhoneNum = _userTelTextField.text;
            [[AppUserIndex GetInstance] saveToFile];
            [ProgressHUD showSuccess:@"提交成功"];
            //提交成功跳转到保修列表
//            RepairListViewController *vc = [[RepairListViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.tabBarController.hidesBottomBarWhenPushed = YES;
//            vc.isRepair = YES;
////            [self performSelector:@selector(pushViewController:animated:) withObject:self afterDelay:2];
//            [self.navigationController pushViewController:vc animated:YES];
            [self performSelector:@selector(afterPush) withObject:self afterDelay:1.0f];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            ;
        }];
    }else{
        [commitDic setObject:@"editRepairInfo" forKey:@"rid"];
        [commitDic setObject:_repairModel.keyId forKey:@"repairId"];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD showSuccess:@"修改成功"];
            //修改成功，在导航堆栈中找到RepairListViewController这个控制器，pop回去。
            [self performSelector:@selector(afterPop) withObject:self afterDelay:1.0f];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            ;
        }];
    }
    
}

- (void)afterPush{
    RepairListViewController *vc = [[RepairListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tabBarController.hidesBottomBarWhenPushed = YES;
    vc.isRepair = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)afterPop{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc class] == [RepairListViewController class]) {
            //                    [self performSelector:@selector(nilSymbol) withObject:self afterDelay:2];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)alertTextFieldDidChange:(NSNotification *)notice{
    _userTelTextField.text = [_userTelTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _userNameTextField.text = [_userNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([_userTelTextField.text length] == 0 ||[_userNameTextField.text length]==0 || !_isCorrectCode) {
        _submitBtn.backgroundColor = Base_Color3;
        _submitBtn.userInteractionEnabled = NO;
    }else{
        _submitBtn.backgroundColor = Base_Orange;
        _submitBtn.userInteractionEnabled = YES;
    }
}

#pragma mark IdCodeViewDelegate
- (void)idCodeView:(IdCodeView *)view didInputSuccessCode:(NSString *)idCode{
    _isCorrectCode = YES;
    [self alertTextFieldDidChange:nil];
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
