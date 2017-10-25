//
//  TechInitSignViewController.m
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "TechInitSignViewController.h"
#import "UIView+SDAutoLayout.h"
#import "WIFICellModel.h"
#import <YYModel.h>
@interface TechInitSignViewController ()
{
    NSTimer *_sitnTimer;
}
@property (nonatomic,strong)UILabel *titleL;//目前签到人数
@property (nonatomic,strong)UILabel *stuNumL;//当期啊签到人数
@property (nonatomic,strong)UILabel *duePeoNum;//应到人数
@property (nonatomic,strong)UILabel *askLeavPeoNum;//请假人数
@property (nonatomic,strong)UIButton *refreshBtn;
@property (nonatomic,strong)UIButton *endSignBtn;//结束签到


@property (nonatomic,strong)UIImageView *backgroundImageV;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIImageView *footerView;
@property (nonatomic,strong)UIScrollView *mainScroView;
//@property (nonatomic,assign)int  stuNumber;
@property (nonatomic,strong)UIActivityIndicatorView* activityIndicatorView;
@end

@implementation TechInitSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self createNavView];
    self.view.backgroundColor = Base_Color2;
    self.title = @"正在签到...";
    _sitnTimer = [NSTimer scheduledTimerWithTimeInterval:7
                                                        target:self
                                                      selector:@selector(loadNumData)
                                                      userInfo:nil
                                                       repeats:YES];;
//    [_timer fire];
    [[NSRunLoop mainRunLoop] addTimer:_sitnTimer forMode:NSRunLoopCommonModes];
}
-(void)createNavView
{
    self.activityIndicatorView=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake(10, 0, 50, 50)];
    [self.activityIndicatorView setCenter:CGPointMake(10, 0)];

    //设置 风格;
    self.activityIndicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    //hidesWhenStopped默认为YES，会隐藏活动指示器。要改为NO
    self.activityIndicatorView.hidesWhenStopped=YES;
    //启动
    [self.activityIndicatorView startAnimating];

    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem = barItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [_timer invalidate];
