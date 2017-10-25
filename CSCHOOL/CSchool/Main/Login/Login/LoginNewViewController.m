//
//  LoginNewViewController.m
//  CSchool
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LoginNewViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MainTabBarViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <JSONKit.h>
#import "GTMBase64.h"
#import "BaseGMT.h"
#import "NetworkCore.h"
#import "Reachability.h"
#import "XGAlertView.h"
#import "KSNetRequest.h"
#import <JSONKit.h>
#import "UIView+SDAutoLayout.h"
#import "AboutUsViewController.h"
#import "SchoolModel.h"
//#import "hxButton.h"
//#import "baseView.h"
//#import "HxControl.h"
#import "UIButton+BackgroundColor.h"
#import "AppDelegate.h"
#import <YYModel.h>

//#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface LoginNewViewController ()<UITextFieldDelegate,XGAlertViewDelegate>
{
    UILabel *_schoolNameL;
    UILabel *_schooName;
    UILabel *_countNameL;
    UITextField *_countName;
    UILabel *_passWordL;
    UITextField *_passWord;
    UILabel *_checkNumL;
    UITextField *_checkNum;
    UIImageView *_checkImageV;
    UIButton *_loadImageBtn;
    UIButton *_checkInfoBtn;
    UILabel *_infoLabel;
    UIButton *_infoButton;
    UIButton *_loginBtn;
    //添加旋转提示框按钮
    UIActivityIndicatorView *checkActivityView;//正确的时候显示的按钮
}

@property(nonatomic,strong) UIButton *rightview;
@property(nonatomic,assign)BOOL checkImageRight;
@property(nonatomic,strong)UIActivityIndicatorView *activiteview;


@property(nonatomic,strong) NSDictionary *schoolIDDic;
@property(nonatomic,strong)NSDictionary *wifiDic;
@property(nonatomic,strong)NSDictionary *schoolIPDic;
@property(nonatomic,strong)NSDictionary *schoolCodeDic;
@property(nonatomic,strong)NSDictionary *schoolNameDic;
@property (strong, nonatomic) Reachability *reach;
@property(nonatomic,assign)BOOL checkRight;
@property (nonatomic,assign)NSInteger checkErrorNum;//验证码出错记数
@end
@implementation LoginNewViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取学校数据
    [self loadData];
    //加载验证码
//    [self loadImage];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self createUI];
    [self LoginNotification];
    //软件升级检测
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdate object:@"update"];
}

-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    //学校名称的Label
    _schoolNameL= ({
        _schoolNameL = [UILabel new];
        _schoolNameL.font = Title_Font;
        _schoolNameL.text = @"学校:";
        _schoolNameL.textColor = Color_Black;
        _schoolNameL.textAlignment = NSTextAlignmentCenter;
        _schoolNameL;
    });
    //学校名称
    _schooName = ({
        _schooName = [UILabel new];
        _schooName.font = Title_Font;
        _schooName.text = @"未连接网络";
        _schooName.textColor = Color_Black;
        _schooName.textAlignment = NSTextAlignmentLeft;
        _schooName;
    });
    //账户名称
    _countNameL = ({
        _countNameL = [UILabel new];
        _countNameL.font = Title_Font;
        _countNameL.text = @"账号:";
        _countNameL.textColor = Color_Black;
        _countNameL.textAlignment =NSTextAlignmentCenter;
        _countNameL;
    });
    //账户名输入框
    _countName = ({
        _countName = [UITextField new];
        
        _countName.layer.borderWidth = 1;
        _countName.layer.borderColor = Base_Color3.CGColor;
        _countName.font = Title_Font;
        _countName.placeholder = @" 请输入您的账号";
        _countName.delegate = self;
        _countName.textColor = Color_Black;
        //关闭首字母大写
        _countName.autocapitalizationType =  UITextAutocapitalizationTypeNone;
        _countName.clearButtonMode = UITextFieldViewModeAlways;
        _countName.returnKeyType = UIReturnKeyNext;
        _countName.autocorrectionType=UITextAutocorrectionTypeNo;
        
        _countName;
    });
    //密码
    _passWordL = ({
        _passWordL = [UILabel new];
        _passWordL.text = @"密码:";
        _passWordL.font = Title_Font;
        _passWordL.textColor = Color_Black;
        _passWordL.textAlignment = NSTextAlignmentCenter;
        _passWordL;
    
    });
    //密码输入框
    _passWord=({
        _passWord = [UITextField new];
        _passWord.font = Title_Font;
        _passWord.placeholder = @" 请输入您的密码";
        _passWord.delegate = self;
        _passWord.layer.borderWidth = 1;
        _passWord.layer.borderColor = Base_Color3.CGColor;
        _passWord.textColor = Color_Black;
        _passWord.clearButtonMode = UITextFieldViewModeAlways;
        _passWord.returnKeyType = UIReturnKeyNext;
        _passWord.secureTextEntry = YES;
        _passWord.autocorrectionType=UITextAutocorrectionTypeNo;
        _passWord;
    
    });
    
