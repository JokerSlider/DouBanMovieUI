//
//  PlayGroundViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "PlayGroundViewController.h"
#import "KSNetRequest.h"
#import <AFNetworking.h>
#import "PaySelectViewController.h"
#import "HWWeakTimer.h"
#import "XGAlertView.h"
#import "ZWAdView.h"
#import "FL_Button.h"
#import "LoginNewViewController.h"
#import "Reachability.h"
#import "AppUserIndex.h"
#import "CallRepairViewController.h"
#import "LoginoneViewController.h"
#import "NSDate+Extension.h"
#import "GDScrollBanner.h"
#import "ConfigObject.h"
#import "AboutUsViewController.h"
#import "UIView+SDAutoLayout.h"
#import "PlayGroundNewViewController.h"
@interface PlayGroundViewController ()<ZWAdViewDelagate,UITableViewDataSource,UITableViewDelegate,XGAlertViewDelegate>
@property(nonatomic,strong)ZWAdView *adView;
//新闻数据
@property(nonatomic,strong)NSArray *newsArr;
//一键上网
@property(nonatomic,strong)UIButton *loginButton;
//学号
@property(nonatomic,strong)UILabel *NameLabel;
//套餐
@property(nonatomic,strong)UILabel *CountLabel;
////时长
//@property(nonatomic,strong)UILabel *TimeLabel;
//续费
@property(nonatomic,strong)UIButton *ContinuepayButton;
//缴费
@property(nonatomic,strong)UIButton *payButton;
//报修
@property(nonatomic,strong)UIButton *repairButton;
//新闻
@property(nonatomic,strong)UITableView *newsTabview;

@property(nonatomic,strong)UILabel *loginLabel;

//账户姓名
@property(nonatomic,strong)UILabel *StunameLabel;
//账户套餐
@property(nonatomic,strong)UILabel *StucountLabel;
////套餐时长
//@property(nonatomic,strong)UILabel *StutimeLabel;

//开通套餐按钮
@property(nonatomic,strong)UIButton *estBtn;

@property(nonatomic,strong)NSString *imageUrl;

//第一块视图
@property(nonatomic,strong) UIView *oneView;

@property(nonatomic,strong)UIView *twoView;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *pwd;
@property(nonatomic,strong) NSDictionary *userDicInfo;
@property (strong, nonatomic) Reachability *reach;
@property(nonatomic,strong)NSMutableArray *imageArr;

@end


@implementation PlayGroundViewController
{
    NSTimer *_myTimer;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    //验证过期时间
    [self tokenTime];
    //获取用户信息
    [self queryUserInfoP];
    //开启
    [self StartTimer];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self StopTimer];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //从xib加载时
    self.hidden.hidden = YES;

    self.checkNet = NO;
    //加载数据
    [self initData];
    //轮播图和UI界面
    [self addUI];
    //获取轮播图数据
    [self loadImageData];
    //注销通知  停止时间计时器
    [self NotiftierLogout];
    //测试网络连接  开启通知runloop
    [self testInNet];
    //获取服务器配置信息
    [self getConfig];
    //创建nstimer
    [self Nstimer];

}
/*
 *UI界面
 */
