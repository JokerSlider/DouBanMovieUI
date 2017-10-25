//
//  NewIndexViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/10/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "NewIndexViewController.h"
#import "UIView+SDAutoLayout.h"
#import "ZWAdView.h"
#import "XGAlertView.h"
#import "AboutUsViewController.h"
#import "ConfigObject.h"
#import "Reachability.h"
#import "PaySelectViewController.h"
#import "CourseViewController.h"
#import "BaseNavigationController.h"
#import "XGButton.h"
#import "FreeRoomViewController.h"
#import "FreeBuildViewController.h"
#import "ExamViewController.h"
#import "QuestionListViewController.h"
#import "PushMsgViewController.h"
#import "CCLocationManager.h"
#import <JSONKit.h>
#import "BaseConfig.h"
#include <sys/socket.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "QueryScoreViewController.h"
#import "ExamPlanViewController.h"
#import "WebViewController.h"
#import "DepartmentListViewController.h"
#import "NewsViewController.h"
#import "SchoolCardBalanceViewController.h"
#import "OneCardViewController.h"
#import "UIButton+BackgroundColor.h"
#import "SchoolMapRouteViewController.h"
#import "QueryScoreClassListViewController.h"
#import "ChooseTypeViewController.h"
#import "FinanceIndexViewController.h"
#import "OrderTimeViewController.h"
#import "SalaryrqueryLoginViewController.h"
#import "RxWebViewController.h"
#import "RxWebViewNavigationViewController.h"
#import "SalaryViewController.h"
#import "ShuihuaqiangViewController.h"
#import "SchoolBusListViewController.h"
#import "CounselorViewController.h"
#import "ClassPhoneNumViewController.h"
#import "PackageInfoViewController.h"
#import "BaseListSelectViewController.h"
#import "AutoWebViewController.h"
#import "WeekListViewController.h"
#import "JhtLoadDocViewController.h"
#import "OfficialReleaseViewController.h"
#import "ImportWorkListViewController.h"
#import "NewChooseTimeViewController.h"
#import "MarketSendViewController.h"
#import "FinfLosedViewController.h"
#import "EmployessPhoneNumViewController.h"
#import "SignViewController.h"
#import "PhotoWallIndexViewController.h"
#import "EmployessContactBookViewController.h"
#import "MukeViewController.h"
#import "BusRouteViewController.h"
#import "SchoolBusLocatedViewController.h"
#import "LibarySearchViewController.h"
#import "LibraryViewController.h"
#import "JobMessageViewController.h"
#import "BookListViewController.h"
#import "ReaderListViewController.h"
#import "IndexNewsCell.h"
#import "SDAutoLayout.h"
#import "FinderBottomView.h"
#import "PhotoWallDetailViewController.h"
#import "FinanceOderListViewController.h"
#import <YYModel.h>
#import "WorldNewsViewController.h"
#import "GuideView.h"
#import "ChatMianViewController.h"
#import "MemberListViewController.h"
#import "ChatMessageViewController.h"
#import "CSportViewController.h"
#import "ShakeChatViewController.h"
//#import "BestSchoolMainViewController.h"
#import "MCLeftSliderManager.h"
#import "YunListViewController.h"
#import "AllAppActionViewController.h"
#import "AllAPPCollectionViewController.h"
#import "BaseDataReportViewController.h"
//#import "PersonScareViewController.h"
//#import "PersonOneCardCostController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "IndexManager.h"
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "LY_CircleButton.h"
#import "ValidateObject.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
//新版一键上网参数
//#define BaseUrl @"http://192.168.80.102:8080/eportal/inferface/authAPI/"
//#define ISNEWVERSION YES

#define ISNEWVERSION [AppUserIndex GetInstance].eportalVer
#define numOfLine 4

@interface NewIndexViewController ()<ZWAdViewDelagate, XGAlertViewDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,UIWebViewDelegate,BottomClickDelegate>
{
    ZWAdView *_bannerView;
    UIView *_userInfoView;
    UIView *_buttonView;
    UITableView *_newsTableView;
    UILabel *_userNameLabel;
    UILabel *_pakageNameLabel;
    NSTimer *_myTimer;
    
    NSString *_Epurl;
    NSMutableArray *_serviceArr;
    NSMutableArray *_buttonMutArray;//存放所有功能按钮
    NSMutableArray *_buttonShowArray; //存放要显示的功能按钮
    
    NSMutableArray *_imageContentUrlArr;//存放跳转网页链接的数组
    NSMutableArray *_isJumpArr;//存放是否跳转的参数
    
    NSMutableArray *_buttonViewArray;
    
    NSArray *_btnImageArray; //图片名ID对应数组
    
    
    
    NSTimer  *_netKeepTimer;
    
    
}

@property (nonatomic, retain) UIView *mainScrollView;
@property (nonatomic, strong) UIButton *connectNetBtn;
@property (nonatomic, strong) NSMutableArray *newsArray; //消息列表数组
@property (nonatomic, strong) NSArray *newsLinkArr;
@property (nonatomic, assign) BOOL isConnectNet;
@property (nonatomic,strong)NSMutableArray *pointArr;;
@property (nonatomic,strong)NSMutableArray *titleArray;;
@property (nonatomic,strong)    LY_CircleButton *badgeV;//角标
@property (nonatomic,strong)NSMutableArray *bgdgeViewArr;//角标数组
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic,strong)    FinderBottomView *bottomView;

@end

@implementation NewIndexViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [NSObject cancelPreviousPerformRequestsWithTarget:self] ;
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationHandler:)
                                                 name:NotificationAPNSHandler object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFuncMessage:) name:AllFunctionNotication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllFunction:) name:RemoveFunctionNotication object:nil];

    self.navigationItem.title = @"菁彩校园";
    //创建视图
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 21, 21);
    //    menuBtn.layer.cornerRadius = 17.5;
    menuBtn.clipsToBounds = YES;
    //        menuBtn.backgroundColor = [UIColor redColor];
   
#ifdef isNewVer
    [menuBtn setImage:[UIImage imageNamed:@"index1_qiandao_new"] forState:UIControlStateNormal];
#else
    [menuBtn setImage:[UIImage imageNamed:@"index1_qiandao"] forState:UIControlStateNormal];
#endif
    menuBtn.tag = 2020;
    [menuBtn addTarget:self action:@selector(openSignVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    
    _newsTableView = ({
        UITableView *view = [[UITableView alloc] init];
        view.backgroundColor = RGB(247, 247, 247);
        view.delegate = self;
        view.dataSource = self;
        view.tableFooterView = [UIView new];
        view.separatorStyle = NO;
        view;
    });
    
    _mainScrollView = [[UIView alloc] init];
    _mainScrollView.width = [UIScreen mainScreen].bounds.size.width;
    if (@available(iOS 11,*)) {
        if ([_newsTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _newsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _newsTableView.estimatedRowHeight = 0;
            _newsTableView.estimatedSectionHeaderHeight = 0;
            _newsTableView.estimatedSectionFooterHeight = 0;
        }
    }
    //创建视图
    [self createBanner];
    [self queryUserInfo];
    [self createViews];
    [self buttonShow];
    [self startTimer];

}
#pragma mark 检查是否有未读的消息
-(void)checkisHaveMsg
{

    AppUserIndex *user = [AppUserIndex GetInstance];
    //检查是否存在未读消息  有的话继续发一遍通知
    
    for (NSDictionary *dic in user.funcMsgArr) {
        if ([dic[@"msgNum"] isEqualToString:@"remove"]) {
            NSNotification *allFuncNote = [[NSNotification alloc]initWithName:RemoveFunctionNotication object:dic userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:allFuncNote];
        }else{
            NSNotification *allFuncNote = [[NSNotification alloc]initWithName:AllFunctionNotication object:dic userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:allFuncNote];
        }
    }
   
}
#pragma  mark 以上是聊天的处理通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[MCLeftSliderManager sharedInstance].LeftSlideVC setPanEnabled:NO];
    [self stopTimer];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[MCLeftSliderManager sharedInstance].LeftSlideVC setPanEnabled:YES];
    [[HealthPostDataManager shareInstance] sendStepNumAndColriaData];

#warning 打开操场上传数据  上传数据  走完聚光灯引导页 再弹出qq
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"GuideViewDissMiss"]) {
        [[HealthPostDataManager shareInstance] sendStepNumAndColriaData];
    }
    
    [self checkisHaveMsg];

}
    
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.bottomView.isOpen) {
        [self.bottomView openFinderViewSelected];
    }
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)logSuccess{
    [self getConfig];
    [self loadBannerImage];
    [self createTimer];
    [self getLocalInfo];
    [self buttonShow];
    AppUserIndex *user = [AppUserIndex GetInstance];
    _userNameLabel.text = [NSString stringWithFormat:@"账户：%@",user.userName];//重新赋值用户名

    UIViewController *firstVC = [MCLeftSliderManager sharedInstance].mainNavigationController.viewControllers.firstObject;
    UIBarButtonItem *item = firstVC.navigationItem.leftBarButtonItem;
    UIButton *btn = item.customView;
    if (btn.tag == 2020) {
        UIImageView *imageView = [[UIImageView alloc] init];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////            [btn sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] forState:UIControlStateNormal placeholderImage:PlaceHolder_Image];
//            [btn setImage:[self OriginImage:image scaleToSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
//        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].headImageUrl] placeholderImage:[self OriginImage:PlaceHolder_Image scaleToSize:CGSizeMake(35, 35)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [btn setImage:[self OriginImage:image scaleToSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
            
        }];
    }
    
    //加载Agent
    if (ISNEWVERSION) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopKeepLiveTimer) name:@"NotificationBreakNet" object:nil];
        
        [self loadUserAgent];
        [self getIPAddress];
    }
    [self loadData];
}