#ifdef isDEBUG
    _countName.text = @"201511101102";
    _passWord.text = @"666";
#endif
    
    //验证码
    _checkNumL = ({
        _checkNumL = [UILabel new];
        _checkNumL.font = Title_Font;
        _checkNumL.textAlignment = NSTextAlignmentCenter;
        _checkNumL.text = @"验证码:";
        _checkNumL.textColor = Color_Black;
        _checkNumL;
    });
    //验证码输入框
    _checkNum = ({
        _checkNum = [UITextField new];
        _checkNum.font = Title_Font;
        _checkNum.placeholder = @" 请输入验证码";
        _checkNum.clearButtonMode = UITextFieldViewModeAlways;
        _checkNum.keyboardType = UIKeyboardTypeASCIICapable;
        [_checkNum setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_checkNum setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _checkNum.delegate = self;
        _checkNum.returnKeyType = UIReturnKeyDone;
        _checkNum.layer.borderWidth = 1;
        _checkNum.layer.borderColor = Base_Color3.CGColor;
        _checkNum.textColor = Color_Black;
        _checkNum.autocorrectionType=UITextAutocorrectionTypeNo;
        _checkNum;
    });
    //登录按钮
    _loginBtn=({
//        _loginBtn= [[UIButton alloc] initWithFrame:CGRectMake(45, 230, self.view.bounds.size.width-90, LayoutHeightCGFloat(40))];
        _loginBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
        [_loginBtn .titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:Color_Hilighted forState:UIControlStateHighlighted];
        [_loginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        _loginBtn.layer.cornerRadius = 5;
        [_loginBtn addTarget:self action:@selector(LoginafterDelayAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn;
    });
    //是否同意协议按钮
    _checkInfoBtn=({
        _checkInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkInfoBtn.frame = CGRectMake(45, 232+LayoutHeightCGFloat(40), 15, 15);
        [_checkInfoBtn setBackgroundImage:[UIImage imageNamed:@"cs_select_no2"] forState:UIControlStateNormal];
        [_checkInfoBtn setBackgroundImage:[UIImage imageNamed:@"cs_select_yes1"] forState:UIControlStateSelected];
        [_checkInfoBtn addTarget:self action:@selector(checkButtonImageChange:) forControlEvents:UIControlEventTouchUpInside];
        _checkInfoBtn.selected = YES;
        _checkInfoBtn;
    });
    //
    _infoLabel = ({
        _infoLabel = [UILabel new];
        _infoLabel.text = @"我已阅读并了解使用协议";
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = Color_Black;
        _infoLabel;
    });
    //使用协议按钮
    _infoButton = ({
            _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setTitleColor:Title_Color1 forState:UIControlStateNormal] ;
        _infoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_infoButton setTitle:@"《使用协议》" forState:UIControlStateNormal];
        _infoButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_infoButton addTarget:self action:@selector(InfoAction) forControlEvents:UIControlEventTouchUpInside];
        _infoButton;
    });
   
        //切换验证码
    _loadImageBtn = ({
        _loadImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadImageBtn setTitle:@"看不清" forState:UIControlStateNormal];
        [_loadImageBtn setTitleColor:Title_Color1 forState:UIControlStateNormal];
        [_loadImageBtn setTitleColor:Base_Color3 forState:UIControlStateHighlighted];
        _loadImageBtn.titleLabel.font= [UIFont systemFontOfSize:13];
        [_loadImageBtn addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
        _loadImageBtn;
        
    });
    //验证码图片
    _checkImageV = ({
        _checkImageV = [UIImageView new];
        _checkImageV.backgroundColor = Base_Color3;
        _checkImageV;
    
    });
    _checkNum.hidden = YES;
    _checkNumL.hidden = YES;
    _checkImageV.hidden = YES;
    _loadImageBtn.hidden = YES;
    
    [self.view addSubview: _schoolNameL];
    [self.view addSubview:_schooName];
    [self.view addSubview:_countNameL];
    [self.view addSubview: _countName];
    [self.view addSubview:_passWordL];
    [self.view addSubview:_passWord];
    [self.view addSubview:_checkNumL];
    [self.view addSubview:_checkNum];
    [self.view addSubview:_checkImageV];
    [self.view addSubview:_loadImageBtn];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_checkInfoBtn];
    [self.view addSubview:_infoLabel];
    [self.view addSubview:_infoButton];

    
    //布局
    _schoolNameL.sd_layout.leftSpaceToView(self.view,15).topSpaceToView(self.view,30).widthIs(60).heightIs(30);
    _schooName.sd_layout.leftSpaceToView(_schoolNameL,10).topEqualToView(_schoolNameL).rightSpaceToView(self.view,15).heightIs(30);
    _countNameL.sd_layout.leftEqualToView(_schoolNameL).topSpaceToView(_schoolNameL,10).rightEqualToView(_schoolNameL).widthIs(60).heightIs(30);
    _countName.sd_layout.leftEqualToView(_schooName).topEqualToView(_countNameL).rightEqualToView(_schooName).heightIs(30);
    _passWordL.sd_layout.leftEqualToView(_schoolNameL).topSpaceToView(_countNameL,10).widthIs(60).heightIs(30);
    _passWord.sd_layout.leftEqualToView(_countName).topEqualToView(_passWordL).rightEqualToView(_countName).heightIs(30);
    _checkNumL.sd_layout.leftSpaceToView(self.view,20).topSpaceToView(_passWordL,10).widthIs(60).heightIs(30);
    _loadImageBtn.sd_layout.rightEqualToView(_passWord).topEqualToView(_checkNumL).widthIs(40).heightIs(30);
    _checkImageV.sd_layout.rightSpaceToView(_loadImageBtn,0).topEqualToView(_checkNumL).widthIs(60).heightIs(30);
    _checkNum.sd_layout.rightSpaceToView(_checkImageV,0).topEqualToView(_checkNumL).leftSpaceToView(_checkNumL,5).heightIs(30);
    _loginBtn.sd_layout.leftSpaceToView(self.view,(kScreenWidth-270)/2).widthIs(275).heightIs(LayoutHeightCGFloat(35)).topSpaceToView(_passWord,10);
    _checkInfoBtn.sd_layout.leftEqualToView(_loginBtn).widthIs(15).heightIs(15).topSpaceToView(_loginBtn,0);
    _infoLabel.sd_layout.leftSpaceToView(_checkInfoBtn,0).topEqualToView(_checkInfoBtn).widthIs(150).heightIs(15);
    _infoButton.sd_layout.leftSpaceToView(_infoLabel,-15).topEqualToView(_checkInfoBtn).heightIs(15).widthIs(90);
}
#pragma mark 数据处理
/**
 *  加载数据
 */