-(void)addUI{
    self.view.backgroundColor = Base_Color3;
    //设置广告图片
    self.adView=[[ZWAdView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , LayoutHeightCGFloat(240))];
    self.adView.delegate=self;
    NSArray *imageArray;
    if (self.imageArr.count==0) {
        imageArray=@[@""];
        
    }else{
        imageArray =self.imageArr;
        
    }
    self.adView.adDataArray=[NSMutableArray arrayWithArray:imageArray];
    self.adView.pageControlPosition=ZWPageControlPosition_BottomCenter;/**设置圆点的位置*/
    self.adView.hidePageControl=NO;/**设置圆点是否隐藏*/
    self.adView.adAutoplay=YES;/**自动播放是否开启*/
    self.adView.adPeriodTime=2.5;/**时间间隔*/
    self.adView.placeImageSource=@"1.jpg";/**设置默认广告*/
    [self.adView loadAdDataThenStart];
    [self.view addSubview:self.adView];
    
    self.oneView = [[UIView alloc]initWithFrame:CGRectMake(0, self.adView.frame.size.height+5, kScreenWidth, LayoutHeightCGFloat(80))];
    self.oneView.backgroundColor = RGB(255, 255, 255);
    [self.view addSubview:self.oneView];
    
    self.StunameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _oneView.frame.size.height/3-25, 30, 30)];
    self.StunameLabel.font = Title_Font;
    [self.StunameLabel setText:@"账户:"];
    [_oneView addSubview:self.StunameLabel];
    
    
    self.StucountLabel= [[UILabel alloc]initWithFrame:CGRectMake(15, 1.8*_oneView.frame.size.height/3-25, 180, 30)];
    self.StucountLabel.font = Title_Font;
    [self.StucountLabel setText:@"套餐:"];
    self.StucountLabel.textColor = RGB(128, 128, 128);
    [_oneView addSubview:self.StucountLabel];
    
    //开通
    self.estBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.StucountLabel.frame.size.width-30, self.StucountLabel.frame.origin.y, 50, self.StucountLabel.frame.size.height)];
    [self.estBtn setTitle:@"开通" forState:UIControlStateNormal];
    [self.estBtn addTarget:self action:@selector(openNet) forControlEvents:UIControlEventTouchUpInside];
    //添加事件
    self.estBtn.titleLabel.font = Title_Font;
    [self.estBtn setTitleColor:Title_Color1 forState:UIControlStateNormal];
    self.estBtn.hidden = YES;
    [_oneView addSubview:self.estBtn];
    
    //学号
    self.NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, self.StunameLabel.frame.origin.y, 100, 30)];
    self.NameLabel.font = Title_Font;
    [_oneView addSubview:self.NameLabel];
    //套餐
    self.CountLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, self.StucountLabel.frame.origin.y, 250, 30)];
    self.CountLabel.font = Title_Font;