//加载首页消息数据
- (void)loadData{
    
    NSDictionary *commitDic = @{
                                @"rid":@"showDynamicAlerts",
                                @"userid":[AppUserIndex GetInstance].role_id,
                                @"page":@"1",
                                @"pageCount":@"10"
                                };
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _newsArray = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject[@"data"]) {
            IndexNewsCellModel *model = [[IndexNewsCellModel alloc] init];
            [model yy_modelSetWithDictionary:dic];
            
            [_newsArray addObject:model];
        }
        [_newsTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
}


//创建banner 图
-(void)createBanner{
    //大视图
    _bannerView = ({
        ZWAdView *view = [[ZWAdView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenWidth*0.375)];
        view.adDataArray=[NSMutableArray arrayWithArray:@[@"1.jpg"]];
        view.pageControlPosition=ZWPageControlPosition_BottomCenter;/**设置圆点的位置*/
        view.hidePageControl=NO;/**设置圆点是否隐藏*/
        view.adAutoplay=YES;/**自动播放是否开启*/
        view.adPeriodTime=3;/**时间间隔*/
        view.delegate = self;
        view.placeImageSource=@"banner3.jpg";/**设置默认广告*/
        //        _mainScrollView.delegate  = self;
        [view loadAdDataThenStart];
        view;
    });
    [self.mainScrollView addSubview:_bannerView];
}
/*
 *开启一个网络监测
 */
-(void)createTimer{
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(networkTest) userInfo:nil repeats:YES];
    [_myTimer fire];
}

/**
 * 停止时间计时器
 */
-(void)stopTimer
{
    [_myTimer setFireDate:[NSDate distantFuture]];
}
/**
 * 开启时间定时器
 */
-(void)startTimer{
    [_myTimer setFireDate:[NSDate date]];
}
- (void)createViews{
    
    //首页每行的数量
    //    NSInteger numOfLine = 4;
    //按钮
    [_mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _mainScrollView.backgroundColor = RGB(247, 247, 247);
    
    
    NSArray *btnTitleArray = [IndexManager shareConfig].titlesArray;;
    
    _btnImageArray = [IndexManager shareConfig].iconsArray;

    AppUserIndex *user = [AppUserIndex GetInstance];
    user.iconIDArray = _btnImageArray;
    //新闻公告
    //    _newsArray = @[@"iPhone用户上网注意",@"登录流程操作说明",@"套餐购买操作流程说明",@"一键上网操作流程说明"];
    //    _newsLinkArr = @[WEB_URL_HELP(@"Helpconnect.html"), WEB_URL_HELP(@"Helplogin.html"), WEB_URL_HELP(@"Helpbuy.html"),WEB_URL_HELP(@"Helponekey.html")];
    
    _userInfoView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _buttonView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    
    [_mainScrollView addSubview:_bannerView];
    [_mainScrollView addSubview:_userInfoView];
    //    [_mainScrollView addSubview:_buttonView];
    //    [_mainScrollView addSubview:_newsTableView];
    [self.view addSubview:_newsTableView];
    //    [_mainScrollView setupAutoContentSizeWithBottomView:_buttonView bottomMargin:0];
    //    _mainScrollView.showsVerticalScrollIndicator = NO;
    
    _userInfoView.sd_layout
    .leftSpaceToView(_mainScrollView,0)
    .rightSpaceToView(_mainScrollView,0)
    .topSpaceToView(_bannerView,1)
    .heightIs(LayoutHeightCGFloat(50));
    
    _buttonView.sd_layout
    .leftSpaceToView(_mainScrollView,0)
    .rightSpaceToView(_mainScrollView,0)
    .topSpaceToView(_userInfoView,10);
    
    _newsTableView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(kScreenHeight-64-95);
    
    //账户
    _userNameLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = [NSString stringWithFormat:@"账户：%@",user.userName];
        view.textColor = Color_Black;
        view;
    });
    
    _pakageNameLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view.text = [self getPackageName];
        view;
    });
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.tag = 2;
    [payBtn addTarget:self action:@selector(buttonViewAction:) forControlEvents:UIControlEventTouchUpInside];

#ifdef isNewVer
    [payBtn setImage:[UIImage imageNamed:@"index_connect_new"] forState:UIControlStateNormal];
    [payBtn setImage:[UIImage imageNamed:@"index_break_new"] forState:UIControlStateSelected];
#else
    [payBtn setImage:[UIImage imageNamed:@"index_connect"] forState:UIControlStateNormal];
    [payBtn setImage:[UIImage imageNamed:@"index_break"] forState:UIControlStateSelected];