-(void)loadData{
    _schooName.text = _schoolName;

//    AppUserIndex *user = [AppUserIndex GetInstance];
//    NSString *rid = @"getSchoolInfo";
//    NSString *schVerNum = @"0";
//    NSDictionary *params = @{
//                             @"rid" : rid,
//                             @"schVerNum" : schVerNum,
//                             };
//    self.schoolIDDic = [NSMutableDictionary dictionary ];
//    self.wifiDic  = [NSMutableDictionary dictionary];
//    self.schoolIPDic = [NSMutableDictionary dictionary];
//    self.schoolCodeDic = [NSMutableDictionary dictionary];
//    self.schoolNameDic = [NSMutschoolCodeableDictionary dictionary];
//    [NetworkCore requestTarget:self POST:API_HOST parameters:params withVerKey:@"schoolVersion" success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        NSDictionary *dic = [responseObject objectForKey:@"data"];
//        NSArray *schoolInfo = [NSArray array];
//        schoolInfo = [dic objectForKey:@"schoolInfo"];
//        user.schoolCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolCode"];
//        for (NSDictionary *schoolDic in schoolInfo) {
//            SchoolModel *model = [[SchoolModel alloc]initWithDic:schoolDic];
//            if ([model.schoolCode isEqualToString:user.schoolCode]) {
//                user.schoolId = model.schoolId;
//                user.schoolName = model.schoolName;
//                user.API_URL = [NSString stringWithFormat:@"http://%@/index.php",model.serverIpAddress];
//                user.wifiName = model.wifiName;
//                [user saveToFile];
//                [self saveData];
//            }
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        
//        [ProgressHUD showError:@"无网络连接，请检查网络重试！"];
//}];
    
}
/**
 *  保存数据
 */