//    self.CountLabel.hidden = YES;
    self.CountLabel.textColor = RGB(128, 128, 128);
    [_oneView addSubview:self.CountLabel];
    //续费
    self.ContinuepayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ContinuepayButton.frame = CGRectMake(kScreenWidth-50, self.CountLabel.frame.origin.y, 30,30 );
    [self.ContinuepayButton setTitleColor:Title_Color1 forState:UIControlStateNormal];
    [self.ContinuepayButton setTitle:@"续费" forState:UIControlStateNormal];
    self.ContinuepayButton.titleLabel.font = Title_Font;
    [self.ContinuepayButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    self.ContinuepayButton.hidden = YES;
    
    [_oneView addSubview:self.ContinuepayButton];
    
    //灰色分割线
    UIImageView *imageone = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.adView.frame.size.height+_oneView.frame.size.height+2,kScreenWidth, 1)];
    imageone.backgroundColor = RGB(192, 192,192);
    [self.view addSubview:imageone];
    
    
    _twoView = [[UIView alloc]initWithFrame:CGRectMake(0, imageone.frame.origin.y+2, kScreenWidth, LayoutHeightCGFloat(80))];
    self.twoView.backgroundColor = RGB(255, 255, 255);
    [self.view addSubview:_twoView];
    
    //缴费 --- 报修 ----一键上网  按钮
    UIImageView *imagetwo = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/3,5,1, _twoView.frame.size.height-15)];
    imagetwo.backgroundColor = RGB(192,192,192);
    [_twoView addSubview:imagetwo];
    
    UIImageView *imagethree = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/3*2-1,5,1, _twoView.frame.size.height-15)];
    imagethree.backgroundColor = RGB(192,192,192);
    [_twoView addSubview:imagethree];
    
    
    double width = imagethree.frame.size.height/2-20;
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(imagetwo.frame.origin.x/2-16, width, 32,32 );
    [self.payButton setBackgroundImage:[UIImage imageNamed:@"缴费"]forState:UIControlStateNormal];
    self.payButton.titleLabel.font =Title_Font;
    [self.payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [_twoView addSubview:self.payButton];
    
    UILabel *pay = [[UILabel alloc]initWithFrame:CGRectMake(self.payButton.frame.origin.x, width+32, 32,32 )];
    pay.textColor = Title_Color1;
    pay.text = @"缴费";
    pay.font = Title_Font;
    pay.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:pay];
    
    //报修
    self.repairButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.repairButton.frame = CGRectMake(kScreenWidth/2-16, width, 32,32 );
    [self.repairButton setTitleColor:RGB(169, 208, 167) forState:UIControlStateNormal];
    [self.repairButton setBackgroundImage:[UIImage imageNamed:@"报修"]forState:UIControlStateNormal];
    self.repairButton.titleLabel.font = Title_Font;
    [self.repairButton addTarget:self action:@selector(repair) forControlEvents:UIControlEventTouchUpInside];
    [_twoView addSubview:self.repairButton];
    
    UILabel *repair = [[UILabel alloc]initWithFrame:CGRectMake(self.repairButton.frame.origin.x, width+32, 32,32 )];
    repair.textColor = Title_Color1;
    repair.text = @"报修";
    repair.font = Title_Font;
    repair.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:repair];
    
    

    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(imagethree.frame.origin.x+(kScreenWidth-imagethree.frame.origin.x )/2-16, width, 32,32 );
    [self.loginButton setTitleColor:RGB(169, 208, 167) forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = Title_Font;
    [self.loginButton addTarget:self action:@selector(logintonet) forControlEvents:UIControlEventTouchUpInside];
    [_twoView addSubview:self.loginButton];
    
    self.loginLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.loginButton.frame.origin.x-14, width+32, 60,32 )];
    self.loginLabel.textColor = Title_Color1;
    self.loginLabel.font = Title_Font;
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    [_twoView addSubview:self.loginLabel];
    
    if (self.checkNet==YES&&[NetworkCore wifiIsEqual]) {
        [self.loginButton setImage:[UIImage imageNamed:@"断开"]forState:UIControlStateNormal];
        self.loginLabel.text = @"断开连接";

    }else{
    
        [self.loginButton setImage:[UIImage imageNamed:@"一键"]forState:UIControlStateNormal];
        self.loginLabel.text = @"一键上网";

    
    }
    
    /**********************新闻部分*****************************/
    UIView *grayV = [[UIView alloc]initWithFrame:CGRectMake(0, self.twoView.frame.origin.y+self.twoView.frame.size.height, kScreenWidth, LayoutHeightCGFloat(137))];
    grayV.backgroundColor = RGB(240, 240, 240);
    [self.view addSubview:grayV];
    
    
    UILabel *newsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth, 35)];
    newsLabel.backgroundColor = RGB(240, 240, 240);
    newsLabel.text = @"C+动态";
    newsLabel.font = Title_Font;
    [grayV addSubview:newsLabel];
    
    self.newsTabview= [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, LayoutHeightCGFloat(80))];
    self.newsTabview.delegate = self;
    self.newsTabview.dataSource = self;
    self.newsTabview.backgroundColor = RGB(240, 240, 240);
    //去除分割线
    self.newsTabview.separatorStyle = NO;
    [grayV addSubview:self.newsTabview];
}
/*
 *用户验证过期后重新登录
 */