#endif
    [payBtn setTitleColor:Title_Color1 forState:UIControlStateNormal];
    payBtn.titleLabel.font = Title_Font;
    
    _connectNetBtn = payBtn;
    
    [_userInfoView addSubview:_userNameLabel];
    [_userInfoView addSubview:payBtn];
    
    _userNameLabel.sd_layout
    .leftSpaceToView(_userInfoView,20)
    .rightSpaceToView(_userInfoView,10)
    .topSpaceToView(_userInfoView,LayoutHeightCGFloat(12))
    .heightIs(LayoutHeightCGFloat(25));
    
    _pakageNameLabel.sd_layout
    .leftSpaceToView(_userInfoView,20)
    .topSpaceToView(_userNameLabel,1)
    .rightSpaceToView(_userInfoView,60)
    .heightIs(LayoutHeightCGFloat(0));
    
    payBtn.sd_layout
    .rightSpaceToView(_userInfoView,10)
    .centerYEqualToView(_userInfoView)
    .widthIs(LayoutHeightCGFloat(100))
    .heightIs(LayoutHeightCGFloat(30));
    
    CGFloat btnWith = kScreenWidth/numOfLine;
    _buttonMutArray = [NSMutableArray array];
    for (int i=0; i<btnTitleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
#ifdef isNewVer
        NSString *name = [NSString stringWithFormat:@"%@_new",_btnImageArray[i]];
        [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
#else
        [btn setImage:[UIImage imageNamed:_btnImageArray[i]] forState:UIControlStateNormal];
#endif
        [btn setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
        btn.titleLabel.font = Title_Font;
        [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(10,(btnWith-LayoutHeightCGFloat(28))/2,LayoutHeightCGFloat(34),(btnWith-LayoutHeightCGFloat(36))/2);
        btn.titleEdgeInsets = UIEdgeInsetsMake(LayoutHeightCGFloat(45), -btn.titleLabel.bounds.size.width-25, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i==2) {
#ifdef isNewVer
            [btn setImage:[UIImage imageNamed:@"index_break_new"] forState:UIControlStateSelected];
#else
            [btn setImage:[UIImage imageNamed:@"index_break"] forState:UIControlStateSelected];
#endif
            [btn setTitle:@"断开" forState:UIControlStateSelected];
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonViewAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonMutArray addObject:btn];
    }
}

- (void)buttonShow{
    CGFloat btnWith = kScreenWidth/numOfLine;
    UIButton *lastButton;
    //将要显示的按钮，存放到这个数组中。
//#ifdef isDEBUG
//    _buttonShowArray = _buttonMutArray;
//#else
//    [_buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    _buttonShowArray = [NSMutableArray array];
//    for (NSDictionary *dic in [AppUserIndex GetInstance].appListArray) {
//        NSInteger index = [dic[@"AI_ID"] integerValue]-1;
//        if (index < _buttonMutArray.count) {
//            if ([dic[@"RSA_ENABLE"] boolValue]) {
//                UIButton *btn = _buttonMutArray[index];
//                [btn setTitle:dic[@"AI_NAME"] forState:UIControlStateNormal];
//
//                [_buttonShowArray addObject:btn];
//            }else{
//                UIButton *btn = _buttonMutArray[index];
//                [btn addTarget:self action:@selector(notOpenShow:) forControlEvents:UIControlEventTouchUpInside];
//                btn.tag = 99999;
//                [_buttonShowArray addObject:btn];
//            }
//        }
//    }
//#endif
    
    _buttonViewArray = [NSMutableArray array];
    self.bgdgeViewArr = [NSMutableArray array];
    for (id obj in _mainScrollView.subviews) {
        if ([obj isMemberOfClass:[UIView class]]) {
            UIView *view = (UIView *)obj;
            if (view.tag == 9999) {
                [view removeFromSuperview];
            }
        }
    }
    for (NSDictionary *hotDic in [AppUserIndex GetInstance].hotListArray) {
        NSString *hotName = hotDic[@"ag_name"]; //标题
        
        
        UIView *lastView = nil;
        if (_buttonViewArray.count > 0) {
            lastView = [_buttonViewArray lastObject];
        }else{
            lastView = _userInfoView;
        }
        UIView *buttonView = [UIView new];
        buttonView.backgroundColor = [UIColor whiteColor];
        buttonView.tag = 9999;
        [_mainScrollView addSubview:buttonView];
        
        buttonView.sd_layout
        .leftSpaceToView(_mainScrollView,0)
        .rightSpaceToView(_mainScrollView,0)
        .topSpaceToView(lastView,10);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 15, 300, 15)];
        titleLabel.text = hotName;
        titleLabel.textColor = RGB(51, 51, 51);
        titleLabel.font = [UIFont systemFontOfSize:15];
        [buttonView addSubview:titleLabel];
        
        
        NSArray *arr = hotDic[@"sds_coded"];
        for (int i = 0; i<arr.count; i++) {
            
            NSDictionary *dic = arr[i]; //单个数组
            NSInteger ai_id = [dic[@"ai_id"] integerValue]-1;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
            btn.imageEdgeInsets = UIEdgeInsetsMake(10,(btnWith-LayoutHeightCGFloat(28))/2,LayoutHeightCGFloat(34),(btnWith-LayoutHeightCGFloat(36))/2);
            btn.titleEdgeInsets = UIEdgeInsetsMake(LayoutHeightCGFloat(45), -btn.titleLabel.bounds.size.width-25, 0, 0);
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.tag = ai_id;
            [btn addTarget:self action:@selector(buttonViewAction:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.frame = CGRectMake((i%numOfLine)*btnWith,35+ i/numOfLine*LayoutHeightCGFloat(80), btnWith, LayoutHeightCGFloat(80));
            //注册全功能推送通知

            
            UIImageView *imageView = [[UIImageView alloc] init];
            if (_btnImageArray.count > ai_id) {
            
            
#ifdef isNewVer
            NSString *name = [NSString stringWithFormat:@"%@_new",_btnImageArray[ai_id]];
            imageView.image = [UIImage imageNamed:name];
                [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
#else
            imageView.image = [UIImage imageNamed:_btnImageArray[ai_id]];
#endif
            }
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [btn addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = dic[@"ai_name"];
            label.textColor = RGB(85, 85, 85);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = Title_Font;
            [btn addSubview:label];
            [btn setTitle:label.text forState:UIControlStateNormal];
            
            imageView.sd_layout
            .topSpaceToView(btn,LayoutHeightCGFloat(10))
            .widthIs(LayoutHeightCGFloat(38))
            .heightIs(LayoutHeightCGFloat(38))
            .centerXEqualToView(btn);
            
            label.sd_layout
            .leftSpaceToView(btn,0)
            .rightSpaceToView(btn,0)
            .topSpaceToView(imageView,LayoutHeightCGFloat(10))
            .heightIs(LayoutHeightCGFloat(25));
            
            [buttonView addSubview:btn];
            lastButton = btn;
            
            self.badgeV =  [[LY_CircleButton alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+24+imageView.frame.size.width, imageView.frame.origin.y+13/2, 13, 13)];
            self.badgeV.maxDistance = 30;
            [self.badgeV setBackgroundColor:[UIColor redColor]];
            self.badgeV.hidden = YES;
            self.badgeV.titleLabel.font = [UIFont systemFontOfSize:9.0];
            [self.badgeV setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.badgeV.layer.cornerRadius = _badgeV.bounds.size.height*0.5;
            self.badgeV.layer.masksToBounds = YES;
            self.badgeV.tag = ai_id;
            [self.badgeV addButtonAction:^(id sender) {
                LY_CircleButton *view =(LY_CircleButton *)sender;
                NSString *ai_id = [NSString stringWithFormat:@"%ld",view.tag];
                NSDictionary *dic = @{
                                      @"funcID":ai_id,
                                      @"msgNum":@"remove"
                                      };
                NSNotification *allFuncNote = [[NSNotification alloc]initWithName:RemoveFunctionNotication object:dic userInfo:nil];
                [[NSNotificationCenter defaultCenter]postNotification:allFuncNote];
                
                //将系统消息存档
                AppUserIndex *shareConfig = [AppUserIndex GetInstance];
                NSMutableArray *funcArr =[NSMutableArray arrayWithArray:shareConfig.funcMsgArr];
                [funcArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    if ([obj[@"funcID"] isEqualToString:ai_id]) {
                        // do sth
                        [funcArr removeObject:obj];
                        [funcArr addObject:dic];
                        *stop = YES;
                    }
                }];
                shareConfig.funcMsgArr = funcArr;
                [shareConfig saveToFile];
            }];
            [btn  addSubview:self.badgeV];
            [self.bgdgeViewArr addObject:self.badgeV];
        }
        [_buttonViewArray addObject:buttonView];
        if (lastButton) {
            [buttonView setupAutoHeightWithBottomView:lastButton bottomMargin:5];
        }else{
            buttonView.sd_layout.heightIs(25);
        }
    }
    
    
    if (_buttonViewArray.count > 0) {
        UIView *view = [_buttonViewArray lastObject];
        [_mainScrollView setupAutoHeightWithBottomView:view bottomMargin:10];
    }else{
        [_mainScrollView setupAutoHeightWithBottomView:_userInfoView bottomMargin:10];
    }
    
    [_mainScrollView layoutSubviews];
    
    _newsTableView.tableHeaderView = _mainScrollView;
    
    [self createBottomView];
}
#pragma mark 处理全功能推送
-(void)handleFuncMessage:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (LY_CircleButton *view in self.bgdgeViewArr) {
            if (view.tag == [dict[@"funcID"] intValue]) {
                view.hidden = NO;
                view.opaque = YES;
                NSString *msgNum = dict[@"msgNum"];
                if ([msgNum intValue]>99) {
                    msgNum = @"99+";
                    view.sd_layout.widthIs(22).heightIs(13);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }else if ([msgNum intValue]>0&&[msgNum intValue]<10){
                    view.sd_layout.widthIs(13).heightIs(13);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }else if ([msgNum intValue]>10&&[msgNum intValue]<99){
                    view.sd_layout.widthIs(21).heightIs(13);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }else{
                    msgNum=@"";
                    view.sd_layout.widthIs(8).heightIs(8);
                    view.layer.cornerRadius = view.bounds.size.height*0.5;
                }
                [view setTitle:msgNum forState:UIControlStateNormal];

            }
        }

    });
   
}

#pragma mark   移除全功能角标
-(void)removeAllFunction:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (LY_CircleButton *view in self.bgdgeViewArr) {
            if (view.tag == [dict[@"funcID"] intValue]) {
                view.hidden = YES;
                view.opaque = NO;
                [_mainScrollView layoutSubviews];
                
            }
        }
    });
}
#pragma mark   创建底部视图
- (void)createBottomView{
    
    AppUserIndex *user = [AppUserIndex GetInstance];
    if (self.bottomView) {
        [self.bottomView removeFromSuperview];
    }
    if (!_newsTableView) {
        return;
    }
    if (user.fileListArray.count==0) {
        _newsTableView.sd_layout.heightIs(kScreenHeight-64);
    }else{
        
        if (user.fileListArray.count == 1 ) {
            NSDictionary *dic = [user.fileListArray firstObject];
            NSString *ag_id = [dic objectForKey:@"ag_id"];
            if ([ag_id intValue]==0) {
                _newsTableView.sd_layout.heightIs(kScreenHeight-64);
            }else{
                [self addBottomView];
            }
        }else{
            [self addBottomView];
        }
       
    }
    
   
}
#pragma mark AddBotton
-(void)addBottomView
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *phoneType =[ValidateObject getDeviceName];

    if ([phoneType isEqualToString:@"iPhone X"]) {
        self.bottomView = [[FinderBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-95-35-64, kScreenWidth, 95+35)withIconArr:user.fileListArray];
        self.bottomView.delegate = self;
        [self.view addSubview:self.bottomView];
        _newsTableView.sd_layout.heightIs(kScreenHeight-64-35-95);
        
    }else{
        self.bottomView = [[FinderBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-95-64, kScreenWidth, 95)withIconArr:user.fileListArray];
        self.bottomView.delegate = self;
        [self.view addSubview:self.bottomView];
    }
}
#pragma mark 添加聚光灯引导   尚未开启
-(void)add_GuideView
{
    //坐标 点
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    NSArray *pointArr  =   @[
                             [NSValue valueWithCGRect:CGRectMake(18, 24, 35, 35)],
                             [NSValue valueWithCGRect:CGRectMake(kScreenWidth-43, 30, 30, 30)],
                             [NSValue valueWithCGRect:CGRectMake(_bannerView.origin.x+_bannerView.size.width-125,_bannerView.size.height+64+7,120,50)],
                             [NSValue valueWithCGRect:CGRectMake(_userNameLabel.frame.origin.x-15, _bannerView.size.height+64+10+_userInfoView.bounds.size.height+35, kScreenWidth, 90)],
                             [NSValue valueWithCGRect:CGRectMake(0, self.bottomView.origin.y+130/2+10, kScreenWidth, 130/2)],
                             ];
    _pointArr  = [NSMutableArray arrayWithArray:pointArr];
    _titleArray = [NSMutableArray arrayWithArray:@[@"这里是设置界面",@"签到跑这里来了",@"点击这里进行一键上网",@"新应用都在这",@"新增文件夹功能,让界面干净整洁"]];
    //初始化 引导页
    GuideView *markView = [[GuideView alloc]initWithFrame:window.bounds withRectArray:_pointArr andTitleArray:_titleArray ];
    markView.model = GuideViewCleanModeOval;
    [window addSubview:markView];
    
}
- (void)notOpenShow:(UIButton *)sender{
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"暂未开放！" WithCancelButtonTitle:@"确定" withOtherButton:nil];
    [alert show];
}

