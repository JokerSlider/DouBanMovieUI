//
//  SchoolBusInfoViewController.m
//  CSchool
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SchoolBusInfoViewController.h"
#import "SchoolBusView.h"
#import "UIView+SDAutoLayout.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "BusListViewController.h"
#import "BusRouteViewController.h"


@interface SchoolBusInfoViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate>
{
    NSTimer *_timer;
}
@property(nonatomic,strong)SchoolBusView *navView;
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;


@property (nonatomic, retain) BusListViewController *busListVC;//找东西

@property (nonatomic, retain) BusRouteViewController *busRoteVC;//找失主


@property (nonatomic, retain) NSArray *busStationArray;

@property (nonatomic, retain) NSArray *busLocationArray;

@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *engTime;

@property (nonatomic,copy)NSString  *retainBusID;//替换的id
@property (nonatomic,copy)NSString *originBusID;//原始的id
@property (nonatomic,copy)NSString *changeBusID;//区分上行下行 的ID 由上个界面传过来


@end

@implementation SchoolBusInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Base_Color2;
    [self setNavView];
    
//    [self loadData];
//    [self loadBusInfo];
    

    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:10
                                            target:self
                                          selector:@selector(loadBusInfo)
                                          userInfo:self
                                           repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

-(void)setNavView
{
    _navView = [SchoolBusView new];
    self.title = _model.busName;
    _originBusID = [NSString stringWithFormat:@"%@",_model.busLodId];
    _changeBusID = _originBusID;
    _navView.model = _model;
    [_navView.chooseBusBtn addTarget:self action:@selector(chooseBusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
    _navView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(65);
    //分段视图
    _busListVC = [[BusListViewController alloc]init];
    _busRoteVC = [[BusRouteViewController alloc]init];

    
    NSArray *controllers=@[_busListVC,_busRoteVC];
    NSArray *titleArr = @[@"站列表",@"线路图"];
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 65,kScreenWidth, 40) withDataArray:titleArr withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40+65, kScreenWidth, self.view.frame.size.height - 40-65-64) withArray:controllers withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];
    
    [self loadData];
    [self loadBusInfo];
    _timer = [NSTimer scheduledTimerWithTimeInterval:10
                                              target:self
                                            selector:@selector(loadBusInfo)
                                            userInfo:self
                                             repeats:YES];

}

- (void)loadData{
    [ProgressHUD show:@"正在加载站点信息..."];
    NSDictionary *commitDic = @{
                                @"rid":@"getBusStateInfo",
                                @"devicegroupId":_changeBusID
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        
        [_timer setFireDate:[NSDate date]];
        
        _busStationArray = responseObject[@"data"];
        _navView.startTime.text = [NSString stringWithFormat:@"%@",responseObject[@"info"][@"first"]];
        _navView.endTime.text = [NSString stringWithFormat:@"%@",responseObject[@"info"][@"end"]];
        [_busRoteVC.busView addStationView:_busStationArray];
        [_busListVC addStationArr:_busStationArray];
        //切换的公交路线ID
        _retainBusID = [NSString stringWithFormat:@"%@",responseObject[@"reverse"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_timer setFireDate:[NSDate distantFuture]];
        _timer = nil;
        [_busRoteVC.busView addStationView:@[]];

        [_busListVC showErrorView:error[@"msg"] andImageName:nil];
    }];
}

- (void)loadBusInfo{
    NSDictionary *commitDic = @{
                                @"rid":@"getBusLocation",
                                @"deviceGroupId":_changeBusID,
                                @"schoolCode":@"sdmu"
                                };
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:commitDic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _busLocationArray = responseObject[@"data"];
        [_busRoteVC.busView addBusView:_busLocationArray];
        [_busListVC addBusLocationArr:_busLocationArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [_busRoteVC.busView addBusView:@[]];
    }];
}

-(void)setModel:(SchooBusModel *)model
{
    _model = model;
}
#pragma mark -------- select Index
-(void)selectedIndex:(NSInteger)index
{
    if (index==0) {

    }else{
      
    }
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {
        
        
    }else{
        //加载路线图
    }
    [self.segment selectIndex:index];
}

#pragma mark  选择路线
-(void)chooseBusAction:(UIButton *)sender
{
    //切换公交上行下行的名成  浆水泉->高新区  改为  高新区->浆水泉
    if (sender.selected) {
        _changeBusID = _originBusID;
    }else{
        _changeBusID = _retainBusID;
    }
    sender.selected = !sender.selected;
    [self loadData];
    [self loadBusInfo];
//    [self performSelector:@selector(loadBusInfo) withObject:nil afterDelay:0.5];
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