//    _timer = nil;
}
-(BOOL)navigationShouldPopOnBackButton
{
    return NO;
}
-(void)createView
{
    self.backgroundImageV = ({
        UIImageView *view  = [UIImageView new];
        view.image = [UIImage imageNamed:@"wifi_Signbg.jpg"];
        view.contentMode = UIViewContentModeScaleToFill;
        view.userInteractionEnabled = YES;
        view;
    });
    [self.view addSubview:self.backgroundImageV];
    self.backgroundImageV.sd_layout.leftSpaceToView(self.view,0).widthIs(kScreenWidth).bottomSpaceToView(self.view,0);
    self.mainScroView = ({
        UIScrollView *view = [UIScrollView new];
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;

        view.backgroundColor = RGB_Alpha(255, 255, 255, 0.1);
        view.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        view;
    });
    [self.backgroundImageV addSubview:self.mainScroView];
    self.mainScroView.sd_layout.leftSpaceToView(self.backgroundImageV,0).widthIs(kScreenWidth).topSpaceToView(self.backgroundImageV,0).heightIs(kScreenHeight);

    self.headView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB_Alpha(255, 255, 255, 0.1);
        view;
    });
    [self.mainScroView addSubview:self.headView];
    self.headView.sd_layout.leftSpaceToView(self.mainScroView,0).topSpaceToView(self.mainScroView,0).widthIs(kScreenWidth).heightIs(kScreenHeight*0.45);
    

    self.titleL = ({
        UILabel *view = [UILabel new];
        view.text = @"目前签到人数";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    self.stuNumL = ({
        UILabel *view = [UILabel new];
        view.text = @"0";
        view.font = [UIFont systemFontOfSize:86];
        view.textColor = RGB(94,65,38);
        view.textAlignment = NSTextAlignmentCenter;
        view;
    });
    self.duePeoNum = ({
        UILabel *view = [UILabel new];
        view.text = @"应到人数:  0";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    self.askLeavPeoNum = ({
        UILabel *view = [UILabel new];
        view.text = @"请假人数:  0";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(66, 66, 66);
        view;
    });
    self.refreshBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
//        view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0];
//        [view setTitle:@"刷新" forState:UIControlStateNormal];
//        view.titleLabel.font = [UIFont systemFontOfSize:13];
//        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        view.layer.cornerRadius = 13;
        [view setImage:[UIImage imageNamed:@"wifi_refreshsignState"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(loadNumData) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    [self.headView sd_addSubviews:@[self.titleL,self.stuNumL,self.duePeoNum,self.askLeavPeoNum,self.refreshBtn]];
    self.titleL.sd_layout.topSpaceToView(self.headView,30).centerXIs(self.headView.centerX).widthIs(86).heightIs(15);
    self.stuNumL.sd_layout.topSpaceToView(self.titleL,12).centerXIs(self.headView.centerX).widthIs(90).heightIs(80);
    self.duePeoNum.sd_layout.topSpaceToView(self.stuNumL,12).centerXIs(self.headView.centerX).widthIs(90).heightIs(15);
    self.askLeavPeoNum.sd_layout.topSpaceToView(self.duePeoNum,12).centerXIs(self.headView.centerX).widthIs(90).heightIs(15);
    self.refreshBtn.sd_layout.topSpaceToView (self.askLeavPeoNum,16).centerXIs(self.headView.centerX).widthIs(121).heightIs(25);
    [self.headView setupAutoHeightWithBottomView:self.refreshBtn bottomMargin:20];
    
    CGSize size = [self.titleL boundingRectWithSize:CGSizeMake(0, 15)];
    self.titleL.sd_layout.widthIs(size.width);
    size = [self.stuNumL boundingRectWithSize:CGSizeMake(0, 80)];
    self.stuNumL.sd_layout.widthIs(size.width);
    size = [self.duePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    self.duePeoNum.sd_layout.widthIs(size.width);
    size = [self.askLeavPeoNum boundingRectWithSize:CGSizeMake(0, 15)];
    self.askLeavPeoNum.sd_layout.widthIs(size.width);
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++底部视图++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    self.footerView = ({
        UIImageView *view = [UIImageView new];
        view.userInteractionEnabled = YES;
        view.image = [UIImage imageNamed:@"wifi_fotView"];
        view;
    });
    
    [self.mainScroView addSubview:self.footerView];
    self.footerView.sd_layout.leftSpaceToView(self.mainScroView,0).widthIs(kScreenWidth).topSpaceToView(self.headView,0);
    UIButton *footerTitle = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"签到班级" forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"wifi_signT"] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:36];
        view.userInteractionEnabled = NO;
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view;
    });
    [self.footerView addSubview:footerTitle];
    footerTitle.sd_layout.centerXIs(self.footerView.centerX).topSpaceToView(self.footerView,25).widthIs(140).heightIs(34);
    UIView *classBackView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0];
        view;
    });
    [self.footerView addSubview:classBackView];
    classBackView.sd_layout.leftSpaceToView(self.footerView,0).widthIs(kScreenWidth).topSpaceToView(footerTitle,34);