//buttonView点击事件
- (void)buttonViewAction:(UIButton *)sender{
    
    switch (sender.tag) {
        case 2:
        {
            if (ISNEWVERSION) {
                sender.selected?[self LogoutToNet]:[self newKeyToInternet];
                
            }else{
                sender.selected?[self breakToNet]:[self oneKeyToNet];
            }
            
        }
            break;
        default:{
            [[IndexManager shareConfig] buttonViewAction:sender withVC:self];
        }
            break;
    }
}
#pragma mark 全功能


//一键上网
- (void)oneKeyToNet{
    
    [self UMengEvent:@"oneKeyNet"];
    [ProgressHUD show:@"登录中..."];
    AppUserIndex *user = [AppUserIndex GetInstance];
    //先做网络判断
    if (![NetworkCore wifiIsEqual]) {
        [ProgressHUD dismiss];
        _connectNetBtn.selected = NO;
        [self alertNotWifi];
        return ;
    }
    [NetworkCore requestNormalGET:TEST_URL parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSData *data = responseObject;
        NSString *Epurl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *jap = @"<title>百度一下,你就知道</title>";
        NSRange foundObj=[Epurl rangeOfString:jap options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            [ProgressHUD showSuccess:@"网络连接成功"];
            _isConnectNet = YES;
            return;
        }
        //字符串截取
        NSRange start = [Epurl rangeOfString:@"<script>"];
        NSRange end = [Epurl rangeOfString:@"</script>"];
        if ((start.location&&end.location)!= NSNotFound) {
            //找到了
            Epurl = [Epurl substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
            //字符串截取
            start = [Epurl rangeOfString:@"http"];
            end = [Epurl rangeOfString:@"'<"];
            Epurl = [Epurl substringWithRange:NSMakeRange(start.location, end.location-start.location)];
            if (Epurl.length==0) {
                [ProgressHUD showError:@"网络连接失败"];
                return ;
            }
        }else{
            [ProgressHUD showError:@"网络连接失败"];
        }
        //第二步
        [NetworkCore requestNormalGET:Epurl parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
            NSData *data = responseObject;
            
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            if (!str) {
                str = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            }
            NSRange start = [str rangeOfString:@"<form"];
            NSRange end = [str rangeOfString:@"method=login"];
            if ((start.location&&end.location)!= NSNotFound) {
                //找到了
                str = [str substringWithRange:NSMakeRange(start.location, end.location-start.location+14)];
                start = [str rangeOfString:@"action="];
                end = [str rangeOfString:@">"];
                str = [str substringWithRange:NSMakeRange(start.location, end.location-start.location)];
                str = [str stringByReplacingOccurrencesOfString:@"action=" withString:@""];
                str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                str = [NSString stringWithFormat:@"%@&",str];
                user.epurl = Epurl;
                str = [Epurl stringByReplacingOccurrencesOfString:@"index.jsp?" withString:str];
            }
            
            if (!str) {
                [ProgressHUD showError:@"网络连接失败"];
                return ;
            }
            
            [NetworkCore requestNormalGET:@"http://1.1.1.1/?rand=0.619542766180218" parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                
                NSData *ui = responseObject;
                NSString *sta = [[NSString alloc]initWithData:ui encoding:NSUTF8StringEncoding];
                if (sta==nil) {
                    [ProgressHUD showError:@"网络连接失败"];
                    return ;
                }
                //从本地取出用户名 密码 登录
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                //用户名
                NSString *username = [ user objectForKey:@"accountId"];
                //密码
                NSString *pwd = [user objectForKey:@"pwd"];
                
                [NetworkCore requestGET:str parameters:@{@"username":username,@"pwd":pwd,@"param":@"true"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                    
                    
                    NSRange start = [responseObject rangeOfString:@"webGateModeV2.do?method=logout"];
                    NSRange end = [responseObject rangeOfString:@"d.maxLeavingTr."];
                    if (start.location!=NSNotFound||end.location!=NSNotFound) {
                        NSRange start = [responseObject rangeOfString:@"alert('"];
                        NSRange end = [responseObject rangeOfString:@")"];
                        if ((start.location&&end.location)!=NSNotFound) {
                            NSString * error = [responseObject substringWithRange:NSMakeRange(start.location+7, end.location-start.location-8)];
                            
                            [ProgressHUD dismiss];
                            XGAlertView *errorMsg = [[XGAlertView alloc]initWithTarget:self withTitle:@"用户状态异常" withContent:error WithCancelButtonTitle:@"确定" withOtherButton:nil];
                            [errorMsg show];
                            
                            return ;
                            
                        }else{
                            [ProgressHUD dismiss];
                            XGAlertView *errorMsg = [[XGAlertView alloc]initWithTarget:self withTitle:@"用户状态异常" withContent:@"" WithCancelButtonTitle:@"确定" withOtherButton:nil];
                            [errorMsg show];
                            
                            return ;
                            
                        }
                        
                    }
                    //截取登出网址的参数:userV2.do?method=logout&userIndex=38363833313733383138386264366130626636663532623932346432323765355f3139322e3136382e31322e3234325f6375696a79
                    NSString *logoutStr = [responseObject substringWithRange:NSMakeRange(start.location, end.location-start.location)];
                    start = [logoutStr rangeOfString:@"webGateModeV2.do?method=logout"];
                    end = [logoutStr rangeOfString:@"'"];
                    if ((start.location&&end.location)!=NSNotFound) {
                        //登出的网址
                        logoutStr = [logoutStr substringWithRange:NSMakeRange(start.location, end.location-start.location)];
                        //登出网址参数
                        [AppUserIndex GetInstance].LogoutURL = logoutStr;
                        NSString *jap = @"userIndex";
                        NSRange foundObj=[responseObject rangeOfString:jap options:NSCaseInsensitiveSearch];
                        if(foundObj.location!=NSNotFound) {
                            _isConnectNet = YES;
                            _connectNetBtn.selected = YES;
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
                        
                    }else{
                        [ProgressHUD showSuccess:@"网络连接失败"];
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:@"网络连接失败"];
    }];
    
}

- (void)breakToNet{
    [self UMengEvent:@"breakNet"];
    [ProgressHUD show:@"正在断开"];
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *logoutUrl = user.LogoutURL;
    NSString *EpUrl = user.epurl;
    if (logoutUrl.length==0) {
        XGAlertView *logoutnil = [[XGAlertView alloc]initWithTarget:self withTitle:@"暂时不能断开网络！" withContent:@"1、您可能是通过浏览器登录上网，不能通过本软件断开连接；\n2、您可能通过本软件上网，但是在后台将本程序退出，因此无法断开连接。\n\n解决办法:关闭无线，一段时间后将自动下线。" WithCancelButtonTitle:@"好的" withOtherButton:nil];
        _connectNetBtn.selected = YES;
        [ProgressHUD dismiss];
        [logoutnil show];
        return;
    }
    
    //截取字符串---单利传值  ----
    logoutUrl =[EpUrl stringByReplacingOccurrencesOfString:@"index.jsp?" withString:logoutUrl];
    NSRange start = [logoutUrl rangeOfString:@"http://"];
    NSRange end = [logoutUrl rangeOfString:@"wlanuserip"];
    if ((start.location&&end.location)!=NSNotFound) {
        if (logoutUrl) {
            logoutUrl = [logoutUrl substringWithRange:NSMakeRange(start.location, end.location-start.location)];
        }
        [NetworkCore requestGET:logoutUrl parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            
            //显示一键上网
            [ProgressHUD showSuccess:@"断开网络成功"];
            [self stopTimer];
            _isConnectNet = NO;
            _connectNetBtn.selected = NO;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            //显示断开连接
            _connectNetBtn.selected = YES;
            [ProgressHUD showError:@"断开网络失败"];
        }];
        
    }else{
        _connectNetBtn.selected = YES;
        [ProgressHUD showError:@"断开网络失败"];
    }
    
    
    
}
#pragma mark 一键上网接口版本
-(void)newKeyToInternet
{
    if (![NetworkCore wifiIsEqual]) {
        [self alertNotWifi];
        return;
    }
    NSString *urlString = @"http://www.baidu.com";
    NSURL *url = [NSURL URLWithString:urlString];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    _Epurl = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    //字符串截取
    NSRange start = [_Epurl rangeOfString:@"='"];
    NSRange end = [_Epurl rangeOfString:@"/eportal"];
    NSString *fir_url ;
    if (start.location!=NSNotFound&end.location!=NSNotFound) {
        fir_url = [_Epurl substringWithRange:NSMakeRange(start.location+2, end.location-2-start.location)];
    }
    AppUserIndex *user = [AppUserIndex GetInstance];
    fir_url = [NSString stringWithFormat:@"%@/eportal/inferface/authAPI/",fir_url];
    user.BaseUrl = fir_url;
    [user saveToFile];
    NSString *Baseurl = [NSString stringWithFormat:@"%@pageInfo",user.BaseUrl];
    _serviceArr = [NSMutableArray array];
    //获取ePortal配置信息
    NSString *userip = [self getIPAddress];
    NSDictionary *dic=@{
                        @"userip":userip,
                        @"userAgent":[self loadUserAgent],
                        @"queryString":_Epurl
                        };
    [NetworkCore requestOriginlTarget:Baseurl parameters:dic isget:NO block:^(id responseObject) {
        NSDictionary *serVice = [responseObject objectForKey:@"service"];
        NSArray *keyArr = [serVice allKeys];
        _serviceArr = [NSMutableArray arrayWithArray:keyArr];
        [self logintonet];
    }];
    
}
//获取重定向网址   在这里获取BaseUrl  ---
-(NSString *)LoadAgeinEPurl{
    NSString *urlString = @"http://www.baidu.com";
    NSURL *url = [NSURL URLWithString:urlString];
    //第二步，通过URL创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    _Epurl = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    return _Epurl;
}
/**
 *  userAgent
 */
-(NSString *)loadUserAgent
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    if (![AppUserIndex GetInstance].userIp) {
        user.userAgent = secretAgent;
        [user saveToFile];
    }
    return secretAgent;
}

/**
 *获取本机ip
 */
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    //将用户ip存于本地
    if (![AppUserIndex GetInstance].userIp) {
        [AppUserIndex GetInstance].userIp = address;
        [[AppUserIndex GetInstance] saveToFile];
    }
    return address;
}
//检测网络
-(void)NetTest:(NSString *)service
{
    
    // 先做网络判断
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus]==ReachableViaWiFi) {
        NSString *url = @"http://www.baidu.com";
        [NetworkCore requestNormalGET:url parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSData *data = responseObject;
            _Epurl = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *jap = @"<title>百度一下,你就知道</title>";
            NSRange foundObj=[_Epurl rangeOfString:jap options:NSCaseInsensitiveSearch];
            if(foundObj.location!=NSNotFound&&[NetworkCore wifiIsEqual]) {
                _isConnectNet = YES;
                _connectNetBtn.selected = YES;
                [ProgressHUD showSuccess:@"网络连接成功"];
            } else {
                [ProgressHUD dismiss];
                _connectNetBtn.selected = NO;
                if ([NetworkCore wifiIsEqual]) {
                    NSRange start = [_Epurl rangeOfString:@"<script>"];
                    NSRange end = [_Epurl rangeOfString:@"</script>"];
                    if (start.location!=NSNotFound&end.location!=NSNotFound) {
                        _Epurl = [_Epurl substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
                        //字符串截取
                        start = [_Epurl rangeOfString:@"?"];
                        end = [_Epurl rangeOfString:@"'<"];
                        _Epurl = [_Epurl substringWithRange:NSMakeRange(start.location+1, end.location-start.location-1)];
                        if (_Epurl.length==0) {
                            [ProgressHUD showError:@"网络连接失败"];
                            return ;
                        }
                        else{
                            [self logintoInterNet:service];
                        }
                        
                    }else
                    {
                        [ProgressHUD showError:@"网络连接失败"];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD showError:@"网络连接失败"];
        }];
        
    }
    else{
        [ProgressHUD dismiss];
        XGAlertView *noWIFI = [[XGAlertView alloc]initWithTarget:self withTitle:@"未连接无线" withContent:@"请链接正确的无线后使用一键上网" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        noWIFI.tag = 1002;
        noWIFI.delegate = self;
        [noWIFI show];
    }
}
/*
 *一键上网登录
 */
-(void)logintoInterNet:(NSString *)service
{
    //从本地取出用户名 密码 登录
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //用户名
    NSString *username = [ user objectForKey:@"accountId"];
    //密码
    NSString *pwd = [user objectForKey:@"pwd"];
    //登录到网络
    [self loginENonInterNet:username withpwd:pwd withService:service];
    
}
/*
 *一键上网
 */
-(void)loginENonInterNet:(NSString *)username withpwd:(NSString *)pwd withService:(NSString *)service{
    NSString *url = [NSString stringWithFormat:@"%@login",[AppUserIndex GetInstance].BaseUrl];
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *userId = user.accountId;
    NSString *userip = [self getIPAddress];
    NSLog(@"%@",service);
    NSDictionary *dic = @{
                          @"userip":userip,
                          @"userAgent":user.userAgent,
                          @"userId":userId,
                          @"password":pwd,
                          @"service":service,
                          @"queryString":_Epurl,
                          };
    [NetworkCore requestOriginlTarget:url parameters:dic isget:NO block:^(id responseObject) {
        if (responseObject==NULL) {
            [ProgressHUD showError:@"网络连接失败"];
            return ;
        }
        //认证结果 (success 标示认证成功，fail标示认证失败)
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:@"success"]) {
            [ProgressHUD showSuccess:@"网络连接成功"];
            //用户唯一标识，保活以及获取用户信息使用
            NSString *userIndex = [responseObject objectForKey:@"userIndex"];
            //保存userIndex
            user.userIndex = userIndex;
            [user saveToFile];
            _isConnectNet= YES;
            _connectNetBtn.selected = YES;
            //获取用户在线信息
            [self getUserOnlineInfo];
            
            //保活间隔，单位为分钟（0代表不用保活）
            NSString *keepaliveInterval =[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"keepaliveInterval"]];
            if (![keepaliveInterval isEqualToString:@"0"]) {
                //30分钟保活时间
                _netKeepTimer =  [NSTimer scheduledTimerWithTimeInterval:1800.0f target:self selector:@selector(keepAlive) userInfo:nil repeats:YES];
                [_netKeepTimer  fire];
            }
        }else{
            [ProgressHUD showError:responseObject[@"message"] Interaction:NO];
            
        }
    }];
    
    
}
-(void)stopKeepLiveTimer
{
    [_netKeepTimer invalidate];
    _netKeepTimer = nil;
}
/*
 *获取在线信息
 */
