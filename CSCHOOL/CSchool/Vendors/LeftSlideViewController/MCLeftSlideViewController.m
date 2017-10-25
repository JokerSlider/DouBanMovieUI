//
//  MCLeftSlideViewController.m
//  LeftSlideViewController
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 machao. All rights reserved.
//
#import "MCLeftSlideViewController.h"
#import "MCLeftSliderManager.h"
#import "SettingLeftViewController.h"

#define kUserDefaults     [NSUserDefaults standardUserDefaults]

// 屏幕宽度
#define kScreenRect   [[UIScreen mainScreen] bounds]

#define kScreenSize           [[UIScreen mainScreen] bounds].size

#define kMainPageDistance   70   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale   1.0  //打开左侧窗时，中视图(右视图）缩放比例
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat   0.7    //滑动速度

#define kLeftAlpha 0.9  //左侧蒙版的最大值
#define kLeftCenterX 0 //左侧初始偏移量
#define kLeftScale 1.0 //左侧初始缩放比例
//#define kLeftSwitchViewCenterX 0
#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag

// 颜色的定义
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kColorWithRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
//项目整体背景色
#define MCBaseColor kColorWithRGB(0xf6f6f6)

#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define FONT(fontSize)                      [UIFont systemFontOfSize:fontSize]


@interface MCLeftSlideViewController ()<UIGestureRecognizerDelegate,UITabBarControllerDelegate>
{
    CGFloat _scalef;  //实时横向位移
}

@property (nonatomic,strong) UITableView *leftTableview;
@property (nonatomic,assign) CGFloat leftTableviewW;
@property (nonatomic,strong) UIView *contentView;
@property(nonatomic,weak)UISwitch * leftSwitch;
@end


@implementation MCLeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
}

