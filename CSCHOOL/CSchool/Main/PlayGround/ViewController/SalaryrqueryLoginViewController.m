//
//  SalaryrqueryLoginViewController.m
//  CSchool
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SalaryrqueryLoginViewController.h"
#import "UIView+SDAutoLayout.h"
#import "SalaryViewController.h"
#import "PlayGroundNewViewController.h"
#import "SalaryQueryFundViewController.h"
#import "UIButton+BackgroundColor.h"

@interface SalaryrqueryLoginViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIImageView *backgroundImageV;
@end

@implementation SalaryrqueryLoginViewController
{
    UIImageView *_firLabel;
    UITextField *_loginIdTextField;
    UITextField *_loginpasswordTextField;
    UIButton   *_loginBtn;
    //用户信息数组
    NSArray *_personInfoArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[SalaryViewController  class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;    // 下面两个属性的设置是与translucent为NO,坐标变换的效果一样
    self.navigationItem.title = @"工资查询";
    [self createView];
}
-(void)createView
{

    _backgroundImageV = ({
        UIImageView *view = [UIImageView new];
        [view setImage:[UIImage imageNamed:@"salaryBackImage-2.jpg"]];
        view;
    });
    _firLabel = ({
        UIImageView *view = [UIImageView new];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.image = [UIImage imageNamed:@"salaryTitle1"];
        view;
    });
   
    _loginIdTextField = ({
        UITextField *view = [UITextField new];
        view.backgroundColor = RGB_Alpha(255, 255, 255, 0.26);
        view.clearButtonMode =UITextFieldViewModeWhileEditing;
        view.delegate = self;
        view.tag = 1000;
        view;
    });
    _loginpasswordTextField = ({
        UITextField *view = [UITextField new];
        view.backgroundColor = RGB_Alpha(255, 255, 255, 0.26);
        view.clearButtonMode =UITextFieldViewModeWhileEditing;
        view.secureTextEntry = YES;
        view.delegate = self;
        view.tag = 1001;
        view;
    });
    _loginBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"一键绑定" forState:UIControlStateNormal];
        [view setBackgroundColor:Color_Hilighted forState:UIControlStateHighlighted];
        [view addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [_scrollView addSubview:_backgroundImageV];
    [_scrollView addSubview:_firLabel];
    [_scrollView addSubview:_loginIdTextField];
    [_scrollView addSubview:_loginpasswordTextField];
    [_scrollView addSubview:_loginBtn];
    
    
    _backgroundImageV.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,0).bottomSpaceToView(_scrollView,0);
    
    _firLabel.sd_layout.leftSpaceToView(_scrollView,60).topSpaceToView(_scrollView,75).rightSpaceToView(_scrollView,50).heightIs(60);
   
    
    _loginIdTextField.sd_layout.leftSpaceToView(_scrollView,60).topSpaceToView(_firLabel,50).rightSpaceToView(_scrollView,40).heightIs(40);
    _loginpasswordTextField.sd_layout.leftEqualToView(_loginIdTextField).topSpaceToView(_loginIdTextField,15).rightEqualToView(_loginIdTextField).heightIs(40);
    _loginBtn.sd_layout.leftEqualToView(_loginIdTextField).heightIs(40).topSpaceToView(_loginpasswordTextField,30).rightEqualToView(_loginIdTextField);
    
    //设置textfield的leftView
    UIImageView *imageViewName=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 10, 30, 30)];
    imageViewName.image=[UIImage imageNamed:@"salaryLogin1"];
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(-20, 10, 30, 30)];
    imageViewPwd.image=[UIImage imageNamed:@"salaryPassword1"];
    
    _loginIdTextField.leftView=imageViewName;
    _loginIdTextField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _loginIdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _loginpasswordTextField.leftView=imageViewPwd;
    _loginpasswordTextField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _loginpasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    NSMutableParagraphStyle *style = [_loginIdTextField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = _loginIdTextField.font.lineHeight - (_loginIdTextField.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) /2.0;
    
    _loginIdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的财务工资号"
                                                                            attributes:@{
                                                                                         NSForegroundColorAttributeName: [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:1.0f],
                                                                                         NSFontAttributeName : [UIFont systemFontOfSize:13.0],
                                                                                         NSParagraphStyleAttributeName : style
                                                                                         }
                                             ];
    _loginpasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的财务工资查询密码"
                                                                              attributes:@{
                                                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:1.0f],
                                                                                           NSFontAttributeName : [UIFont systemFontOfSize:13.0],
                                                                                           NSParagraphStyleAttributeName : style
                                                                                           }
                                                     ];
    [self LoginNotification];

}

/**
 *  登录
 *
 *  @param sender 。
 */
-(void)loginAction:(UIButton *)sender
{
    _personInfoArr = [NSArray array];
    [_loginIdTextField resignFirstResponder];
    [_loginpasswordTextField resignFirstResponder];
    AppUserIndex *user = [AppUserIndex GetInstance];
    if (_loginIdTextField.text.length==0||_loginpasswordTextField.text.length==0) {
        [ProgressHUD showError:@"请输入完整信息"];
    }else
    {
        [ProgressHUD show:@"正在验证账户信息..."];
        [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"validateUserInfo",@"userid":_loginIdTextField.text,@"password":_loginpasswordTextField.text} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            _personInfoArr = [responseObject objectForKey:@"data"];
            user.salaryUserName = _loginIdTextField.text;
            user.salaryPWD = _loginpasswordTextField.text;
            [user setValue:_personInfoArr forKey:@"salaryUserInfoArr"];
            [user saveToFile];
            [self openSalaryPersonInfo];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD dismiss];
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"用户信息验证失败,请稍候重试!" WithCancelButtonTitle:@"确定" withOtherButton:nil];
            [alert show];
            
        }];
    }
}
#pragma mark 私有方法
/**
 *确定登录的监听
 */
-(void)LoginNotification
{
    //初始化时如果输入文本框的内容为空 则下一步的btn不可使用
    if (_loginIdTextField.text.length == 0||_loginpasswordTextField.text.length == 0) {
        _loginBtn.backgroundColor = Base_Color3;
        _loginBtn.enabled = NO;
    }
    //注册通知的方法监听三个文本输入框的值
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(TextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:_loginpasswordTextField];
    [center addObserver:self selector:@selector(TextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:_loginIdTextField];
    
    
}
-(void)TextFieldDidChanged:(NSNotification *)notifi
{
    if (_loginIdTextField.text.length==0||_loginpasswordTextField.text.length==0) {
        _loginBtn.enabled = NO;
        _loginBtn.backgroundColor =Base_Color3;
    }else{
        _loginBtn.enabled = YES;
        _loginBtn.backgroundColor = Base_Orange;
    }

}
-(void)openSalaryPersonInfo
{
    SalaryViewController *vc = [[SalaryViewController alloc ]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma 文本框代理textfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==1000) {
        [_loginIdTextField resignFirstResponder];
        [_loginpasswordTextField  becomeFirstResponder];
    }else if(textField.tag==1001)
    {
        [_loginpasswordTextField resignFirstResponder];
    }
    return YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