-(void)getUserOnlineInfo{
    NSString *onlineUrl =[NSString stringWithFormat:@"%@getOnlineUserInfo",[AppUserIndex GetInstance].BaseUrl];
    NSDictionary *onlineDic = @{
                                @"userIndex":[AppUserIndex GetInstance].userIndex
                                };
    [NetworkCore requestOriginlTarget:onlineUrl parameters:onlineDic isget:NO block:^(id responseObject) {
        if (responseObject==NULL) {
            [ProgressHUD showError:@"获取用户信息失败"];
            return ;
        }
        //userName
        NSString *hello = [NSString stringWithFormat:@"%@%@",[responseObject objectForKey:@"userName"],[responseObject objectForKey:@"welcomeTip"]];
        NSString *time= [NSString stringWithFormat:@"时长:%@",[responseObject objectForKey:@"maxLeavingTime"]];
        NSLog(@"%@%@",hello,time);
    }];
}
/*
 *保活
 */
-(void)keepAlive{
    NSString *keepaliveUrl = [NSString stringWithFormat:@"%@",[AppUserIndex GetInstance].BaseUrl];
    NSDictionary *dic = @{
                          @"userip":[self getIPAddress],
                          @"userIndex":[AppUserIndex GetInstance].userIndex
                          };
    [NetworkCore requestOriginlTarget:keepaliveUrl parameters:dic isget:NO block:^(id responseObject) {
        if (responseObject==NULL) {
            return ;
        }
        if ([[responseObject objectForKey:@"result"]isEqualToString:@"success"]) {
            [ProgressHUD show:[responseObject objectForKey:@"message"]];
        }
        else{
            [ProgressHUD showError:[responseObject objectForKey:@"message"]];
        }
    }];
}
/*
 *断开网络
 */