-(void)tokenTime{
    AppUserIndex *user = [AppUserIndex GetInstance];
    double tokentime = [user.tokenTime doubleValue];
    NSDate *  currentdate=[NSDate date];
    NSDate *  timeOut = [NSDate dateWithTimeIntervalSince1970:tokentime];
    //日期比较
    int  result =[self compareOneDay:currentdate withAnotherDay:timeOut];
    if (result == 1 ) {
        //过期了
        XGAlertView *pass = [[XGAlertView alloc]initWithTarget:self withTitle:@"用户验证过期" withContent:@"请重新验证" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        pass.tag = 1001;
        pass.delegate = self;
        [pass show];
        
    }
}
/*
 *获取服务器配置信息
 */
- (void)getConfig{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getConfig"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        ConfigObject *config = [ConfigObject shareConfig];
        config.oderStateDic = [responseObject valueForKeyPath:@"data.orderState"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
/*
 *日期比较
 */
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSComparisonResult result = [oneDay compare:anotherDay];
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}


/*
 *开启一个网络监测
 */
-(void)Nstimer{
  _myTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(queryUserInfoP) userInfo:nil repeats:YES];
    
    [_myTimer fire];
    
}
/**
 *
 */
-(void)NotiftierLogout
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StopTimer)
                                                 name:NotificationLogout object:nil];
}
/**
 * 停止时间计时器
 */
-(void)StopTimer
{
    [_myTimer setFireDate:[NSDate distantFuture]];

    
}
/**
 * 开启时间定时器
 */
-(void)StartTimer{

    [_myTimer setFireDate:[NSDate date]];

}

/*
 *重新验证用户信息
 */
-(void)loadAgain{
    [self testagain];
    AppUserIndex *user = [AppUserIndex GetInstance];
    //用户名
    self.NameLabel.text = user.userName;
    self.CountLabel.text =[self getPackageName];
}
/*
 *显示一键上网
 */
-(void)logotoNet{
    [self.loginButton setImage:[UIImage imageNamed:@"一键"] forState:UIControlStateNormal];
    self.loginLabel.text = @"一键上网";
}
/*
 *显示断开连接
 */
-(void)breakNet{
    [self.loginButton setImage:[UIImage imageNamed:@"断开"] forState:UIControlStateNormal];
    self.loginLabel.text = @"断开连接";
}
/*
 *不是规定的wifi弹窗
 */
-(void)alertNotWifi{
    NSString *wifi = [NSString stringWithFormat:@"无线连接不正确，请将无线切换为%@后重试",[AppUserIndex GetInstance].wifiName];
    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"尊敬的用户您好" withContent:wifi WithCancelButtonTitle:@"确定" withOtherButton:nil];
    alert.tag=1002;
    [alert show];
    return ;
}
/*
 *失败弹窗
 */
-(void)failerdAlert{
    
    XGAlertView *failAlert = [[XGAlertView alloc]initWithTarget:self withTitle:@"网络连接失败 " withContent:@"" WithCancelButtonTitle:@"确定" withOtherButton:nil];
    failAlert.delegate = self;
    failAlert.tag =  1004;
    [failAlert show];
}

/*
 *重新监测并获取用户信息
 */
-(void)testagain{
    NSString *url = @"http://www.baidu.com.cn";
    [NetworkCore requestNormalGET:url parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *Epurl = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jap = @"<title>百度一下,你就知道</title>";
        NSRange foundObj=[Epurl rangeOfString:jap options:NSCaseInsensitiveSearch];
        if (foundObj.length>0) {

            self.checkNet=YES;
        }
        else{
            self.checkNet=NO;

        }
        //先检测是否联网以及是不是规定的wifi
        if(self.checkNet==YES&&[NetworkCore wifiIsEqual]) {
            [self breakNet];
        }else{
        [self logotoNet];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
        [self logotoNet];
        
        
    }];
}
/*
 *重新验证用户信息
 */

