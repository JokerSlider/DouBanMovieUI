//
//  SignViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "SignViewController.h"
#import "JTCalendar.h"
#import "SDAutoLayout.h"

@interface SignViewController ()<JTCalendarDelegate>
{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
    
    UIView *_flipView;
    UIButton *_signBtn;//签到按钮
    UILabel *_showLabel;
    UILabel *_flowerNumLabel;
}

@property (nonatomic, retain) UIScrollView *mainScrollView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (nonatomic, retain) JTHorizontalCalendarView *calendarContentView;
@property (nonatomic, retain) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) NSCalendar *calendar;


@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"签到赢鲜花";

    [self createViews];
    [self loadData];
}
-(void)loadData
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getCurrentMonthSign",@"username":user.role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"status"]];
        if ([status isEqualToString:@"1"]) {
            _signBtn.selected = YES;
            _signBtn.userInteractionEnabled = NO;
            [AppUserIndex GetInstance].signStatus = YES;
        }else{
            _signBtn.selected = NO;
            _signBtn.userInteractionEnabled = YES;
            [AppUserIndex GetInstance].signStatus = NO;
        }
        _eventsByDate = [NSMutableDictionary new];
        NSMutableArray *dateArr = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"][@"date"]) {
            [dateArr addObject:dic];
        }
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd";
        [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Shanghai"]];
        for(int i = 0; i < dateArr.count; ++i){
            // Generate 30 random dates between now and 60 days later
            NSString *date = [dateArr[i] objectForKey:@"t_date"];
            NSDate *randomDate = [format dateFromString:date];
                // Use the date as key for eventsByDate
                NSString *key = [[self dateFormatter] stringFromDate:randomDate];
                if(!_eventsByDate[key]){
                    _eventsByDate[key] = [NSMutableArray new];
                }
                
                [_eventsByDate[key] addObject:randomDate];
            }
        [_calendarManager reload];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
}

- (void)createViews{
    _mainScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    _mainScrollView.backgroundColor = RGB(247, 247, 247);

    //创建头视图
    UIImageView *headerView = [[UIImageView alloc] init];
    [_mainScrollView addSubview:headerView];
    headerView.sd_layout
    .topSpaceToView(_mainScrollView,0)
    .leftSpaceToView(_mainScrollView,0)
    .rightSpaceToView(_mainScrollView,0)
    .heightIs(186);
    headerView.userInteractionEnabled = YES;
    headerView.image = [UIImage imageNamed:@"sign_bg"];
    
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    grayView.layer.cornerRadius = 5;
    
    _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signBtn setImage:[UIImage imageNamed:@"sign_sign2"] forState:UIControlStateNormal];
    [_signBtn setImage:[UIImage imageNamed:@"sign_sign"] forState:UIControlStateSelected];
    [_signBtn addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([AppUserIndex GetInstance].signStatus) {
        _signBtn.selected = YES;
        _signBtn.userInteractionEnabled = NO;
    }
    
    _flipView = [[UIView alloc] init];
    [_mainScrollView addSubview:_flipView];
    [_flipView addSubview:_signBtn];
    
    _showLabel = [[UILabel alloc] init];
    _showLabel.font = [UIFont systemFontOfSize:14];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.text = [NSString stringWithFormat:@"已连续签到%@天",[AppUserIndex GetInstance].continueSignDays];
    
    [headerView sd_addSubviews:@[grayView, _flipView, _showLabel]];
    
    grayView.sd_layout
    .leftSpaceToView(headerView,12)
    .rightSpaceToView(headerView,12)
    .topSpaceToView(headerView,14)
    .heightIs(50);
    
    _flipView.sd_layout
    .topSpaceToView(headerView,76)
    .centerXEqualToView(headerView)
    .widthIs(72)
    .heightIs(72);
    
    _showLabel.sd_layout
    .topSpaceToView(_flipView,5)
    .rightSpaceToView(headerView,10)
    .leftSpaceToView(headerView,10)
    .heightIs(25);
    
    _signBtn.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    UILabel *flowerLabel = [UILabel new];
    flowerLabel.text = @"鲜花数量";
    flowerLabel.font = [UIFont systemFontOfSize:15];
    flowerLabel.textColor = Base_Orange;

    _flowerNumLabel = [UILabel new];
    _flowerNumLabel.font = [UIFont systemFontOfSize:18];
    _flowerNumLabel.textColor = Base_Orange;
    _flowerNumLabel.text = [AppUserIndex GetInstance].flowerNum;
    _flowerNumLabel.textAlignment = NSTextAlignmentRight;
    
    [grayView sd_addSubviews:@[flowerLabel,_flowerNumLabel]];
    flowerLabel.sd_layout
    .leftSpaceToView(grayView,10)
    .heightIs(50)
    .topSpaceToView(grayView,0)
    .widthIs(100);
    
    _flowerNumLabel.sd_layout
    .rightSpaceToView(grayView,10)
    .heightIs(50)
    .topSpaceToView(grayView,0)
    .widthIs(200);
    
    //创建日历视图
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _calendarContentView = [[JTHorizontalCalendarView alloc] init];
    _calendarContentView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_calendarContentView];
    
    _calendarContentView.sd_layout
    .topSpaceToView(headerView,15)
    .leftSpaceToView(_mainScrollView,0)
    .rightSpaceToView(_mainScrollView,0)
    .heightIs(294);
    
    [_mainScrollView setupAutoContentSizeWithBottomView:_calendarContentView bottomMargin:20];

    
//    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    _calendarContentView.userInteractionEnabled = NO;
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];

}

- (void)signAction:(UIButton *)sender{
    AppUserIndex *user = [AppUserIndex GetInstance];
//    [sender setImage:[UIImage imageNamed:@"sign_sign"] forState:UIControlStateHighlighted];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"addSign",@"username":user.role_id,@"module":@"1"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"签到成功"];
        sender.userInteractionEnabled = NO;
        sender.selected = YES;
        
        //签到之后，数据更新
        NSDictionary *flowerDic = responseObject[@"flower"];
        user.flowerNum = [NSString stringWithFormat:@"%@",flowerDic[@"SBIFLOWERSNUMBER"]];
        user.continueSignDays = [NSString stringWithFormat:@"%@",flowerDic[@"SBICONSECUTIVEDAYS"]];
        _showLabel.text = [NSString stringWithFormat:@"已连续签到%@天",[AppUserIndex GetInstance].continueSignDays];
        _flowerNumLabel.text = [AppUserIndex GetInstance].flowerNum;
        user.signStatus = YES;
        
        //旋转函数
        [UIView transitionWithView:_flipView duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            sender.userInteractionEnabled = NO;
            sender.selected = YES;
            [self loadData];
        } completion:^(BOOL finished) {
            [AppUserIndex GetInstance].signStatus = YES;
        }];
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error[@"msg"]]];
    }];
   
}


#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.dotView.hidden = NO;

    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = YES;
//        dayView.circleView.backgroundColor = [UIColor blueColor];
//        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = Base_Orange;
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = YES;
//        dayView.circleView.backgroundColor = [UIColor redColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.hidden = YES;

//        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor greenColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
//    forin //当前日期是否有事件
    if([self haveEventForDay:dayView.date]){
        [dayView.dotView setImage:[UIImage imageNamed:@"sign_smile"] forState:UIControlStateNormal];
    }
    else{
        [dayView.dotView setImage:[UIImage imageNamed:@"sign_cry"] forState:UIControlStateNormal];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
//- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
//{
//    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
//}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
    NSLog(@"%@",_eventsByDate);
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