-(void)saveData
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    self.schoolID = user.schoolId;
    if (user.schoolName.length==0) {
        _schooName.text = @"未连接网络";
    }
    else{
        _schooName.text = user.schoolName;
    }
}

/**
 *加载验证码
 */
-(void)loadImage
{
    if (!self.activiteview) {
        self.activiteview = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_checkImageV.width/2, _checkImageV.height/2, _checkImageV.width/2, _checkImageV.height/2)];
        [self.activiteview setCenter:CGPointMake(_checkImageV.width/2, _checkImageV.height/2)];
        [self.activiteview setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.activiteview startAnimating];
        [self.activiteview setHidesWhenStopped:YES];
    }
    [_checkImageV addSubview:self.activiteview];
    AppUserIndex *app = [AppUserIndex GetInstance];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString *urlString = [NSString stringWithFormat:@"%@?rid=getChkNum&schoolCode=%@&clientOSType=ios&clientVerNum=%@",app.API_URL,app.schoolCode,[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data!=NULL) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            [_checkImageV performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            [self.activiteview performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            
        }
    });

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
    NSString *username =[NSString stringWithFormat:@"%@",_countName.text];
    NSString *password = [NSString stringWithFormat:@"%@",_passWord.text];
    
    NSDictionary *params = @{
                             @"rid" : rid,
                             @"username" :username,
                             @"password":password,
                             @"schoolId":_schoolID,
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
            _checkErrorNum++;
            _loginBtn.backgroundColor=Base_Color3;
            _loginBtn.enabled=NO;
            [ProgressHUD showError:msg];
            if (_checkErrorNum>2) {
                [self showCheckNum];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        _loginBtn.enabled=NO;
//        _loginBtn.backgroundColor=Base_Color3;
//        [checkActivityView stopAnimating];
//        checkActivityView.frame = CGRectMake(0, 0, 0, 0);
//        _checkNum.rightView = checkActivityView;
//        [checkActivityView removeFromSuperview];
//        [self loadImage];
//        _checkNum.text = @"";
//        _loginBtn.enabled=NO;
//        _loginBtn.backgroundColor=Base_Color3;
//        [ProgressHUD dismiss];
//        XGAlertView *errorAlert;
//        if (errorAlert) {
//            [errorAlert removeFromSuperview];
//        }
//        errorAlert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:[error objectForKey:@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:nil];
//        errorAlert.delegate = self;
//        [ProgressHUD dismiss];
//        [errorAlert show];
//        if ([error count]==0) {
//            [ProgressHUD showError:@"网络连接异常,请稍后重试!"];
//        }
        [ProgressHUD showError:error[@"msg"]];

        _checkErrorNum++;
        _loginBtn.backgroundColor=Base_Color3;
        _loginBtn.enabled=NO;
        if (_checkErrorNum>2) {
            [self showCheckNum];
            [self loadImage];
        }
    }];
}
-(void)showCheckNum
{
    _checkNum.hidden = NO;
    _checkNumL.hidden = NO;
    _checkImageV.hidden = NO;
    _loadImageBtn.hidden = NO;
    _loginBtn.sd_layout.leftSpaceToView(self.view,(kScreenWidth-270)/2).widthIs(275).heightIs(LayoutHeightCGFloat(35)).topSpaceToView(_checkNum,10);
//    _loginBtn.sd_layout.leftSpaceToView(self.view,(kScreenWidth-270)/2).widthIs(275).heightIs(LayoutHeightCGFloat(40)).topSpaceToView(_passWord,10);
    [_loginBtn updateLayout];
    //防止重复发送监听  只发送一次监听
    if (_checkErrorNum==3) {
        NSNotificationCenter *center= [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(TextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:_checkNum];
        [center addObserver:self selector:@selector(CheckNumChange) name:UITextFieldTextDidChangeNotification object:_checkNum];
    }
    [checkActivityView stopAnimating];
    checkActivityView.frame = CGRectMake(0, 0, 0, 0);
    _checkNum.rightView = checkActivityView;
    [checkActivityView removeFromSuperview];
    _checkNum.text = @"";
}
/*
 *获取用户信息
 */
-(void)queryUserInfo{

    [NetworkCore queryUserInfoWithName:_countName.text success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        //更新成功-----保存用户ID  密码
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:_countName.text forKey:@"accountId"];
//        [userDefaults setObject:_passWord.text forKey:@"pwd"];
        AppUserIndex *user = [AppUserIndex GetInstance];
//        user.accountId = _countName.text;
        user.passWord = _passWord.text;
        
        //验证成功  登陆-----
        [self getAppInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        _loginBtn.backgroundColor=Base_Color3;
        _loginBtn.enabled=NO;
        [self showCheckNum];
    }];
}

