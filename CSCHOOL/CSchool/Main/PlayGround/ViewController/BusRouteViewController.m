//
//  BusRouteViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/16.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BusRouteViewController.h"
#import "XGBusRouteView.h"
#import "SDAutoLayout.h"

@interface BusRouteViewController ()
{
    NSTimer *_timer;
}
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) UIScrollView *mainScrollView;

@end

@implementation BusRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = RGB(245, 245, 245);
    [self createView];
//    [self loadData];
//    [self loadBusInfo];
    

    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100, 0, 100, 30)];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(loadBusInfo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self startTimer];
}

- (void)startTimer{
//    _timer = [NSTimer scheduledTimerWithTimeInterval:10
//                                              target:self
//                                            selector:@selector(loadBusInfo)
//                                            userInfo:self
//                                             repeats:YES];
//    [self loadBusInfo];

}

- (void)stopTimer{
//    [_timer invalidate];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self stopTimer];
}

- (void)createView{
    
    _mainScrollView = [[UIScrollView alloc] init];

    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);

    CGFloat viewHeight = (kScreenHeight-64-70-45>389)?(viewHeight = kScreenHeight-64-70-45):(viewHeight = 389);
    _busView = [[XGBusRouteView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, viewHeight)];
    _busView.backgroundColor = [UIColor whiteColor];
    _busView.backgroundColor = RGB(245, 245, 245);
    [_mainScrollView addSubview:_busView];
    [_mainScrollView setupAutoContentSizeWithBottomView:_busView bottomMargin:20];
}

- (void)loadData{
    NSDictionary *commitDic = @{
                                @"rid":@"getBusStateInfo",
                                @"devicegroupId":_changeBusID
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _dataArray = responseObject[@"data"];
        [_busView addStationView:_dataArray];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}

- (void)loadBusInfo{
    NSDictionary *commitDic = @{
                                @"rid":@"getBusLocation",
                                @"deviceGroupId":_changeBusID,
                                @"schoolCode":@"sdmu"
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {

        [_busView addBusView:responseObject[@"data"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {

    }];
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