-(void)queryUserInfoP{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *username = user.accountId;
    NSString *usertoken = user.token;
    NSDictionary *userDic = @{
                              @"rid":@"queryUserInfo",
                              @"username":username,
                              @"token":usertoken,
                              };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:userDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *resDic = [responseObject objectForKey:@"data"];
        
        self.currentTime = [resDic objectForKey:@"serverCurrentTime"];
        
        _userDicInfo = [resDic objectForKey:@"samUserInfo"];
        //用户名
        self.userName = [_userDicInfo objectForKey:@"userName"];
        //套餐名
        self.packageName = [_userDicInfo  objectForKey:@"packageName"];
        //账户余额
        self.accountFee = [_userDicInfo objectForKey:@"accountFee"];
        //模板名
        self.atName = [_userDicInfo objectForKey:@"atName"];
        //用户ID
        self.accountID = [_userDicInfo objectForKey:@"accountId"];
        self.policyId = [_userDicInfo objectForKey:@"policyId"];
        NSRange range = [[_userDicInfo objectForKey:@"nextBillingTime"]rangeOfString:@"T"];
        self.nextBillingTime = [[_userDicInfo objectForKey:@"nextBillingTime"] substringToIndex:range.location];
        self.periodStartTime = [_userDicInfo objectForKey:@"periodStartTime"];
        self.stateFlag = [[_userDicInfo objectForKey:@"stateFlag"] longValue] ;
        //单例传值
        AppUserIndex *appUser = [AppUserIndex GetInstance];
        appUser.userName =self.userName;
        appUser.packageName = self.packageName;
        appUser.accountFee = self.accountFee;
        appUser.atName = self.atName;
        appUser.nextBillingTime = self.nextBillingTime;
        appUser.accountId = self.accountID;
        appUser.policyId = self.policyId;
        appUser.currentTime = self.currentTime;
        //用户名
        self.NameLabel.text = self.userName;
        self.CountLabel.text = [self getPackageName];
        NSArray *userArr = [responseObject objectForKey:@"roleInfo"];
        if (userArr.count!=0) {
            for (NSDictionary *dic in userArr) {
                user.role_type = [NSString stringWithFormat:@"%@",dic[@"ROLE_TYPE"]];
                if (dic[@"ROLE_ID"]) {
                    user.role_id =[NSString stringWithFormat:@"%@",dic[@"ROLE_ID"]];
                }else{
                    user.role_id = @"";
                    user.role_username = @"";                }
            }
        }else{
            user.role_id = @"";
            user.role_username = @"";
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {

        
    }];
    //刷新用户数据
    [self loadAgain];
    
}
/*
 *开启网络监测的监听
 */
-(void)testInNet{
    
    ///开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //开始监听，会启动一个run loop
    [self.reach startNotifier];
    
}
/**
 *  网络状态监测  数据情况下停止检测网络连接
 */
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {
        self.checkNet=NO;
        [self logotoNet];

    }
    if(status == ReachableViaWWAN){
        [self logotoNet];
        [self StopTimer];
    }
        
    if(status == ReachableViaWiFi){
    //无线情况下开启检测网络连接
    [self StartTimer];
    if (![NetworkCore wifiIsEqual])
    {
        [self logotoNet];
        
    }
   
}

}
/*
 *加载轮播图
 */
-(void)loadImageData{
    AppUserIndex *user = [AppUserIndex GetInstance];
    _imageUrl= user.API_URL;
   self.imageArr = [NSMutableArray array];
    
    NSDictionary *dic = @{
                          @"rid":@"getBannerInfo"
                          };
    [NetworkCore requestPOST:_imageUrl parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqual:@"0x000000"]) {
            
        for (NSDictionary *dic in responseObject[@"data"]) {
                
                NSString *url = dic[@"picUrl"];
                url = [NSString stringWithFormat:@"%@%@",_imageUrl,url];
                url = [url stringByReplacingOccurrencesOfString:@"index.php/" withString:@""];
                [self.imageArr addObject:url];
        }
            //加载轮播图数据并开始——————————播放
            self.adView.adDataArray=[NSMutableArray arrayWithArray:self.imageArr];
            [_adView loadAdDataThenStart];
    }
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];

}

/*
 *加载新闻数据
 */
-(void)initData{
    //新闻数据
    self.newsArr = @[@"iPhone用户上网注意",@"登录流程操作说明",@"套餐购买操作流程说明",@"一键上网操作流程说明"];
}
/*
 *开通上网套餐
 */