//    NSArray *classArr = [_classString componentsSeparatedByString:@","];
//    NSArray *classNameArr = [_classNameString componentsSeparatedByString:@","];
    for (int i =0 ; i<_classArr.count; i++) {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"wifi_class"] forState:UIControlStateNormal];
        [view setTitle:_classNameArr[i] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        view.userInteractionEnabled = NO;
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [classBackView addSubview:view];
        view.sd_layout.centerXIs(classBackView.centerX).topSpaceToView(classBackView,i*(14+12)).widthIs(100).heightIs(14);
        size = [view.titleLabel boundingRectWithSize:CGSizeMake(0, 14)];
        view.titleLabel.sd_layout.widthIs(size.width+view.imageView.size.width+10);
        [classBackView setupAutoHeightWithBottomView:view bottomMargin:15];
    }
    
    self.endSignBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"wifi_endSign"] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(endSignAction) forControlEvents:UIControlEventTouchUpInside];

        view;
    });
    size = [footerTitle.titleLabel boundingRectWithSize:CGSizeMake(0, 34)];
    footerTitle.sd_layout.widthIs(size.width+footerTitle.imageView.size.width+10);
    

    [self.footerView addSubview:self.endSignBtn];
    self.endSignBtn.sd_layout.leftSpaceToView(self.footerView,13).rightSpaceToView(self.footerView,13).topSpaceToView(classBackView,35).heightIs(41);
    [self.footerView setupAutoHeightWithBottomView:self.endSignBtn bottomMargin:30];
    [self.headView updateLayout];
    [self.footerView updateLayout];
    [classBackView updateLayout];

    if (self.footerView.size.height>(kScreenHeight-self.headView.size.height)) {
        [self.footerView setupAutoHeightWithBottomView:self.endSignBtn bottomMargin:30];
        [self.mainScroView setupAutoContentSizeWithBottomView:self.footerView bottomMargin:60];

    }else{

        self.endSignBtn.sd_layout.leftSpaceToView(self.footerView,13).rightSpaceToView(self.footerView,13).topSpaceToView(classBackView,(kScreenHeight-self.headView.size.height-25-34-34-classBackView.size.height-41-30-40-37/2)).heightIs(41);

        [self.endSignBtn updateLayout];
        [self.mainScroView setupAutoContentSizeWithBottomView:self.footerView bottomMargin:0];
    }
    
}
//请求数据
-(void)loadNumData{
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    NSString *classString = [self.classArr componentsJoinedByString:@","];
    [NetworkCore requestPOST:url parameters:@{@"rid":@"showSignCountByClass",@"userid":teacherNum,@"role":[AppUserIndex GetInstance].role_type,@"courseid":_courseID,@"class":classString} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
      
        WIFICellModel *model = [WIFICellModel new];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [model yy_modelSetWithDictionary:dic];
        }
        
        self.duePeoNum.text = [NSString stringWithFormat:@"应到人数   %@",model.yd_count];
        self.askLeavPeoNum.text = [NSString stringWithFormat:@"请假人数    %@",model.qj_count];
        self.stuNumL.text = [NSString stringWithFormat:@"%@",model.sd_count];
        
        CGSize size = [self.titleL boundingRectWithSize:CGSizeMake(0, 15)];
        self.titleL.sd_layout.widthIs(size.width);
        size = [self.stuNumL boundingRectWithSize:CGSizeMake(0, 80)];
        self.stuNumL.sd_layout.widthIs(size.width);
        size = [self.duePeoNum boundingRectWithSize:CGSizeMake(0, 15)];
        self.duePeoNum.sd_layout.widthIs(size.width);
        size = [self.askLeavPeoNum boundingRectWithSize:CGSizeMake(0, 15)];
        self.askLeavPeoNum.sd_layout.widthIs(size.width);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        [_sitnTimer invalidate];
    }];
    //刷新数据
}
//结束签到
-(void)endSignAction
{
    NSString *url = @"http://123.233.121.17:15100/index.php";//[AppUserIndex GetInstance].API_URL
    NSString *classString = [self.classArr componentsJoinedByString:@","];
    [NetworkCore requestPOST:url parameters:@{@"rid":@"endPoint",@"userid":teacherNum,@"role":[AppUserIndex GetInstance].role_type,@"courseid":_courseID,@"class":classString} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            //返回上个界面
        [_sitnTimer invalidate];
        _sitnTimer = nil;
        [self.navigationController popViewControllerAnimated:YES ];
        [self.activityIndicatorView stopAnimating];
        /*
         
         tls_id 发起签到ID
         yhbh  用户编号
         sds_code 学校识别码
         tls_class 签到班级
         bjm 班级名称
         tls_creattime 创建时间
         tls_kch 课程号
         tls_kcmc 课程名称
         tls_name 发起签到的名称
         tls_state 签到状态

         */
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_sitnTimer invalidate];
        _sitnTimer = nil;
        [self.navigationController popViewControllerAnimated:YES ];
        [self.activityIndicatorView stopAnimating];
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