-(void)LogoutToNet{
    [ProgressHUD show:@"正在断开"];
    NSString *userIndex=[AppUserIndex GetInstance].userIndex;
    if (!userIndex) {
        _connectNetBtn.selected =YES;
        [ProgressHUD showError:@"断开网络失败"];
        return;
    }
    NSString *userip = [self getIPAddress];
    NSDictionary *logoutDic = @{
                                @"userip":userip,
                                @"userIndex":userIndex
                                };
    
    NSString *logoutUrl = [NSString stringWithFormat:@"%@logout",[AppUserIndex GetInstance].BaseUrl];
    
    [NetworkCore requestOriginlTarget:logoutUrl parameters:logoutDic isget:NO block:^(id responseObject) {
        if (responseObject==NULL) {
            [ProgressHUD showError:@"断开网络失败"];
            _isConnectNet=YES;
            _connectNetBtn.selected = YES;
            return ;
        }
        if ([[responseObject objectForKey:@"result"]isEqualToString:@"success"]) {
            [ProgressHUD showSuccess:[responseObject objectForKey:@"message"]];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userIndex"];
            _isConnectNet = NO;
            _connectNetBtn.selected = NO;
            //暂停计时器  ----
            [_netKeepTimer invalidate];
            _netKeepTimer = nil;
        }else{
            [ProgressHUD showError:[responseObject objectForKey:@"message"]];
            _isConnectNet = YES;
            _connectNetBtn.selected = YES;
        }
        
    }];
}
/*
 *一键上网
 */
-(void)logintonet
{
    [self UMengEvent:@"oneKeyNet"];
    
    XGAlertView *alert = [[XGAlertView alloc] initWithListView:@[@"校内网",@"互联网"] complete:^(NSInteger selectIndex) {
        switch (selectIndex) {
            case 0:
                NSLog(@"选中的是校内网");
                //关闭网络监测
            {
                [_myTimer setFireDate:[NSDate distantFuture]];
                [self NetTest:_serviceArr[0]];
            }
                break;
            case 1:
            {
                NSLog(@"选中的是互联网");
                //开启定时器
                [_myTimer setFireDate:[NSDate date]];
                [self NetTest:_serviceArr[1]];
            }
                break;
            default:
                break;
        }
    }];
    [alert show];
}

#pragma mark 弹窗
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

#pragma tableview delegate  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [self.mainTableView startAutoCellHeightWithCellClass:[RepairListTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    
    return _newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"IndexNewsCell";
    IndexNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[IndexNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    IndexNewsCellModel *model = _newsArray[indexPath.row];
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    //    return [self.mainTableView cellHeightForIndexPath:indexPath model:self.dataMutableArr[indexPath.row] keyPath:@"model"];
    return [_newsTableView cellHeightForIndexPath:indexPath model:_newsArray[indexPath.row] keyPath:@"model" cellClass:[IndexNewsCell class] contentViewWidth:kScreenWidth];
    
}
#pragma tableViewcell  点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    IndexNewsCellModel *model = _newsArray[indexPath.row];
    
    switch ([model.appID integerValue]) {
        case 34:
            //照片墙->详情页
        {
            PhotoWallDetailViewController *vc = [[PhotoWallDetailViewController alloc] init];
            vc.picID = model.detailID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 16:{
            FinanceOderListViewController *vc = [[FinanceOderListViewController alloc] init];
            vc.state = @"0";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 0:{
            RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:model.openURL]];//
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:{
            UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
            sender.tag = [model.appID integerValue]-1;
            [[IndexManager shareConfig] buttonViewAction:sender withVC:self];
        }
            
            break;
    }
    
}

/*
 *加载轮播图
 */
