//
//  ShuihuaqiangViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/16.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ShuihuaqiangViewController.h"
#import "RFTagCloudView.h"
#import "RFTagCloudPageView.h"
#import "XGAlertView.h"
#import "Reachability.h"

@interface ShuihuaqiangViewController ()<RFTagCloudViewDelegate,UITextFieldDelegate>
{
    RFTagCloudView *_tagView;
    NSTimer *_timer;
}

@property (nonatomic, strong) NSMutableArray *dataMulArray;
@property (nonatomic, assign) BOOL isWifi;

@end



@implementation ShuihuaqiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"水花墙";
    [self createViews];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(loadData)
                                   userInfo:self
                                    repeats:YES];
    
    NSArray *colorArray=@[RGB(51, 51, 51),RGB(102, 102, 102),RGB(102, 153, 0),RGB(0, 153, 255),RGB(255, 102, 0),RGB(255, 51, 51)];

    _tagView = [[RFTagCloudView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [_tagView drawCloudWithWords:@[] colors:colorArray rowHeight:([UIScreen mainScreen].bounds.size.height-64)/15];
    _tagView.delegate = self;
    [self.view addSubview:_tagView];
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus]==ReachableViaWiFi){
        [self loadData];
    }else{
        [self loadData4G];
    }
}

- (void)createViews{
    //第三种方式（自定义按钮）
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 33, 32);
    [rightButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"finance_add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnClick:(UIButton *)sender{
    WEAKSELF;
    XGAlertView *alert = [[XGAlertView alloc] initWithTitle:@"请输入文字" withUnit:@"" click:^(NSString *index){
        if (index.length <= 15) {
            [weakSelf sendMsg:index];
        }else{
            [ProgressHUD showError:@"字符过长，请输入15位以内的字"];
        }
        
    }];
    alert.textField.keyboardType = UIKeyboardTypeDefault;
    alert.textField.placeholder = @"请输入15字内";
    [alert.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [alert show];
}

- (void)textFieldDidChange:(UITextField *)textField{
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
    }
}



- (void)sendMsg:(NSString *)string{
    NSDictionary *commitDic = @{
                                @"rid":@"addWaterWallInfo",
                                @"content":string,
                                @"userid":[AppUserIndex GetInstance].accountId
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
}

- (void)loadData{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([r currentReachabilityStatus]==ReachableViaWiFi) {
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getWaterWallInfo",@"scount":@"15"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            _dataMulArray = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {
                [_dataMulArray addObject:dic[@"WWCONTENT"]];
            }
            [_tagView addPages:_dataMulArray];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [self showErrorViewLoadAgain:error[@"msg"]];
        }];
    }else{
        [self showErrorViewLoadAgain:@"网络似乎出了一些问题，请稍后重试"];
    }
    
}

//流量下执行，一次
- (void)loadData4G{
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getWaterWallInfo",@"scount":@"15"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataMulArray = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [_dataMulArray addObject:dic[@"WWCONTENT"]];
        }
        [_tagView addPages:_dataMulArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];

    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
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