/**
 @brief 初始化侧滑控制器
 @param leftVC 左视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UITabBarController *)mainVC
{
    if(self = [super init]){
        self.speedf = vSpeedFloat;
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        mainVC.delegate = self;
        [self addChildViewController:self.leftVC];
        [self addChildViewController:self.mainVC];
        //滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
        
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        
        [self.view addSubview:self.leftVC.view];
        
        //蒙版
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVC.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.contentView = view;
        [self.leftVC.view addSubview:view];
        
        //获取左侧tableview
        for (UIView *obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableview = (UITableView *)obj;
            }
        }
        self.leftTableview.backgroundColor = [UIColor clearColor];
        self.leftTableview.frame = CGRectMake(kMainPageDistance, (kScreenHeight - 300)/2, kScreenWidth - kMainPageDistance*1.5, 300);
        //设置左侧tableview的初始位置和缩放系数
        self.leftTableview.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        [self.view addSubview:self.leftVC.view];
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
        [MCLeftSliderManager  sharedInstance].LeftSlideVC = self;
        [MCLeftSliderManager sharedInstance].mainNavigationController = mainVC.viewControllers.firstObject;
        UINavigationController *navVC =(UINavigationController *)mainVC.viewControllers.firstObject;
        UIViewController *firstVC = navVC.viewControllers.firstObject;
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.frame = CGRectMake(0, 0, 20, 18);
        [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
        firstVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        
    }
    
    
    return self;
}

- (instancetype)initWithLeftView:(UIViewController *)leftVC
                   andMainVCView:(UINavigationController *)mainVC{
    if(self = [super init]){
        self.speedf = vSpeedFloat;
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        mainVC.delegate = self;
        [self addChildViewController:self.leftVC];
        [self addChildViewController:self.mainVC];
        //滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
        
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        
        [self.view addSubview:self.leftVC.view];
        
        //蒙版
        UIView *view = [[UIView alloc] init];
        view.frame = self.leftVC.view.bounds;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        self.contentView = view;
        [self.leftVC.view addSubview:view];
        
        //获取左侧tableview
        for (UIView *obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableview = (UITableView *)obj;
            }
        }
        self.leftTableview.backgroundColor = [UIColor clearColor];
        self.leftTableview.frame = CGRectMake(35, 220, kScreenWidth - kMainPageDistance*1.5, kScreenHeight-220-60);
        //设置左侧tableview的初始位置和缩放系数
        self.leftTableview.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        [self.view addSubview:self.leftVC.view];
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
        [MCLeftSliderManager  sharedInstance].LeftSlideVC = self;
        [MCLeftSliderManager sharedInstance].mainNavigationController = mainVC;
        UINavigationController *navVC =(UINavigationController *)mainVC;
        UIViewController *firstVC = navVC.viewControllers.firstObject;
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuBtn setImage:[self OriginImage:PlaceHolder_Image scaleToSize:CGSizeMake(35, 35)] forState:UIControlStateNormal];
        menuBtn.backgroundColor = [UIColor whiteColor];
        menuBtn.frame = CGRectMake(0, 0, 35, 35);
        menuBtn.layer.cornerRadius = 17.5;
        menuBtn.clipsToBounds = YES;
//        menuBtn.backgroundColor = [UIColor redColor];
        menuBtn.tag = 2020;
        [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
        firstVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    }
    
    
    return self;
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void) openOrCloseLeftList
{
    
    if ([MCLeftSliderManager sharedInstance].LeftSlideVC.closed)
    {
        [[MCLeftSliderManager sharedInstance].LeftSlideVC openLeftView];
    }
    else
    {
        [[MCLeftSliderManager sharedInstance].LeftSlideVC closeLeftView];
    }
}


#pragma mark - 滑动手势

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:self.view];
    _scalef = (point.x * self.speedf + _scalef);
    
    BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
    if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance )) && (_scalef >= 0)))
    {
        //边界值管控
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    //根据视图位置判断是左滑还是右边滑动
    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (kScreenWidth - kMainPageDistance)))
    {
        CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
        if (recCenterX < kScreenWidth * 0.5 - 2) {
            recCenterX = kScreenWidth * 0.5;
        }
        
        CGFloat recCenterY = rec.view.center.y;
        
        rec.view.center = CGPointMake(recCenterX,recCenterY);
        
        //scale 1.0~kMainPageScale
        CGFloat scale = 1 - (1 - kMainPageScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        
        //leftScale kLeftScale~1.0
        CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        
        self.leftVC.view.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
        self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        //tempAlpha kLeftAlpha~0
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
        self.contentView.alpha = tempAlpha;
        
    }
    else
    {
        //超出范围，
        if (self.mainVC.view.x < 0)
        {
            [self closeLeftView];
            _scalef = 0;
        }
        else if (self.mainVC.view.x > (kScreenWidth - kMainPageDistance))
        {
            [self openLeftView];
            _scalef = 0;
        }
    }
    
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (rec.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance)
        {
            if (self.closed)
            {
                [self openLeftView];
            }
            else
            {
                [self closeLeftView];
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
            }
            else
            {
                [self openLeftView];
            }
        }
        _scalef = 0;
    }
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        
        self.leftVC.view.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
        self.contentView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        _scalef = 0;
        [self removeSingleTap];
    }
    
}

#pragma mark - 修改视图位置
/**
 @brief 关闭左视图
 */
- (void)closeLeftView
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    self.closed = YES;
    
    self.leftVC.view.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
    self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}

/**
 @brief 打开左视图
 */
- (void)openLeftView;
{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
    self.mainVC.view.center = kMainPageCenter;
    self.closed = NO;
    
    
    self.leftVC.view.center = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
    self.leftVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    [self disableTapButton];
}

#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    for (UIButton *tempButton in [_mainVC.view subviews])
    {
        [tempButton setUserInteractionEnabled:NO];
    }
    //单击
    if (!self.sideslipTapGes)
    {
        //单击手势
        self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        
        [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
    }
}

//关闭行为收敛
- (void) removeSingleTap
{
    for (UIButton *tempButton in [self.mainVC.view  subviews])
    {
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes = nil;
}

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */

- (void)setPanEnabled: (BOOL) enabled
{
    [self.pan setEnabled:enabled];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if(touch.view.tag == vDeckCanNotPanViewTag)
    {
        //        NSLog(@"不响应侧滑");
        return NO;
    }
    else
    {
        //        NSLog(@"响应侧滑");
         [(SettingLeftViewController *)_leftVC updateUserInfo];
        return YES;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [MCLeftSliderManager sharedInstance].mainNavigationController = (UINavigationController *)viewController;
}

@end