-(void)openNet{
    PaySelectViewController *vc = [[PaySelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
 *报修
 */
-(void)repair{
//    XGAlertView *tellAlert=[[XGAlertView alloc]initWithTarget:self withTitle:@"确定拨打维修电话？" withContent:@"400-766-1616" WithCancelButtonTitle:@"拨打" withOtherButton:@"取消"];
//    tellAlert.tag=1003;
//    tellAlert.delegate = self;
//    [tellAlert show  ];

    PlayGroundNewViewController *vc = [[PlayGroundNewViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/*
 *一键上网
 */
-(void)logintonet
{
    /**
     是规定的wifi ：1  不是：0
     已连接网络：1 不是：0
     11:断开连接
     10：一键上网
     01：一键上网  弹窗提示
     00：一键上网  弹窗提示
     **/
    //不是规定的wifi显示一键上网并给出错误wifi的提示
    if (![NetworkCore wifiIsEqual]) {
        [self logotoNet];
        [self alertNotWifi];
        return;

    }
    //如果网络联通并且是规定的wifi，则是断开网络
    if (self.checkNet==YES) {
        [self logotoNet];
        [self LogoutToNet];
        return;
        }
    //是规定wifi并且无连接则进行一键上网
    [ProgressHUD show:@"登录中，请稍后..."];
    [self logintoInterNet];
}
/*
 *断开网络
 */
-(void)LogoutToNet{
    
    [MobClick event:@"breakNet"];
    [ProgressHUD show:@"正在断开"];
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *logoutUrl = user.LogoutURL;
    NSString *EpUrl = user.epurl;
    if (logoutUrl.length==0) {
        XGAlertView *logoutnil = [[XGAlertView alloc]initWithTarget:self withTitle:@"暂时不能断开网络！" withContent:@"您可能是通过浏览器登录上网，不能通过本软件断开连接；您可能通过本软件上网，但是在后台将本程序退出，因此无法断开连接。解决办法:关闭无线，一段时间后将自动下线。" WithCancelButtonTitle:@"好的" withOtherButton:nil];
        logoutnil.delegate=self;
        
        [self breakNet];

        [ProgressHUD dismiss];
        
        [logoutnil show];
        
        return;
        
}
        //截取字符串---单利传值  ----
        logoutUrl =[EpUrl stringByReplacingOccurrencesOfString:@"index.jsp?" withString:logoutUrl];
        NSRange start = [logoutUrl rangeOfString:@"http://"];
        NSRange end = [logoutUrl rangeOfString:@"wlanuserip"];
        if (logoutUrl) {
            logoutUrl = [logoutUrl substringWithRange:NSMakeRange(start.location, end.location-start.location)];
            
        }
        [NetworkCore requestGET:logoutUrl parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
            //显示一键上网
            [ProgressHUD showSuccess:@"断开网络成功"];
            [self StopTimer];
            self.checkNet=NO;
            [self logotoNet];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            //显示断开连接
            [self breakNet];
            [ProgressHUD showSuccess:@"断开网络失败"];

        }];


}

/*
 *一键上网登录
 */
-(void)logintoInterNet{
    
    [MobClick event:@"oneKeyNet"];
    

    //从本地取出用户名 密码 登录
    AppUserIndex *user = [AppUserIndex GetInstance];
    //用户名
    NSString *username = user.accountId;
    //密码
    NSString *pwd = user.passWord;
    //登录到网络
    [self loginENonInterNet:username withpwd:pwd];

}
/*
 *一键上网
 */
-(void)loginENonInterNet:(NSString *)username withpwd:(NSString *)pwd{
    AppUserIndex *user = [AppUserIndex GetInstance];
    //先做网络判断
    if (![NetworkCore wifiIsEqual]) {
        [ProgressHUD dismiss];
        [self logotoNet];
        [self alertNotWifi];
        return ;
        
    }
    //判断是否能上网
        NSString *url = @"http://www.baidu.com";
        [NetworkCore requestNormalGET:url parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSData *data = responseObject;
            NSString *Epurl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *jap = @"<title>百度一下,你就知道</title>";
            NSRange foundObj=[Epurl rangeOfString:jap options:NSCaseInsensitiveSearch];
            if(foundObj.length>0) {
            [ProgressHUD showSuccess:@"网络连接成功"];
                self.checkNet=YES;
                return;
                
            }
            //字符串截取
            NSRange start = [Epurl rangeOfString:@"<script>"];
            NSRange end = [Epurl rangeOfString:@"</script>"];
            Epurl = [Epurl substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
            //字符串截取
            start = [Epurl rangeOfString:@"http"];
            end = [Epurl rangeOfString:@"'<"];
            Epurl = [Epurl substringWithRange:NSMakeRange(start.location, end.location-start.location)];
            if (Epurl.length==0) {
                [ProgressHUD showError:@"网络连接失败"];
                    return ;
            }
            
[NetworkCore requestNormalGET:Epurl parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                    
            NSData *data = responseObject;
                    
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    
            if (!str) {
                str = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
                    }
            NSRange start = [str rangeOfString:@"<form"];
            NSRange end = [str rangeOfString:@"method=login"];
            str = [str substringWithRange:NSMakeRange(start.location, end.location-start.location+14)];
            start = [str rangeOfString:@"action="];
            end = [str rangeOfString:@">"];
            str = [str substringWithRange:NSMakeRange(start.location, end.location-start.location)];
            str = [str stringByReplacingOccurrencesOfString:@"action=" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            str = [NSString stringWithFormat:@"%@&",str];
            user.epurl = Epurl;
            //截取字符串
            str = [Epurl stringByReplacingOccurrencesOfString:@"index.jsp?" withString:str];
[NetworkCore requestNormalGET:@"http://1.1.1.1/?rand=0.619542766180218" parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSData *ui = responseObject;
            NSString *sta = [[NSString alloc]initWithData:ui encoding:NSUTF8StringEncoding];
            if (sta==nil) {
                            
                [ProgressHUD showError:@"网络连接失败"];
                    return ;
                            
            }
                        
    if (str!=nil) {
[NetworkCore requestGET:str parameters: @{@"username":username,@"pwd":pwd,@"param":@"true"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    
    NSRange start = [responseObject rangeOfString:@"webGateModeV2.do?method=logout"];
    NSRange end = [responseObject rangeOfString:@"d.maxLeavingTr."];
    
    if (start.length==0||end.length==0) {
        NSRange start = [responseObject rangeOfString:@"alert('"];
        NSRange end = [responseObject rangeOfString:@")"];
        NSString * error = [responseObject substringWithRange:NSMakeRange(start.location+7, end.location-start.location-8)];
        
        [ProgressHUD dismiss];
        XGAlertView *errorMsg = [[XGAlertView alloc]initWithTarget:self withTitle:@"用户状态异常" withContent:error WithCancelButtonTitle:@"确定" withOtherButton:nil];
        [errorMsg show];
        
        return ;
        }

//截取登出网址的参数:userV2.do?method=logout&userIndex=38363833313733383138386264366130626636663532623932346432323765355f3139322e3136382e31322e3234325f6375696a79
    NSString *logoutStr = [responseObject substringWithRange:NSMakeRange(start.location, end.location-start.location)];
    start = [logoutStr rangeOfString:@"webGateModeV2.do?method=logout"];
    end = [logoutStr rangeOfString:@"'"];
    //登出的网址
    logoutStr = [logoutStr substringWithRange:NSMakeRange(start.location, end.location-start.location)];
    //登出网址参数
    user.LogoutURL = logoutStr;
    NSString *jap = @"userIndex";
    NSRange foundObj=[responseObject rangeOfString:jap options:NSCaseInsensitiveSearch];
    if(foundObj.length>0) {
        self.checkNet = YES;
        [self changeanthoerTitle];
        [ProgressHUD showSuccess:@"网络连接成功"];
        return;
    }
    [ProgressHUD dismiss];
    //弹出失败的弹窗
    static int i = 0;
    if (i<2) {
        [self failerdAlert];
    }
    i++;
    if (i>2) {
        XGAlertView *fail = [[XGAlertView alloc]initWithTarget:self withTitle:@"网络连接失败 " withContent:nil WithCancelButtonTitle:@"报修" withOtherButton:@"取消"];
        fail.tag = 1005;
        fail.delegate = self;
        
        [fail show];
        i =0;
        
    }
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                                    
        [ProgressHUD showError:@"网络连接失败"];
    }];
            
            
    }
} failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                        
                [ProgressHUD showError:@"网络连接失败"];
    
        }];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                    
                    
        [ProgressHUD showError:@"网络连接失败"];

        
    }];
            
} failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:@"网络连接失败"];

            
}];
}

/*
 *修改标题
 */
-(void)changeanthoerTitle{
    
    self.payButton.hidden = NO;
    self.CountLabel.hidden = NO;
    self.ContinuepayButton.hidden = NO;
    self.estBtn.hidden =YES;
    [self.StucountLabel setText:@"套餐:"];
    //能上网
    if (self.checkNet==YES&&[NetworkCore wifiIsEqual]) {
            [self breakNet];
        
    }else{
    
        [self logotoNet];
    }

}
#pragma tableview delegate  datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArr.count;

}
//绘制tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //显示的新闻标题的名字--------
    cell.textLabel.text =self.newsArr[indexPath.row];
    cell.textLabel.font = Title_Font;
    cell.textLabel.textColor = RGB(128, 128, 128);
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = RGB(240, 240, 240);
    
    //箭头图片
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}
#pragma XGAlertDelegate
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    if (view.tag == 1004) {
        //重试
        [self logintonet];
        
    }
    else if(view.tag==1005)
    {
        //报修
        [self repair];
    
    }
    else if(view.tag ==1001){
    
        //清除用户名  密码   学校
        AppUserIndex *user = [AppUserIndex GetInstance];
        //停止时间检测
        [self StopTimer];
        
        [user cleanAndSave];
        //注销  下线
        [self LogoutToNet];
        //退出登录
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogout object:self];
  }
    else if(view.tag==1003){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4007661616"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (view.tag==1002){
    
        NSString *urlString = @"App-Prefs:root=WIFI";
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
                
            } else {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }
            
        }
    }
    
}

