//
//  CSportViewController.m
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "CSportViewController.h"
#import "SportsMainCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "SportsMainViewController.h"
#import "SportInfoViewController.h"
#import "HealthManager.h"
#import <YYModel.h>
#import <MJRefresh.h>
#import "HealthManager.h"

@interface CSportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *sportModelArray;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;//转换数组

@property (nonatomic,assign)int  page;//分页

@property (nonatomic,copy)NSString *regionName;
@end

@implementation CSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菁彩运动";
    self.page = -2;
    //创建视图
    [self createView];
    //获取读取系统健康数据申请
    [self getHealthPermissons];
    //加载数据
    [self loadData];

    //初始化一遍
    _sportModelArray = [NSMutableArray array];
    
    [[HealthManager shareInstance] startLocation];//开始定位


}
#pragma mark   记得注释
-(NSString *)getLocationName
{
//    NSString *rigionLoctionName ;
    WEAKSELF;
    [HealthManager shareInstance].loctationBlock = ^(NSArray *objArr,NSArray *locationNameArr){
        NSString *locationName = [locationNameArr componentsJoinedByString:@""];
        SportModel *model = [_sportModelArray lastObject];
        model.SDSNAME = locationName;
        //        [weakSelf.mainTableView reloadData];
    };

    return _regionName;
}
- (void)removeLocalNotification {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notifications) {
        return;
    }
    for (UILocalNotification *notification in notifications) {
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@"sportNotifi"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
}
//本地推送
-(void)getLocalNotification
{
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notifications) {
        return;
    }
    for (UILocalNotification *notification in notifications) {
        if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@"sportNotifi"]) {
            return  ;
//            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //设置时区（跟随手机的时区）
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    if (localNotification) {
        localNotification.alertBody = @"您今天的健康运动信息已经统计完毕，赶快来看看吧~";
//        localNotification.alertTitle = @"菁彩运动";
        //小图标数字
        localNotification.applicationIconBadgeNumber = 1;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSDate *date = [formatter dateFromString:@"22:20:00"];
        //通知发出的时间
        localNotification.fireDate = date;
    }
    //循环通知的周期
    localNotification.repeatInterval = kCFCalendarUnitDay;
    
    //设置userinfo方便撤销
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"sportNotifi" forKey:@"id"];
    localNotification.userInfo = info;
    //启动任务
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}
//或许许可
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//过期的方法
-(void)getHealthPermissons
{
    [[HealthManager shareInstance]getPermissions:^(BOOL value, NSError *error) {
        if (value) {
            NSLog(@"");
            //本地推送
            [self  getLocalNotification];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有允许菁彩校园获取健康数据，暂时不能使用菁彩运动功能！请在”健康“中允许菁彩校园获取您的健康数据。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alertView show];
            });
        }
    }];

}
-(void)createView
{
    self.view.backgroundColor=Base_Color2;
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-10*2, kScreenHeight-64-51) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainTableView];
    if (@available(iOS 11,*)) {
        if ([self.mainTableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.mainTableView.estimatedRowHeight = 0;
            self.mainTableView.estimatedSectionHeaderHeight = 0;
            self.mainTableView.estimatedSectionFooterHeight = 0;
        }
    }
    
    UIButton *boottomView = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = RGB(255, 213, 132);
        [view setImage:[UIImage imageNamed:@"goldWhite"] forState:UIControlStateNormal];
        [view setTitle:@"今日步数排行榜" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleEdgeInsets = UIEdgeInsetsMake(0, 24, 0, 0);
        view.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [view addTarget:self action:@selector(openList) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    [self.view addSubview:boottomView];
    boottomView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(41);
    
    UIButton *mineSportInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    mineSportInfo.frame = CGRectMake(0, 0, 30, 40);
    [mineSportInfo setImage:[UIImage imageNamed:@"MineSport"] forState:UIControlStateNormal];
    [mineSportInfo addTarget:self action:@selector(openMineSportsInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:mineSportInfo];
    self.navigationItem.rightBarButtonItem = leftItem;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}
-(void)loadData{
    
    //取出日期
    //一次查询两天的  不到十点不能查询今天的数据
    self.page +=2;
    NSString *endDateStr = [self getDateAfterSomeDays:self.page];
    NSString *startDateStr =[self getStatTimeWithSomeDays:1 withCurrentDay:endDateStr];
    if (self.page==0) {
        [ProgressHUD show:@"正在加载..."];
    }
    [self loadData:startDateStr andEndStr:endDateStr];
}
//获取相对于今天的前几天的日期
-(NSString *)getDateAfterSomeDays:(NSInteger)dis{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay*dis ];
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:theDate];
    return dateString;
}
//获取相对于那天的前天
-(NSString *)getStatTimeWithSomeDays:(NSInteger)dis withCurrentDay:(NSString *)currentDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* nowDate = [dateFormatter dateFromString:currentDay];
    NSDate* theDate;
    if(dis!=0)
    {
        theDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:nowDate];//前一天
    }else{
        theDate = nowDate;
    }
   
    NSString *dateString = [dateFormatter stringFromDate:theDate];
    return dateString;
}
#pragma mark 获取步数  点赞
-(void)loadData:(NSString *)startDateStr andEndStr:(NSString *)endDateStr
{
    
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getPersonStepNumWithWonPraise",@"userid":[AppUserIndex GetInstance].role_id,@"time":startDateStr,@"endtime":endDateStr} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataSourceArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            SportModel *model  = [[SportModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_dataSourceArr addObject:model];
        }
        if (_dataSourceArr.count==0) {
            [self.mainTableView.mj_header endRefreshing];
            return ;
        }
 
        
        [self.sportModelArray addObjectsFromArray:_dataSourceArr];
        NSArray *result = [self.sportModelArray  sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            SportModel *model = obj1;
            SportModel *secModel = obj2;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *oneDayStr = model.UMIDATE;
            NSString *anotherDayStr =secModel.UMIDATE;
            NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
            NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
            NSComparisonResult result = [dateA compare:dateB];
            
            return  result;
            
        }];
        self.sportModelArray = [NSMutableArray arrayWithArray:result];
        [self.mainTableView.mj_header endRefreshing];
        [self getLocationName];//获取当前位置
        [self.mainTableView reloadData];
        
        if (self.page==2) {
            NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:0 inSection:self.sportModelArray.count-1];
            [self.mainTableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    }];
}

#pragma mark 打开运动排行榜
//打开排行榜
-(void)openList
{
    SportsMainViewController *vc = [[SportsMainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 打开我的/好友的运动详情
-(void)openMineSportsInfo
{
    SportInfoViewController *vc = [[SportInfoViewController alloc]init];
    vc.userID = [AppUserIndex GetInstance].role_id;
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark TableViewDelagate  DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sportModelArray.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"sporMainCell";
    SportsMainCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SportsMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SportModel  *model = self.sportModelArray[indexPath.section];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Class currentClass = [SportsMainCell class];
//    SportModel  *model = self.sportModelArray[indexPath.section];
//    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
    return 151+46+46;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
/*设置标题尾的高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
/*设置标题脚的名称*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = Base_Color2;
    return headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
#pragma clang diagnostic pop

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