-(void)loadBannerImage{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSMutableArray *bannerImageMulArr = [NSMutableArray array];
    _isJumpArr = [NSMutableArray array];
    _imageContentUrlArr = [NSMutableArray array];
    NSDictionary *dic = @{
                          @"rid":@"getBannerInfo"
                          };
    [NetworkCore requestPOST:user.API_URL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqual:@"0x000000"]) {
            NSArray *arr = responseObject[@"data"];
            for (NSDictionary *dic in arr) {
                
                NSString *url = dic[@"picUrl"];
                url = [NSString stringWithFormat:@"%@%@",user.API_URL,url];
                url = [url stringByReplacingOccurrencesOfString:@"index.php/" withString:@""];
                [_isJumpArr addObject:dic[@"isJump"]];
                [_imageContentUrlArr addObject:dic[@"contentUrl"]];
                [bannerImageMulArr addObject:url];
            }
            //加载轮播图数据并开始——————————播放
            _bannerView.adDataArray=bannerImageMulArr;
            [_bannerView loadAdDataThenStart];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
/*
 *获取服务器配置信息
 */
- (void)getConfig{
    if (![AppUserIndex GetInstance].API_URL) {
        return;
    }
    //订单列表信息
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getConfig"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        ConfigObject *config = [ConfigObject shareConfig];
        config.oderStateDic = [responseObject valueForKeyPath:@"data.orderState"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
    //    AppUserIndex *user = [AppUserIndex GetInstance];
    //    if (user.schoolCalenderArr.count==0) {
    //        //获取校历信息
    //        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getSchoolCalendarByCode"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //            [self handleCalender:responseObject[@"data"]];
    //            [user setValue:responseObject[@"data"] forKey:@"schoolCalenderArr"];
    //        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
    //            [ProgressHUD showError:[error objectForKey:@"msg"]];
    //
    //        }];
    //    }
    //    //报修页显示内容
    //    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getOtherType"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //        ConfigObject *config = [ConfigObject shareConfig];
    //        config.repairStateDic = [NSMutableDictionary dictionary];
    //        for (NSDictionary *dic in [responseObject objectForKey:@"state"]) {
    //            [config.repairStateDic setObject:dic[@"des"] forKey:dic[@"id"]];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
    //        ;
    //    }];
    //
    //    //报修撤销原因
    //    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"cancelRepair"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //        DLog(@"%@",responseObject);
    //        ConfigObject *config = [ConfigObject shareConfig];
    //        config.repairCancelResonArr = [NSMutableArray array];
    //        for (NSDictionary *dic in responseObject[@"data"]) {
    //            [config.repairCancelResonArr addObject:dic[@"des"]];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
    //
    //    }];
}
//解析校历
- (void)handleCalender:(NSArray *)array
{
    NSLog(@"%@",array);
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSMutableArray* widArr = [NSMutableArray array];
    NSMutableDictionary *kssjDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *jssjDic = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in array) {
        [widArr addObject:dic[@"WID"]];
        [kssjDic setObject:dic[@"KSSJ"]forKey:dic[@"WID"]];
        [jssjDic setObject:dic[@"JSSJ"] forKey:dic[@"WID"]];
    }
    [user setValue:widArr forKey:@"widArr"];
    [user setValue:kssjDic forKey:@"kssjDic"];
    [user setValue:jssjDic forKey:@"jssjDic"];
}

//获取地理信息
- (void)getLocalInfo{
    //    [AMapServices sharedServices].apiKey = @"111bbc3efbad7a5a929bad1884f286cc";
    
    
    //    [self configLocationManager];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate =self;
    //    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =10;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 10;
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
        }
    }];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        WEAKSELF;
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocation *locationCorrrdinate) {
            NSLog(@"经度%f",locationCorrrdinate.coordinate.latitude);
            NSLog(@"维度%f",locationCorrrdinate.coordinate.longitude);
            NSLog(@"海拔%f",locationCorrrdinate.altitude);
            NSLog(@"速度%f",locationCorrrdinate.speed);
            NSLog(@"方向%f",locationCorrrdinate.course);
            
            
            [NetworkCore requestGET:@"http://restapi.amap.com/v3/assistant/coordinate/convert" parameters:@{@"key":@"df85282f0f2ce43e0448fca647e059d1",@"locations":[NSString stringWithFormat:@"%f,%f",locationCorrrdinate.coordinate.longitude,locationCorrrdinate.coordinate.latitude],@"coordsys":@"gps"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary *dic = [responseObject objectFromJSONString];
                if ([[dic allKeys] containsObject:@"locations"]) {
                    [weakSelf sendLocalInfo:locationCorrrdinate withInfo:dic[@"locations"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                [weakSelf sendLocalInfo:nil withInfo:@""];
            }];
            
        } andErrorBlock:^(NSError *error) {
            NSLog(@"@");
            [weakSelf sendLocalInfo:nil withInfo:@""];
        }];
    }
}