-(void)queryUserInfo1{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *username =[NSString stringWithFormat:@"%@",_countName.text];
    NSDictionary *userDic = @{
                              @"rid":@"queryUserInfo",
                              @"username":username,
                              };
    [NetworkCore requestPOST:user.API_URL parameters:userDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
        
        [user yy_modelSetWithDictionary:responseObject];

        NSArray *userArr = [responseObject objectForKey:@"roleInfo"];
        if (userArr.count!=0) {
            for (NSDictionary *dic in userArr) {
                user.role_type = [NSString stringWithFormat:@"%@",dic[@"ROLE_TYPE"]];
                if (dic[@"ROLE_ID"]) {
                    user.role_id =[NSString stringWithFormat:@"%@",dic[@"ROLE_ID"]];
//                    user.userName = [NSString stringWithFormat:@"%@",dic[@"ROLE_USERNAME"]];
                }
            }
        }

        NSDictionary *resDic = [responseObject objectForKey:@"data"];
        NSDictionary *userDic = [resDic objectForKey:@"samUserInfo"];
        user.schoolLogo = [[responseObject valueForKeyPath:@"schoolInfo.SDS_LOGO"] stringByReplacingOccurrencesOfString:@" " withString:@""];
        user.schoolLogonBackgroundImage = responseObject[@"schoolInfo"][@"SDS_BGIMAGE"];
        user.userName = [userDic objectForKey:@"userName"];
        user.packageName = [userDic  objectForKey:@"packageName"];
        user.accountFee = [userDic objectForKey:@"accountFee"];
        user.atName = [userDic objectForKey:@"atName"];
        user.accountId = [userDic objectForKey:@"accountId"];
        user.subAccountId = [userDic objectForKey:@"accountId"];
        user.policyId = [userDic objectForKey:@"policyId"];
        user.currentTime = [resDic objectForKey:@"serverCurrentTime"];
        user.isLogin = YES;
        user.userId= [userDic objectForKey:@"userId"];
        user.canPayNetFee = [[resDic objectForKey:@"canPayNetFee"] boolValue];
        user.canModifyPassword = [[resDic objectForKey:@"canModifyPassword"] boolValue];
        NSRange rangeTime = [[userDic objectForKey:@"nextBillingTime"] rangeOfString:@"T"];
        user.nextBillingTime = [[userDic objectForKey:@"nextBillingTime"] substringToIndex:rangeTime.location];
        //更新成功-----保存用户ID  密码
        user.passWord = _passWord.text;
        
        if ([responseObject objectForKey:@"uploadUrl"]) {
            user.uploadUrl = [responseObject objectForKey:@"uploadUrl"];
        }
        [user saveToFile];
        //验证成功  登陆-----
        [self getAppInfo];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        _loginBtn.backgroundColor=Base_Color3;
        _loginBtn.enabled=NO;
        [self showCheckNum];
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
/**
 *校验验证码
 */
- (void)checkImageNumber{
    //添加旋转提示框按钮
    if (!checkActivityView) {
        checkActivityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [checkActivityView setCenter:CGPointMake(_checkNum.rightView.width/2, _checkNum.rightView.height/2)];
        //设置进度轮显示类型
        [checkActivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [checkActivityView startAnimating];
        [checkActivityView setHidesWhenStopped:YES];
        
        _checkNum.rightView = checkActivityView;
        _checkNum.rightViewMode = UITextFieldViewModeAlways;
        [_checkNum addSubview:checkActivityView];
    }
    //验证验证码...
    NSString *check = [NSString stringWithFormat:@"%@",_checkNum.text];
    NSString *rid = @"validateChkNum";
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":rid,@"chkNum":check} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"0x000000"]) {
            [checkActivityView stopAnimating];
            [checkActivityView removeFromSuperview];
            [_checkNum resignFirstResponder];
            _rightview = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightview setImage:[UIImage imageNamed:@"cs_correctView"] forState:UIControlStateNormal];
            _rightview.frame = CGRectMake(0, 0, 30, 30);
            _checkNum.rightView = _rightview;
            _checkNum.rightViewMode = UITextFieldViewModeAlways;
            self.checkImageRight=YES;
            if (_countName.text.length == 0||_passWord.text.length == 0||!_checkInfoBtn.selected) {
                _loginBtn.backgroundColor = Base_Color3;
                _loginBtn.enabled = NO;
            }else{
                _loginBtn.enabled=YES;
                _loginBtn.backgroundColor=Base_Orange;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [checkActivityView stopAnimating];
        checkActivityView.frame = CGRectMake(0, 0, 0, 0);
        _checkNum.rightView = checkActivityView;
        [checkActivityView removeFromSuperview];
        _checkNum.text = @"";
        _loginBtn.enabled=NO;
        _loginBtn.backgroundColor=Base_Color3;
        if ([[error objectForKey:@"code"] isEqualToString:@"IndexController_class_0x00003300000"]) {
            XGAlertView *alert =[[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:error[@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:nil];
            [alert show];
        }else{
            XGAlertView *alert =[[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:[error objectForKey:@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:nil];
            [alert show];
        }
        [self loadImage];
    }];
}
#pragma mark 按钮点击方法
//按钮点击动画
-(void)LoginafterDelayAction:(UIButton *)sender
{
    [ProgressHUD show:@"登录中，请稍后..."];
    [self postCheckNum];
    //软件升级检测
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdate object:@"update"];
}
//是否同意协议点击方法
-(void)checkButtonImageChange:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [_checkInfoBtn setBackgroundImage:[UIImage imageNamed:@"cs_select_no2"] forState:UIControlStateNormal];
    }
    else{
        [_checkInfoBtn setBackgroundImage:[UIImage imageNamed:@"cs_select_yes1"] forState:UIControlStateNormal];
    }
}
//切换验证码点击方法
-(void)changeImage:(UIButton *)sender
{
    self.rightview.hidden=YES;
    self.rightview.frame = CGRectMake(0, 0, 0, 0);
    //变回初始化的错号
    _checkNum.rightView = _rightview;
    [self.activiteview  removeFromSuperview];
    _checkNum.text = @"";
    _loginBtn.enabled=NO;
    _loginBtn.backgroundColor=Base_Color3;
    //重新加载验证码
    [self loadImage];
}
/**
 *  使用协议按钮
 */
-(void)InfoAction
{
    AboutUsViewController *about = [[AboutUsViewController alloc]init];
    about.title = @"使用协议";
    about.baseUrl = WEB_URL_HELP(@"Register.html");
    about.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:about animated:YES];
}
#pragma mark 文本框监听
/**
 *确定登录的监听
 */
-(void)LoginNotification
{
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        //初始化时如果输入文本框的内容为空 则下一步的btn不可使用
//        if (_countName.text.length == 0||_passWord.text.length == 0||_checkNum.text.length<4||_checkInfoBtn.selected) {
//            _loginBtn.backgroundColor = Base_Color3;
//            _loginBtn.enabled = NO;
//        }
//
        //初始化时如果输入文本框的内容为空 则下一步的btn不可使用
        if (_countName.text.length == 0||_passWord.text.length == 0||_checkInfoBtn.selected) {
            _loginBtn.backgroundColor = Base_Color3;
            _loginBtn.enabled = NO;
        }
       
    //注册通知的方法监听三个文本输入框的值
    [center addObserver:self selector:@selector(TextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:_countName];
    [center addObserver:self selector:@selector(TextFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:_passWord];
    [_checkInfoBtn addTarget:self action:@selector(TextFieldDidChanged:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark 监听方法

/*
 *通知的方法监听文本框和选择按钮的状态的变化
 */
-(void)TextFieldDidChanged:(NSNotification *)notice
{
    if (!_checkNum.hidden) {
        if (_countName.text.length==0||_passWord.text.length==0||_checkNum.text.length<4||!_checkInfoBtn.selected) {
            _loginBtn.enabled = NO;
            _loginBtn.backgroundColor =Base_Color3;
        }else{
            _loginBtn.enabled = YES;
            _loginBtn.backgroundColor = Base_Orange;
        }
    }else{
    if (_countName.text.length==0||_passWord.text.length==0||!_checkInfoBtn.selected) {
        _loginBtn.enabled = NO;
        _loginBtn.backgroundColor =Base_Color3;
    }else{
        _loginBtn.enabled = YES;
        _loginBtn.backgroundColor = Base_Orange;
    }
    }
}
/**
 *验证码输入框为4位时验证验证码是否正确
 */
-(void)CheckNumChange{
    if (_checkNum.text.length==4) {
        [self checkImageNumber];
    }
}
#pragma 文本框代理textfielddelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==_countName) {
        [_countName resignFirstResponder];
        [_passWord becomeFirstResponder];
    }else if(textField==_passWord)
    {
        [_passWord resignFirstResponder];
        
    }else{
        [_checkNum resignFirstResponder];
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
