//
//  ChangePassWordViewController.m
//  CSchool
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "UIView+SDAutoLayout.h"
@interface ChangePassWordViewController ()<XGAlertViewDelegate,UITextFieldDelegate>

@end

@implementation ChangePassWordViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    //创建UI
    [self createUI];
    //文本框监听
    [self ChangePassWordNotification];

}
#pragma mark UI界面
/**
 *  UI布局
 */
-(void)createUI
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    oldKeyLabel =({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"旧密码:";
        view.textColor = Color_Black;
        view;
    
    });
    fNewLabel =({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"新密码:";
        view.textColor = Color_Black;
        view;
        
    });
    sNewLabel =({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"确认密码:";
        view.textColor = Color_Black;
        view;
        
    });


    oldKeyTextField = ({
        UITextField *view = [UITextField new];
        view.returnKeyType = UIReturnKeyNext;
        view.delegate = self;
        view.placeholder = @" 请输入您的密码";
        view.font= Title_Font;
        view.layer.borderWidth = 1;
        view.clearButtonMode = UITextFieldViewModeAlways;
        view.layer.borderColor = Base_Color3.CGColor;
        view.secureTextEntry = YES;
        [self setTextFieldLeftPadding:view forWidth:5];
        view;
    });
    fNewKeyTextField = ({
        UITextField *view = [UITextField new];
        view.returnKeyType = UIReturnKeyNext;
        view.placeholder = @"请输入您的新密码";
        view.delegate =self;
        view.font= Title_Font;
        view.layer.borderWidth = 1;
        view.clearButtonMode = UITextFieldViewModeAlways;
        view.layer.borderColor = Base_Color3.CGColor;
        view.secureTextEntry = YES;
        [self setTextFieldLeftPadding:view forWidth:5];
        view;
    });
    sNewKeyTextField = ({
        UITextField *view = [UITextField new];
        view.returnKeyType = UIReturnKeyDone;
        view.placeholder = @"请再次输入您的新密码";
        view.delegate =self;
        view.font= Title_Font;
        view.layer.borderWidth = 1;
        view.clearButtonMode = UITextFieldViewModeAlways;
        view.layer.borderColor = Base_Color3.CGColor;
        view.secureTextEntry = YES;
        [self setTextFieldLeftPadding:view forWidth:5];
        view;
        
    });

    
    _isChangeButton = ({
        UIButton *view= [[UIButton alloc] initWithFrame:CGRectMake(45, 250, backView.bounds.size.width-90, LayoutHeightCGFloat(40))];
        [view setTitle:@"修改密码" forState:UIControlStateNormal];
        [view.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        [view addTarget:self action:@selector(afterDelayAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    
    });
    
    [self.view addSubview:backView];
    [backView addSubview:oldKeyTextField];
    [backView addSubview:fNewKeyTextField];
    [backView addSubview:sNewKeyTextField];
    [backView addSubview:oldKeyLabel];
    [backView addSubview:sNewLabel];
    [backView addSubview:fNewLabel];
    [backView addSubview:self.isChangeButton];
    
    oldKeyLabel.sd_layout.
    topSpaceToView(backView,25).
    leftSpaceToView(backView,15).
    widthIs(50).
    heightIs(LayoutHeightCGFloat(30));
    
    fNewLabel.sd_layout.
    leftEqualToView(oldKeyLabel).
    topSpaceToView(oldKeyLabel,20).
    widthIs(50).
    heightIs(LayoutHeightCGFloat(30));

    sNewLabel.sd_layout.
    leftEqualToView(oldKeyLabel).
    topSpaceToView(fNewLabel,20).
    widthIs(60).
    heightIs(LayoutHeightCGFloat(30));
    
    oldKeyTextField.sd_layout.
    topSpaceToView(backView,25).
    leftSpaceToView(oldKeyLabel,15).
    rightSpaceToView(backView,15).
    heightIs(LayoutHeightCGFloat(30));
    
    
    fNewKeyTextField.sd_layout.
    topSpaceToView(oldKeyTextField,20).
    leftEqualToView(oldKeyTextField).
    rightEqualToView(oldKeyTextField).
    heightIs(LayoutHeightCGFloat(30));
    
    sNewKeyTextField.sd_layout.
    topSpaceToView(fNewKeyTextField,20).
    leftEqualToView(oldKeyTextField).
    rightEqualToView(oldKeyTextField).
    heightIs(LayoutHeightCGFloat(30));
    
//    _isChangeButton.sd_layout.
//    topSpaceToView(sNewKeyTextField,90).
//    leftSpaceToView(backView,43).
//    rightSpaceToView(backView,43).
//    heightIs(LayoutHeightCGFloat(40));


}
-(void)afterDelayAction:(UIButton *)sender
{
//    [_isChangeButton startLoading];
    [self performSelector:@selector(changePassWord) withObject:nil afterDelay:1.5];
}

#pragma mark 文本框监听事件
-(void)ChangePassWordNotification
{
    //初始化时如果输入文本框的内容为空 则下一步的btn不可使用
    if (oldKeyTextField.text.length == 0||fNewKeyTextField.text.length == 0||sNewKeyTextField.text.length==0) {
        _isChangeButton.backgroundColor = Base_Color3;
        _isChangeButton.enabled = NO;
    }
    //注册通知的方法监听三个文本输入框的值
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(CTextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:oldKeyTextField];
    [center addObserver:self selector:@selector(CTextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:fNewKeyTextField];
    [center addObserver:self selector:@selector(CTextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:sNewKeyTextField];
    
}
#pragma mark 监听方法

/**
 *通知的方法监听文本框和选择按钮的状态的变化
 */
-(void)CTextFieldDidChanged:(NSNotification *)notice
{
    if (oldKeyTextField.text.length==0||fNewKeyTextField.text.length==0||sNewKeyTextField.text.length==0) {
        _isChangeButton.enabled = NO;
        _isChangeButton.backgroundColor = Base_Color3;
    }else{
        _isChangeButton.enabled = YES;
        _isChangeButton.backgroundColor = Base_Orange;
    }
}

#pragma mark 修改密码点击事件
/**
 *  修改密码点击事件
 */
-(void)changePassWord
{
//    [_isChangeButton stopLoading];
    _isChangeButton.enabled = YES;
    [self.view endEditing:YES];
    AppUserIndex *user = [AppUserIndex GetInstance];
    if (oldKeyTextField.text.length==0) {
        [self showErrorMessage:@"请输入旧密码!"];
        return;
        
    }else if(sNewKeyTextField.text.length==0&&fNewKeyTextField.text.length==0){
        [self showErrorMessage:@"请输入新密码!"];
        return;
    
    }else if(![fNewKeyTextField.text isEqualToString:sNewKeyTextField.text]){
        [self showErrorMessage:@"两次新密码输入不一致,请重新输入!"];
        return;
    }else if ([fNewKeyTextField.text isEqualToString:oldKeyTextField.text]){
        [self showErrorMessage:@"新密码与旧密码一致，请更换新密码！"];
        return;
    
    }else if (sNewKeyTextField.text.length<3)
    {
        [self showErrorMessage:@"新密码长度必须大于3位"];
        return;
    }
    [NetworkCore requestPOST:user.API_URL parameters:@{@"userid":user.userId,@"oldpassword":oldKeyTextField.text,@"newpassword":sNewKeyTextField.text,@"schoolCode":user.schoolCode,@"rid":@"updateUserPassword"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",[responseObject objectForKey:@"msg"]);
                XGAlertView *successAlert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"密码修改成功!" WithCancelButtonTitle:@"登陆" withOtherButton:nil];
        successAlert.delegate = self;
        successAlert.tag = 1000;
        successAlert.isBackClick = YES;
        [successAlert show];;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
        XGAlertView *failAlert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:[error objectForKey:@"msg"] WithCancelButtonTitle:@"重试" withOtherButton:@"取消"];
        failAlert.delegate = self;
        failAlert.tag = 1001;
        [failAlert show];
    }];
}
/**
 *  显示错误信息
 *
 *  @param message 错误信息
 */
-(void)showErrorMessage:(NSString *)message
{
    XGAlertView *failAlert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:message WithCancelButtonTitle:@"确定" withOtherButton:nil];
    [failAlert show];
}


/**
 *  注销
 */
-(void)LogoutToNet{
    
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *logoutUrl = user.LogoutURL;
    NSString *EpUrl = user.epurl;
    if (logoutUrl==NULL) {
        [NetworkCore requestNormalGET:@"http://www.baidu.com" parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
        NSString *backData = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if (backData.length==0) {
                [ProgressHUD dismiss];
                return ;
            }
            NSString *jap = @"<title>百度一下,你就知道</title>";
            NSRange foundObj=[backData rangeOfString:jap options:NSCaseInsensitiveSearch];
            if (foundObj.length>0) {
                
            }else{
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            
            [ProgressHUD showError:@"断开网络失败"];
            
        }];
        
    }
    else{
        //截取字符串---单利传值  ----
        logoutUrl =[EpUrl stringByReplacingOccurrencesOfString:@"index.jsp?" withString:logoutUrl];
        NSRange start = [logoutUrl rangeOfString:@"http://"];
        NSRange end = [logoutUrl rangeOfString:@"wlanuserip"];
        if ((start.location&&end.location)!=NSNotFound) {
            if (logoutUrl) {
                logoutUrl = [logoutUrl substringWithRange:NSMakeRange(start.location, end.location-start.location)];
            }
            [NetworkCore requestGET:logoutUrl parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                
                [ProgressHUD dismiss];
                XGAlertView *Logoutalert = [[XGAlertView alloc]initWithTarget:self withTitle:@"请重新登录" withContent:@"" WithCancelButtonTitle:@"确定" withOtherButton:nil];
                
                [Logoutalert show];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                
            }];

        }else{
            [ProgressHUD dismiss];
            XGAlertView *Logoutalert = [[XGAlertView alloc]initWithTarget:self withTitle:@"请重新登录" withContent:@"" WithCancelButtonTitle:@"确定" withOtherButton:nil];            
            [Logoutalert show];
        }
    }
    
}
#pragma mark UITextField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==oldKeyTextField) {
        [fNewKeyTextField becomeFirstResponder];
        [oldKeyTextField resignFirstResponder];
    }else if (textField==fNewKeyTextField)
    {
        [sNewKeyTextField becomeFirstResponder];
        [fNewKeyTextField resignFirstResponder];

    }else{
        [sNewKeyTextField resignFirstResponder];
        [self changePassWord];
    
    }
    return YES;
}
/**
 *  修改文本框的文字做编辑
 *
 *  @param textField 文本框
 *  @param leftWidth 左边距
 */
-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}


#pragma mark XGAlertViewDelegate
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    switch (view.tag) {
        case 1000:
        {
             NSArray *animationArr = @[kCATransitionFade,kCATransitionPush,kCATransitionReveal,kCATransitionMoveIn,@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"];
            NSArray *directionArr = @[kCATransitionFromLeft,kCATransitionFromBottom,kCATransitionFromRight,kCATransitionFromTop];
            int i = arc4random()%animationArr.count;
            int j = arc4random()%directionArr.count;
            
            [self transitionWithType:animationArr[i] WithSubtype:directionArr[j] ForView:self.view];

            [self removeFromParentViewController];
            [self LogoutToNet];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
            }
            break;
            case 1001:
        {
            [self changePassWord];
        }
            
        default:
            break;
    }

}
#pragma CATransition动画实现
- (void)transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = 0.9f;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}
#pragma UIView实现动画
- (void) animationWithView : (UIView *)view WithAnimationTransition : (UIViewAnimationTransition) transition
{
    [UIView animateWithDuration:0.7f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
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