//发送地理信息到服务器
- (void)sendLocalInfo:(CLLocation *)loaction withInfo:(NSString *)station{
    NSLog(@"%@",[NSString stringWithFormat:@"%f,%f",loaction.coordinate.latitude,loaction.coordinate.longitude]);
    [NetworkCore requestGET:@"http://restapi.amap.com/v3/assistant/coordinate/convert" parameters:@{@"key":@"df85282f0f2ce43e0448fca647e059d1",@"locations":[NSString stringWithFormat:@"%f,%f",loaction.coordinate.longitude,loaction.coordinate.latitude],@"coordsys":@"gps"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
    
    
    NSMutableDictionary *commitDic = [NSMutableDictionary dictionary];
    
    if ([NetworkCore getWifiName]) {
        [commitDic setObject:[NSString stringWithFormat:@"%@",[NetworkCore getWifiName]] forKey:@"mWifiSsiD"];
    }
    if ([NetworkCore getBSSID]) {
        [commitDic setObject:[NetworkCore getBSSID] forKey:@"mBSSID"];
    }
    //    [NetworkCore translateMacAdd:@"12:02:2:ad:10:1"];
    //    NSLog(@"%@",[NetworkCore translateMacAdd:@"12:02:2:ad:10:1"]);
    if ([NetworkCore getIPAddress]) {
        [commitDic setObject:[NetworkCore getIPAddress] forKey:@"mIpAddress"];
    }
    
#if TARGET_IPHONE_SIMULATOR
#else
    
    //设置获取mac地址三种方式
    NSString *ip = [Address currentIPAddressOf:@"en0"];
    //way 1
    [ICMP sendICMPEchoRequestTo:ip];
    NSString *mac1 = [ARP walkMACAddressOf:ip];
    
    //way 2
    [ICMP sendICMPEchoRequestTo:ip]; //just for way2 regular steps
    NSString *mac2 = [ARP MACAddressOf:ip];
    
    //way 3
    NSString *mac3 = [MDNS getMacAddressFromMDNS];
    
    NSString *mac = nil;
    if (mac1 && ![mac1 isEqualToString:@"02:00:00:00:00:00"]) {
        mac = mac1;
    }else if (mac2 && ![mac2 isEqualToString:@"02:00:00:00:00:00"]){
        mac = mac2;
    }else if (mac3 && ![mac3 isEqualToString:@"02:00:00:00:00:00"]){
        mac = mac3;
    }else{
        mac = @"";
    }
    
    [commitDic setObject:mac forKey:@"mMacAddress"];
#endif
    
    NSDictionary *netLocation;
    NSArray *locArr = [station componentsSeparatedByString:@","];
    
    if (!loaction || locArr.count != 2) {
        netLocation = @{
                        @"mAltitude":@"",
                        @"mBearing":@"",
                        @"mLongitude":@"",
                        @"mLatitude":@"",
                        @"mAccuracy":@"",
                        @"mSpeed":@"",
                        @"mTime":@"",
                        @"mElapsedRealtimeNanos":@""
                        };
    }else{
        netLocation = @{
                        @"mAltitude":[NSString stringWithFormat:@"%f",loaction.altitude],
                        @"mBearing":[NSString stringWithFormat:@"%f",loaction.course],
                        @"mLongitude":[NSString stringWithFormat:@"%@",locArr[0]],
                        @"mLatitude":[NSString stringWithFormat:@"%@",locArr[1]],
                        @"mAccuracy":@"",
                        @"mSpeed":[NSString stringWithFormat:@"%f",loaction.speed],
                        @"mTime":@"",
                        @"mElapsedRealtimeNanos":@""
                        };
        
    }
    
    NSDictionary *gpslocation = @{
                                  @"mAltitude":@"",
                                  @"mBearing":@"",
                                  @"mLongitude":@"",
                                  @"mLatitude":@"",
                                  @"mAccuracy":@"",
                                  @"mSpeed":@"",
                                  @"mTime":@"",
                                  @"mElapsedRealtimeNanos":@""
                                  };
    NSString *scanResults = @"";
    
    [commitDic setObject:netLocation forKey:@"Netlocation"];
    [commitDic setObject:gpslocation forKey:@"Gpslocation"];
    [commitDic setObject:scanResults forKey:@"ScanResults"];
    
    NSString *commitStr = [[[[BaseConfig toJSONString:commitDic] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",commitStr);
    
    NSString *jsonSrt = [commitStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];;
    NetworkStatus status = [reach currentReachabilityStatus];
    
    NSString *netStatus = @"";
    
    if (status == NotReachable) {
        netStatus = @"not";
    }else if(status == ReachableViaWWAN){
        netStatus = @"4G";
    }else if(status == ReachableViaWiFi){
        //无线情况下开启检测网络连接
        netStatus = @"wifi";
    }
    
    NSDictionary *postDic = @{
                              @"rid":@"saveDeviceInfo",
                              @"deviceId":[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"],
                              @"deviceInfo":jsonSrt,
                              @"deviceTeleNum":@"",
                              @"schoolCode":[AppUserIndex GetInstance].schoolCode
                              };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:postDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        ;
    }];
    
}


//获取用户信息
-(void)queryUserInfo{
    
    [NetworkCore queryUserInfoWithName:[AppUserIndex GetInstance].accountId success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}

//获取用户信息
-(void)queryUserInfo1{
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *username = user.accountId;
    NSDictionary *userDic = @{
                              @"rid":@"queryUserInfo",
                              @"username":username,
                              };
    [NetworkCore requestPOST:user.API_URL parameters:userDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *userArr = [responseObject objectForKey:@"roleInfo"];
        if (userArr.count!=0) {
            for (NSDictionary *dic in userArr) {
                user.role_type = [NSString stringWithFormat:@"%@",dic[@"ROLE_TYPE"]];
                if (dic[@"ROLE_ID"]) {
                    user.role_id = [NSString stringWithFormat:@"%@",dic[@"ROLE_ID"]];
                    //                    user.userName = [NSString stringWithFormat:@"%@",dic[@"ROLE_USERNAME"]];
                }
                
            }
        }else{
            user.role_id = @"";
            user.role_username = @"";
        }
        NSDictionary *resDic = [responseObject objectForKey:@"data"];
        NSDictionary *userDicInfo = [resDic objectForKey:@"samUserInfo"];
        NSRange range = [[userDicInfo objectForKey:@"nextBillingTime"]rangeOfString:@"T"];
        //单例传值
        user.appListArray = responseObject[@"appInfo"];
        user.userName = [userDicInfo objectForKey:@"userName"];
        user.packageName = [userDicInfo  objectForKey:@"packageName"];
        user.accountFee = [userDicInfo objectForKey:@"accountFee"];
        user.atName = [userDicInfo objectForKey:@"atName"];
        user.nextBillingTime = [[userDicInfo objectForKey:@"nextBillingTime"] substringToIndex:range.location];
        user.accountId = [userDicInfo objectForKey:@"accountId"];
        user.policyId = [userDicInfo objectForKey:@"policyId"];
        user.userId = [userDicInfo objectForKey:@"userId"];
        user.currentTime = [resDic objectForKey:@"serverCurrentTime"];
        //        _pakageNameLabel.text = [self getPackageName];
        _userNameLabel.text = [NSString stringWithFormat:@"账户：%@",user.userName];
        user.schoolLogonBackgroundImage = responseObject[@"schoolInfo"][@"SDS_BGIMAGE"];
        
        user.subAccountId = [userDicInfo objectForKey:@"accountId"];
        
        [user saveToFile];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
    
}

- (NSString *)getPackageName{
    //    NSRange range = [[AppUserIndex GetInstance].packageName rangeOfString:@"|b"];
    //    AppUserIndex *user = [AppUserIndex GetInstance];
    //    if (range.length == 0) {
    //        return [NSString stringWithFormat:@"套餐：%@",user.packageName];;
    //    }
    NSArray *arr = [[AppUserIndex GetInstance].packageName componentsSeparatedByString:@"|"];
    return [NSString stringWithFormat:@"套餐：%@",arr[0]];
}

//处理推送消息
- (void)notificationHandler:(NSNotification *)userInfo{
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo.object valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo.object valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    //    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
    //
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        btn.tag = [[userInfo.object valueForKey:@"moudle"] integerValue];
    //        [self buttonViewAction:btn];
    //
    //    }else{
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        btn.tag = [[userInfo.object valueForKey:@"moudle"] integerValue];
    //        [self buttonViewAction:btn];
    //    }
    //跳转到相应的模块
    
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.tag = [[userInfo.object valueForKey:@"moudle"] integerValue]-1;
    //    [self buttonViewAction:btn];
    [self pustAction:userInfo.object];
}

- (void)pustAction:(NSDictionary *)userInfo{
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
    //    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
    //
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        btn.tag = [[userInfo.object valueForKey:@"moudle"] integerValue];
    //        [self buttonViewAction:btn];
    //
    //    }else{
    //        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        btn.tag = [[userInfo.object valueForKey:@"moudle"] integerValue];
    //        [self buttonViewAction:btn];
    //    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[userInfo JSONString] delegate:self cancelButtonTitle:@"yes" otherButtonTitles: nil];
    //    [alert show];
    //跳转到相应的模块
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [[userInfo valueForKey:@"moudle"] integerValue]-1;

    [self buttonViewAction:btn];
}


#pragma mark - ZWAdViewDelegate  轮播图点击事件
-(void)adView:(ZWAdView *)adView didDeselectAdAtNum:(NSInteger)num{
    NSLog(@"-click index>%ld",(long)num);
    if (_imageContentUrlArr.count!=0&&_isJumpArr.count!=0) {
        NSString *tag = [NSString stringWithFormat:@"%@",_isJumpArr[num]];
        if ([tag isEqualToString:@"1"]) {
            //打开
            AboutUsViewController *vc = [[AboutUsViewController alloc]init];
            vc.baseUrl = [NSString stringWithFormat:@"%@",_imageContentUrlArr[num]];
            vc.hidesBottomBarWhenPushed = YES;
            vc.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSLog(@"不打开");
        }
    }
    
}
-(BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark PingNet 网络监测
/*
 *网络状态实时监测（10s）
 */
-(void)networkTest{
    NSString *url = @"http://www.baidu.com";
    [NetworkCore requestNormalGET:url parameters:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *Epurl = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jap = @"<title>百度一下,你就知道</title>";
        NSRange foundObj=[Epurl rangeOfString:jap options:NSCaseInsensitiveSearch];
        
        foundObj.length> 0?(_isConnectNet = YES) : (_isConnectNet = NO);
        
        //先检测是否联网以及是不是规定的wifi
        if(_isConnectNet == YES &&[NetworkCore wifiIsEqual]) {
            _connectNetBtn.selected = YES;
        }else{
            _connectNetBtn.selected = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        _connectNetBtn.selected = NO;
    }];
}
/*
 *开启网络监测的监听
 */
-(void)testStatusCheck{
    ///开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    //开始监听，会启动一个run loop;
    [reach startNotifier];
}
#pragma mark Reachbility Delegate
/**
 *  网络状态监测  数据情况下停止检测网络连接
 */
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reach currentReachabilityStatus];
    
    if (status == NotReachable) {
        _connectNetBtn.selected = NO;
    }
    if(status == ReachableViaWWAN){
        _connectNetBtn.selected = NO;
        [self stopTimer];
    }
    
    if(status == ReachableViaWiFi){
        //无线情况下开启检测网络连接
        [self startTimer];
        if (![NetworkCore wifiIsEqual])
        {
            _connectNetBtn.selected = NO;
        }
    }
    
}

#pragma mark XGAlertView Delegate
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    
    switch (view.tag) {
        case 1001:
        {
            
        }
            break;
        case 1002:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
            break;
        case 1003:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4007661616"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1004:
        {
            //再次进行一键上网
            if (ISNEWVERSION) {
                [self newKeyToInternet];
                
            }else{
                [self oneKeyToNet];
            }
        }
            break;
        case 1005:
        {
            //报修
            UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
            sender.tag = 1;
            [[IndexManager shareConfig] buttonViewAction:sender withVC:self];
            
        }
            break;
            
        default:
            break;
    }
    
}
- (void)openSignVC{
    
    SignViewController *vc = [[SignViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//弹出视图点击事件
-(void)itemDidSelectedIconSlectIndex:(UIButton *)btn{
    [self buttonViewAction:btn];
    
}
-(void)dealloc
{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:AllFunctionNotication object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:RemoveFunctionNotication object:nil];

    

}

#pragma mark  NAV代理事件

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