#pragma tableViewcell  点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选中的是%ld个单元格",(long)indexPath.row);
    NSArray *urlArr = @[ WEB_URL_HELP(@"Helpconnect.html"), WEB_URL_HELP(@"Helplogin.html"), WEB_URL_HELP(@"Helpbuy.html"),WEB_URL_HELP(@"Helponekey.html")];
  
    AboutUsViewController *about = [[AboutUsViewController alloc]init];
    
    about.baseUrl =urlArr[indexPath.row];
    about.hidesBottomBarWhenPushed = YES;
    about.navigationController.navigationBarHidden = YES;
    
    [self.navigationController pushViewController:about animated:YES];


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
       return 30;
}
#pragma mark - 图片点击
-(void)adView:(ZWAdView *)adView didDeselectAdAtNum:(NSInteger)num{
    NSLog(@"-click index>%ld",(long)num);
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

- (IBAction)pay:(id)sender {
    
}


- (void)payAction:(UIButton *)sender {
    PaySelectViewController *vc = [[PaySelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getPackageName{
    NSRange range = [[AppUserIndex GetInstance].packageName rangeOfString:@"|b"];
    AppUserIndex *user = [AppUserIndex GetInstance];

    if (range.length == 0) {
        self.ContinuepayButton.hidden = NO;
        
        self.StucountLabel.font = Title_Font;
        self.CountLabel.text = user.packageName;
        return user.packageName;
    }
    
    [self changeanthoerTitle];
    return [user.packageName substringToIndex:range.location];
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
