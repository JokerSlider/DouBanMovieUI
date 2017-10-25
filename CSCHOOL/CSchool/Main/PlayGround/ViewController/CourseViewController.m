//
//  CourseViewController.m
//  Course
//
//  Created by MacOS on 14-12-16.
//  Copyright (c) 2016年 Joker. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "CourseViewController.h"
#import "TermViewController.h"
#import "TwoTitleButton.h"
#import "DayTableViewCell.h"
#import "DateUtils.h"
#import "WeekCourse.h"
#import "CourseButton.h"
#import "WeekChoseView.h"
#import "UIView+SDAutoLayout.h"
#import "ChooseDayorWeek.h"
#import "NetworkCore.h"
#import "AboutUsViewController.h"
//#define stuNo @"201510102053"//20140312091   20140121083  20140512031 201515104042
@interface CourseViewController ()<WeekChoseViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *widArr;
    NSMutableDictionary *kssjDic;
    NSMutableDictionary *jssjDic;
}
@end
@implementation CourseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [ProgressHUD dismiss];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_roomNum) {
        self.title = [NSString stringWithFormat:@"%@的课表",_roomNum];
    }else{
        self.title = [NSString stringWithFormat:@"%@的课表",[AppUserIndex GetInstance].role_username];
    }
    //加载一些基本数据
    [self loadBaseData];
    //初始化导航栏
    [self _initNavigationBar];
    //初始化日的视图
    [self _initDayView];
    //初始化周的视图
    [self _initWeekView];
    //初始化隐藏的周选择视图
    [self _initWeekChoseView];
    //初始化选择天数的视图
    [self chooseDayView];
    //弹窗
    [self showAlert];
    //加载校历
    [self loadSchoolCalender];
    if (self.roomNum) {
        self.title = [NSString stringWithFormat:@"%@教室课表",self.roomNum];
        [self loadEmptyClassRoomCourse:self.roomNum];
    }else{
        self.title = [NSString stringWithFormat:@"我的课表"];
        [self loadCourseDataInfo];
    }

}
#pragma mark 弹窗
- (void)showAlert{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"course"] isEqualToString:@"1"]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"本数据仅供参考，请以学校实际公布为准。" WithCancelButtonTitle:@"不再提示" withOtherButton:nil];
        alert.isBackClick = YES;
        [alert show];
    }
}
#pragma mark-加载数据
-(void)loadData
{
    if (self.roomNum) {
        self.title = [NSString stringWithFormat:@"%@教室课表",self.roomNum];
        [self loadEmptyClassRoomCourse:self.roomNum];
    }else{
        self.title = [NSString stringWithFormat:@"我的课表"];
        [self loadCourseDataInfo];
    }
}
/**
 *  加载一些不需要从服务器请求的数据
 */
- (void)loadBaseData
{
    //先加载本周的月份以及日期
    horTitles = [DateUtils getDatesOfCurrence];
    //赋值计算今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    todayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
}
/**
 *  获取星期几的课程
 *
 *  @param weekDay 星期几，
 *  @param courses 服务器返回的课程数组
 *
 *  @return 返回课程 （按照上课顺序 从第一节......到第第十二节）
 */
- (NSMutableArray *)getDayCoursesByWeekDay:(NSString *)weekDay srcArray:(NSArray *)courses
{
    //返回时使用的数组
    NSMutableArray *newCourses = [NSMutableArray array];
    int rowNum = 1;//默认从第一节开始计算
    if (courses == nil) { //如果没有数据时
        for (int j = rowNum; j< 13; j++) {
            WeekCourse *weekCourse = [[WeekCourse alloc] init];
            weekCourse.capter = [NSString stringWithFormat:@"%d",j];
            [newCourses addObject:weekCourse];
        }
        return newCourses;
    }
    //星期几的课程
    long Day = [weekDay longLongValue];
    NSString *string = [NSString stringWithFormat:@"SKXQ == %ld",Day];
    NSPredicate *pre = [NSPredicate predicateWithFormat:string];
    //应该只有一条记录
    NSArray *coursesOfDay = [courses filteredArrayUsingPredicate:pre]; //筛选出某天的课程信息
    //将课程表数据按照上课节次排列后使用
    NSArray *nerCourse = [coursesOfDay sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        WeekCourse *course = obj1;
        WeekCourse *newCourse = obj2;
        if ([course.KSJC intValue]>[newCourse.KSJC intValue]) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    //终于拿到课程了
    for (int i = 0; i < nerCourse.count; i++) {
        //每一条记录为一个cell的数据，这里给Model添加capter属性,设置哪几节上课
        WeekCourse *course = [nerCourse objectAtIndex:i];
        lessonCell = course.KSJC;
        lessonsCellNum = course.lessonsNum;
        endCapter = lessonCell.intValue+lessonsCellNum.intValue -1;
        //判断是否之前有空着的，如果有插入空节数
        if (rowNum != lessonCell.intValue) {
            for (int j = rowNum; j<lessonCell.intValue; j++) {
                WeekCourse *weekCourse = [[WeekCourse alloc] init];
                weekCourse.capter = [NSString stringWithFormat:@"%d",j];
                [newCourses addObject:weekCourse];//把一些只包含节数信息的对象 插入数组
            }
        }
        //组装新的课程信息，其实只修改了从第几节到第几节，还有是否有课的属性
        course.haveLesson = YES;
        //判断是否为只上一节的情况
        if (endCapter == lessonCell.intValue) {
            course.capter = lessonCell;
        }else {
            NSString *capter;
            //3节连堂
            if (endCapter-[lessonCell intValue]==2) {
                capter = [NSString stringWithFormat:@"%@\n\n%d\n\n%d",lessonCell,[lessonCell intValue]+1,endCapter];
            }
            //4节连堂
          else if (endCapter-[lessonCell intValue]==3) {
              capter = [NSString stringWithFormat:@"%@\n\n%d\n\n%d\n\n%d",lessonCell,[lessonCell intValue]+1,[lessonCell intValue]+2,endCapter];
            }
            //5节  几乎不存在
          else if(endCapter-[lessonCell intValue]==5){
          
              capter = [NSString stringWithFormat:@"%@\n\n%d\n\n%d\n\n%d\n\n%d",lessonCell,[lessonCell intValue]+1,[lessonCell intValue]+2,[lessonCell intValue]+3,endCapter];
          }
            //两节
            else
            {
                capter = [NSString stringWithFormat:@"%@\n\n\n%d",lessonCell,endCapter];
            }
            course.capter = capter;
        }
        //把重新组装的dict 加入数组
        [newCourses addObject:course];
        rowNum = endCapter +1;
    }
    //如果还没计算到第12节，后面的也要插入只包含节数的dict
    if (rowNum < 12) {
        for (int j = rowNum; j< 13; j++) {
            WeekCourse *weekCourse = [[WeekCourse alloc] init];
            weekCourse.capter = [NSString stringWithFormat:@"%d",j];
            [newCourses addObject:weekCourse];
        }
    }
    return newCourses;
}

/**
 *  计算出周一至周日的课程，封装成数组
 *
 *  @param array 周几数组
 *
 *  @return 返回时哪一天的课程
 */
- (NSMutableArray *)getCoursesWithServerData:(NSArray *)array
{
    NSMutableArray *dayAllCourses = [[NSMutableArray alloc] initWithCapacity:7];
    NSArray *weekDays = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",];
    //计算出周一至周日的课程，封装成数组
    for (int i = 0; i < weekDays.count; i++) {
        NSString *weekday = [weekDays objectAtIndex:i];
        NSMutableArray *newCourses = [self getDayCoursesByWeekDay:weekday srcArray:array];
        [dayAllCourses addObject:newCourses];
    }
    return dayAllCourses;
}
/**
 *  加载校历
 */
-(void)loadSchoolCalender
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    //获取校历信息
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getSchoolCalendarByCode",@"schoolCode":user.schoolCode} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [user setValue:responseObject[@"data"]forKey:@"schoolCalenderArr"];
        [user  saveToFile];
        [self handleCalender:responseObject[@"data"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [ProgressHUD showError:[error objectForKey:@"msg"]];
    }];
}
/**
 *  根据教室号获取课程
 *
 *  @param classNo 教室号
 */
-(void)loadEmptyClassRoomCourse:(NSString *)classRoomNo
{
    [ProgressHUD show:@"正在加载..."];
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getTimetablesByBuildno",@"classroomNo":classRoomNo} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            NSArray *courseArr = [responseObject objectForKey:@"data"];
            [self handleWeek:courseArr];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD dismiss];
            [self showErrorViewLoadAgain:error[@"msg"]];
        }];
}
/**
 *  根据周数加载数据
 *
 *  @param week 周数
 */
-(void)loadCourseDataInfo
{
    //本地存储数据
    [ProgressHUD show:@"正在加载..."];
    AppUserIndex *user = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getCurriculumScheduleByTerm",@"stuNo":stuNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSArray *courseArr = [responseObject objectForKey:@"data"];
        //处理重复数据
//        NSSet *set = [NSSet setWithArray:courseArr];
//        [self handleWeek:[set allObjects]];
        [self handleWeek:courseArr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
    [self showErrorViewLoadAgain:[error objectForKey:@"msg"]];
    }];
    
}
/**
 *  解析课程
 *
 *  @param array 课程数组
 */
- (void)handleWeek:(NSArray *)array
{
    NSMutableArray *allCourses =[NSMutableArray array];
    if (array != nil && array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dayDict = array[i];
            NSString *weekDay = [NSString stringWithFormat:@"%@",[dayDict objectForKey:@"SKXQ"]];
            NSString *weekNum;
            if ([@"1" isEqualToString:weekDay]) {
                weekNum = @"1";
            }else if ([@"2" isEqualToString:weekDay]){
                weekNum = @"2";
            }else if ([@"3" isEqualToString:weekDay]){
                weekNum = @"3";
            }else if ([@"4" isEqualToString:weekDay]){
                weekNum = @"4";
            }else if ([@"5" isEqualToString:weekDay]){
                weekNum = @"5";
            }else if ([@"6" isEqualToString:weekDay]){
                weekNum = @"6";
            }else if([@"sunday" isEqualToString:weekDay]){
                weekNum = @"7";
            }else {
                weekNum = weekDay;
            }
            NSMutableDictionary *course = [NSMutableDictionary dictionaryWithDictionary:array[i]];
            [course setObject:weekNum forKey:@"weekDay"];
            WeekCourse *weekCourse = [[WeekCourse alloc] initWithPropertiesDictionary:course];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *year = [userDefaults objectForKey:CURRENTYEAR];
            NSString *term = [userDefaults objectForKey:CURRENTTERM];
            NSString *stuId = [userDefaults objectForKey:USERNAME];
            NSString *yearRange = [NSString stringWithFormat:@"%@%@",year,term];
            weekCourse.XH = stuId;
            weekCourse.XNXQDM = yearRange;
            [allCourses addObject:weekCourse];
        }
    }
    //对数据解析
    [self handleData:allCourses];
}
/**
 *  解析校历并存储
 *
 *  @param array 校历数组
 */
- (void)handleCalender:(NSArray *)array
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    widArr = [NSMutableArray array];
    kssjDic = [NSMutableDictionary dictionary];
    jssjDic = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in array) {
        [widArr addObject:dic[@"WID"]];
        [kssjDic setObject:dic[@"KSSJ"]forKey:dic[@"WID"]];
        [jssjDic setObject:dic[@"JSSJ"] forKey:dic[@"WID"]];
    }
    [user setValue:widArr forKey:@"widArr"];
    [user setValue:kssjDic forKey:@"kssjDic"];
    [user setValue:jssjDic forKey:@"jssjDic"];
    [user saveToFile];
}
/**
 *  数据解析后，展示在UI上
 *
 *  @param courses 课程数组
 */
- (void)handleData:(NSArray *)courses
{
    if (dataArray || dataArray.count > 0) {
        dataArray = nil;
    }
    for (UIView *view in weekScrollView.subviews) {
        if ([view isKindOfClass:[CourseButton class]]) {
            [view removeFromSuperview];
        }
    }
    if (courses.count > 0) {
        //处理周课表
        for (int i = 0; i<courses.count; i++) {
            WeekCourse *course = courses[i];
            //行数
            int rowNum = course.KSJC.intValue - 1;
            //列数
            int colNum = course.SKXQ.intValue;
            int lessonsNum = course.lessonsNum.intValue;
            
            courseButton = [[CourseButton alloc] initWithFrame:CGRectMake((colNum-0.5)*kWidthGrid, 50*rowNum+1, kWidthGrid-2, 50*lessonsNum-2)];
            courseButton.weekCourse = course;
            //重课的现象 取到下一节次的课程名 一起显示
            WeekCourse *nextCourse;
            if (i!=0) {
                nextCourse=[courses objectAtIndex:i-1];
            }else{
                //nextCourse = [courses objectAtIndex:i];
                nextCourse = [courses objectAtIndex:i];
            }
            int day =[nextCourse.SKXQ intValue];
            int nextDay = [course.SKXQ intValue];
            //重课的情况
            if ([nextCourse.KSJC intValue]==[course.KSJC intValue]&&day==nextDay) {
                    courseButton.nextCourseName =[NSString stringWithFormat:@"%@[%@]",nextCourse.KCM,nextCourse.KXH];
                    courseButton.nextCourseClaName = nextCourse.JSMC;
            }
            //给课程按钮---颜色
            courseButton.backgroundColor = [self handleRandomColorwithDate:courseButton.weekCourse.SKXQ];
            //课程点击事件
            [courseButton addTarget:self action:@selector(courseClick:) forControlEvents:UIControlEventTouchUpInside];
            [weekScrollView addSubview:courseButton];
        }
        //日课表数据处理
        dataArray = [self getCoursesWithServerData:courses];
    } else {
        dataArray = [self getCoursesWithServerData:nil];
    }
    for (int i = 0; i< 7; i++) {
        UITableView *tableView = (UITableView *)[scrollView viewWithTag:10000+i];
        [tableView reloadData];
    }
    [ProgressHUD dismiss];

}
#pragma mark - 初始化控件
/**
 *  初始化导航栏
 */
- (void)_initNavigationBar
{
    backBtn = [[ChooseDayorWeek alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    backBtn.title = @"周";
    backBtn.subtitle = @"日";
    
    backBtn.titleFont =[UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(16.0)];;
    backBtn.subtitleFont = [UIFont systemFontOfSize:12];
    backBtn.textColor = [UIColor whiteColor];
    
    [backBtn addTarget:self action:@selector(dayOrWeekAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    //中间按钮
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    
    UIButton *weeksButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    weeksButton.tag = 110;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currentWeek = [userDefaults objectForKey:@"currentWeek"];
    clickTag = currentWeek.intValue + 250-1;
    currentWeekTag = clickTag;
    [weeksButton setTitle:[NSString stringWithFormat:@"第%@周",currentWeek] forState:UIControlStateNormal];
    [weeksButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
    [weeksButton setImage:[UIImage imageNamed:@"course_arrow.png"] forState:UIControlStateNormal];
    [weeksButton setImageEdgeInsets:currentWeek.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
    
    [weeksButton addTarget:self action:@selector(weekChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:weeksButton];
    
    backLabel = [[UILabel alloc]initWithFrame:CGRectMake(-5, 25, 80, 10)];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.textColor = [UIColor yellowColor];
    backLabel.textAlignment = NSTextAlignmentCenter;
    backLabel.font = [UIFont systemFontOfSize:10];
    backLabel.text = @"返回本周";
    backLabel.hidden = YES;
    [weeksButton addSubview:backLabel];
    //背景视图
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44)];
    bgImageView.backgroundColor = self.view.backgroundColor;
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
}
/**
 *  切换视图
 */
-(void)hideLabel
{
    //本来显示，点击之后要隐藏
    if (weekChoseViewShow) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, -60, kScreenWidth, 60);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = NO;
        if(clickTag!=currentWeekTag){
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
            view.isChosen = NO;
            [view reset];
            clickTag = currentWeekTag;
            NSString *week = [[NSString alloc] initWithFormat:@"%d",clickTag-250+1];
            UIButton *weekButton = (UIButton *)[self.navigationItem.titleView viewWithTag:110];
            [weekButton setTitle:[NSString stringWithFormat:@"第%@周",week] forState:UIControlStateNormal];
            [weekButton setImageEdgeInsets:week.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
            [self bounceTargetView:weekButton];
            backLabel.hidden = YES;
            //数据也重新加载
            [self loadCourseDataInfo];
        }
    }else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = YES;
        if(clickTag ==currentWeekTag){
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:currentWeekTag];
            view.isChosen = YES;
            [view reset];
        }
    }
}
/**
 *  初始化隐藏的周选择视图
 */
- (void)_initWeekChoseView
{
    weekChoseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-60, kScreenWidth, 60)];
    weekChoseScrollView.backgroundColor = Base_Orange;
    weekChoseScrollView.contentSize = CGSizeMake(50*25, 60);
    weekChoseScrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i< 25; i++) {
        WeekChoseView *weekChoseView = [[WeekChoseView alloc] initWithFrame:CGRectMake(50*i, 0, 50, 60)];
        weekChoseView.number = [NSString stringWithFormat:@"%d",i+1];
//        weekChoseView.delegate = self;
        weekChoseView.tag = 250+i;
        if (clickTag == (250 +i)) {
            weekChoseView.isCurrentWeek = YES;
            weekChoseView.isChosen = YES;
            [weekChoseView reset];
            weekChoseScrollView.contentOffset = CGPointMake(50*i, 0);
        }
        [weekChoseScrollView addSubview:weekChoseView];
    }
    [self.view addSubview:weekChoseScrollView];
}

/**
 *  初始化日视图
 */
- (void)_initDayView
{
    dayView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, kScreenHeight)];
    UIView *dayHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    UIButton *monthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidthGrid*0.5, 30)];
    [monthButton setTitle:horTitles[0] forState:UIControlStateNormal];
    [monthButton setTitleColor:Color_Black forState:UIControlStateNormal];
    monthButton.titleLabel.font = Title_Font;
    monthButton.layer.borderColor = Color_Black.CGColor;
    monthButton.layer.borderWidth = 0;
    monthButton.layer.masksToBounds = YES;
    [dayHeaderView addSubview:monthButton];
    
    NSArray *weekDays = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i< 7; i++) {
        TwoTitleButton *button = [[TwoTitleButton alloc] initWithFrame:CGRectMake((i+0.5)*kWidthGrid, 0, kWidthGrid, 30)];
        NSString *title = [NSString stringWithFormat:@"%@",weekDays[i]];
        button.tag = 9000+i;
        button.title = horTitles[i+1];
        button.subtitle = title;
        button.textColor = Color_Black;
        [dayHeaderView addSubview:button];
    }
    //日视图的头视图--显示日期和周几
//    [dayView addSubview:dayHeaderView];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, dayView.frame.size.height)];
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(kScreenWidth*7, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    for (int i = 0; i< 7; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, scrollView.frame.size.height-99) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = [UIView new];
        tableView.tag = i + 10000;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSelectionStyleGray;
        tableView.separatorColor = Color_Gray;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [scrollView addSubview:tableView];
    }
    NSString *month = [NSString stringWithFormat:@"%ld月",(long)[todayComp month]];
    NSString *day = [NSString stringWithFormat:@"%ld",(long)[todayComp day]];
    int num = -1;
    for (int i = 0; i < 7; i++) {
        TwoTitleButton *button = (TwoTitleButton *)[dayView viewWithTag:9000+i];
        if ([month isEqualToString:horTitles[0]] && [day isEqualToString:horTitles[i+1]]) {
            //选中的颜色
            button.backgroundColor = Base_Orange;
            scrollView.contentOffset = CGPointMake(kScreenWidth*i, 0);
            num = i;
        }
    }
    [dayView addSubview:scrollView];
     dayView.hidden = YES;
    [self.view addSubview:dayView];
}
/**
 *  选择日期
 */
-(void)chooseDayView
{
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,35)];
    [self.view addSubview:backView];
    backView.backgroundColor = Base_Color2;
    
    dayLabel = [UILabel new];
    rightBtn = [UIButton new];
    leftBtn = [UIButton new];
    dayLabel.frame = CGRectMake((backView.bounds.size.width-100)/2, 0, 100, 30);
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(dayLabel.frame.origin.x-40, 0, 30, 30);
    rightBtn.frame = CGRectMake(dayLabel.frame.size.width+dayLabel.frame.origin.x+10, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"chooseRight.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"chooseLeft.png"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = Title_Font;
    leftBtn.titleLabel.font = Title_Font;

    int page = scrollView.contentOffset.x/kScreenWidth;
    [self day:page];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    //添加点击事件
    [rightBtn addTarget:self action:@selector(rightChoose) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(leftChoose) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:leftBtn];
    [backView addSubview:dayLabel];
    [backView addSubview:rightBtn];
     backView.hidden = YES;
}
/**
 *  初始化周视图
 */
- (void)_initWeekView
{
    weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50)];
    //初始化周视图的头
    UIView *weekHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    weekHeaderView.backgroundColor = Base_Color2;
    //月份
    UIButton *monthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidthGrid*0.5, 30)];
    //打开这一行  显示月份
//    [monthButton setTitle:horTitles[0] forState:UIControlStateNormal];
    [monthButton setTitleColor:Color_Black forState:UIControlStateNormal];
    monthButton.titleLabel.font = Title_Font;
    monthButton.layer.borderColor = Color_Black.CGColor;
    monthButton.layer.borderWidth = 0;
    monthButton.layer.masksToBounds = YES;
    [weekHeaderView addSubview:monthButton];
    
    NSArray *weekDays = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i< 7; i++) {
        TwoTitleButton *button = [[TwoTitleButton alloc] initWithFrame:CGRectMake((i+0.5)*kWidthGrid, 0, kWidthGrid, 30)];
        NSString *title = [NSString stringWithFormat:@"周%@",weekDays[i]];
        button.tag = 9000+i;
        //显示日期  可以去掉
//        button.title = horTitles[i+1];
        //显示周几
        button.subtitle = title;
        button.textColor = Color_Black;
        NSString *month = [NSString stringWithFormat:@"%ld月",(long)[todayComp month]];
        NSString *day = [NSString stringWithFormat:@"%ld",(long)[todayComp day]];
        if ([month isEqualToString:horTitles[0]] && [day isEqualToString:horTitles[i+1]]) {
            button.textColor = Base_Orange;
        }
        [weekHeaderView addSubview:button];
    }
    [weekView addSubview:weekHeaderView];
    //主体部分
    weekScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, weekView.frame.size.height -30)];
    weekScrollView.bounces = YES;
    weekScrollView.contentSize = CGSizeMake(kScreenWidth, 50*12);
    for (int i = 0; i<12; i++) {
        for (int j = 0; j< 8; j++) {
            if (j == 0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j*kWidthGrid, i*50,kWidthGrid*0.5, 50)];
                label.backgroundColor = [UIColor clearColor];
                label.layer.borderColor = [UIColor whiteColor].CGColor;
                label.layer.borderWidth = 0.3f;
                label.layer.masksToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = Color_Black;
                label.text =[NSString stringWithFormat:@"%d",i+1];
                label.font = Title_Font;
                [weekScrollView addSubview:label];
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((j-0.5)*kWidthGrid-1, i*50, kWidthGrid, 50+1)];
                imageView.image = [UIImage imageNamed:@"course_excel.png"];
            }
        }
    }
    [weekView addSubview:weekScrollView];
    [self.view addSubview:weekView];
}
#pragma mark - 私有方法
/**
 *  获取当天的周一至周五
 *
 *  @return 返回今天对应的数字（周一-1，周二-2，周三-3.。。。周日-7）
 */
-(NSString *)getDayWeek{
    int dayDelay = 0;
    NSString *weekDay;
    NSDate *dateNow;
    dateNow=[NSDate dateWithTimeIntervalSinceNow:dayDelay*24*60*60];//dayDelay代表向后推几天，如果是0则代表是今天，如果是1就代表向后推24小时
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:dateNow];
    long weekNumber = [comps weekday]; //获取星期对应的长整形字符串
    switch (weekNumber) {
        case 1:
            weekDay=@"7";
            break;
        case 2:
            weekDay=@"1";
            break;
        case 3:
            weekDay=@"2";
            break;
        case 4:
            weekDay=@"3";
            break;
        case 5:
            weekDay=@"4";
            break;
        case 6:
            weekDay=@"5";
            break;
        case 7:
            weekDay=@"6";
            break;
            
        default:
            break;
    }
    return weekDay;
}
/**
 *  处理颜色字符串
 *
 *  @param courseWeekDays 课程的上课日期
 *
 *  @return 返回颜色
 */
- (UIColor *)handleRandomColorwithDate:(NSString * )courseWeekDays
{
    NSString *todayWeek = [self getDayWeek];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *daysNumber = @([courseWeekDays integerValue]);
    courseWeekDays= [numberFormatter stringFromNumber:daysNumber];
    if ([todayWeek isEqualToString:courseWeekDays]) {
        courseButton.classNameL.textColor = [UIColor whiteColor];
        courseButton.classRomL.textColor = [UIColor whiteColor];
        return Base_Orange;
    }
    return Base_Color2;
}
#pragma 点击事件
//后一天
-(void)rightChoose
{
    [self switchDay:YES];
}
//前一天
-(void)leftChoose
{
    [self switchDay:NO];
}
-(void)switchDay:(BOOL)isNext
{
    int page = scrollView.contentOffset.x/kScreenWidth;
    if (isNext) {
        if (page==5) {
            rightBtn.hidden =YES;
            leftBtn.hidden=NO;
        }else{
            rightBtn.hidden = NO;
            leftBtn.hidden=NO;
        }

    }else{
    if (page==1) {
        rightBtn.hidden = NO;
        leftBtn.hidden=YES;
    }else{
        rightBtn.hidden = NO;
        leftBtn.hidden=NO;
    }
    }
    if (isNext) {
        page++;
        if (page==7) {
            return;
        }
    }else{
    page--;
    if (page==-1) {
        return;
    }
    }
    [self day:page];
    //当天课程显示主题色
    [self locatedDaylabelColor:page];
    for (int i = 0; i < 7; i++) {
        TwoTitleButton *button = (TwoTitleButton *)[dayView viewWithTag:9000+i];
        if (page == i) {
            button.backgroundColor = Base_Orange;
            if (sliderLabel) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                CGRect rect = sliderLabel.frame;
                rect.origin.x = (i+0.5)*kWidthGrid;
                sliderLabel.frame = rect;
                [UIView commitAnimations];
            }
        }else {
            button.backgroundColor = [UIColor clearColor];
        }
    }
    CGRect rect = scrollView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = page*scrollView.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [scrollView scrollRectToVisible:rect animated:YES];
}
/**
 *  处理dayLabel的显示天数以及箭头是否显示的问题
 *
 *  @param page scrollView的页码
 */
-(void)day:(int )page
{
    switch (page) {
        case 0:
            dayLabel.text = @"周一";
            leftBtn.hidden = YES;
            rightBtn.hidden = NO;
            break;
        case 1:
            dayLabel.text = @"周二";
            leftBtn.hidden = NO;
            rightBtn.hidden = NO;
            break;
        case 2:
            dayLabel.text = @"周三";
            leftBtn.hidden = NO;
            rightBtn.hidden = NO;
            break;
        case 3:
            dayLabel.text = @"周四";
            leftBtn.hidden = NO;
            rightBtn.hidden = NO;
            break;
        case 4:
            dayLabel.text = @"周五";
            leftBtn.hidden = NO;
            rightBtn.hidden = NO;
            break;
        case 5:
            dayLabel.text = @"周六";
            leftBtn.hidden = NO;
            rightBtn.hidden = NO;
            break;
        case 6:
            dayLabel.text = @"周日";
            rightBtn.hidden = YES;
            leftBtn.hidden = NO;
            break;
        default:
            break;
    }
}
/**
 *  点击课表
 *
 *  @param sender 点击的第几个课程格子
 */
- (void)courseClick:(CourseButton *)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
    [UIView setAnimationTransition:dayView.hidden ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    if (dayView.hidden) {
        backBtn.title = @"日";
        backBtn.subtitle = @"周";
        dayView.hidden = NO;
        backView.hidden=NO;
        weekView.hidden = YES;
    }else {
        backBtn.title = @"周";
        backBtn.subtitle = @"日";
        dayView.hidden = YES;
        weekView.hidden = NO;
        backView.hidden = YES;
    }
    int num = [sender.day intValue];
    
    if (!dayView.hidden) {
        [self locatedDaylabelColor:num-1];
        [self locatedTodayCourse:num-1];
    }
}
//定位天数
-(NSString *)weekDay:(int)page
{
    NSString *weekDay;

    switch (page) {
        case 0:
            weekDay=@"周日";
            break;
        case 1:
            weekDay=@"周一";
            break;
        case 2:
            weekDay=@"周二";
            break;
        case 3:
            weekDay=@"周三";
            break;
        case 4:
            weekDay=@"周四";
            break;
        case 5:
            weekDay=@"周五";
            break;
        case 6:
            weekDay=@"周六";
            break;
            
        default:
            break;
    }
    return weekDay;

}
/**
 *  根据是否是当前的天数   若是显示主题色  不是就显示绘灰色
 *
 *  @param page 页码
 */
-(void)locatedDaylabelColor:(int)page
{
    NSString *month = [NSString stringWithFormat:@"%ld月",(long)[todayComp month]];
    NSString *day = [NSString stringWithFormat:@"%ld",(long)[todayComp day]];
    int todayNum = [[self getDayWeek]intValue];
    if ([month isEqualToString:horTitles[0]] && [day isEqualToString:horTitles[page+1]]&&page+1==todayNum) {
        dayLabel.textColor = Base_Orange;
    }else
    {
        dayLabel.textColor = Color_Black;
    }
}
/**
 *  根据当前点击的天数定位到该天的具体课程 可以侧滑 选择不同的天数
 *
 *  @param page 页码
 */
-(void)locatedTodayCourse:(int)page
{
    [self day:page];
    for (int i = 0; i < 7; i++) {
        TwoTitleButton *button = (TwoTitleButton *)[dayView viewWithTag:9000+i];
        if (page==i) {
            button.backgroundColor = Base_Orange;
            if (sliderLabel) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                CGRect rect = sliderLabel.frame;
                rect.origin.x = (i+0.5)*kWidthGrid;
                sliderLabel.frame = rect;
                [UIView commitAnimations];
            }
        }else {
            button.backgroundColor = [UIColor clearColor];
        }
        
    }
    CGRect rect = scrollView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x =  page *scrollView.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [scrollView scrollRectToVisible:rect animated:YES];
}
/**
 *  日---周切换方法--翻转过渡动画效果
 */
-(void)dayOrWeekAction
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
    [UIView setAnimationTransition:dayView.hidden ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    if (dayView.hidden) {
        backBtn.title = @"日";
        backBtn.subtitle = @"周";
        NSString *month = [NSString stringWithFormat:@"%ld月",(long)[todayComp month]];
        NSString *day = [NSString stringWithFormat:@"%ld",(long)[todayComp day]];
        
        int todayNum = [[self getDayWeek]intValue];
        //默认显示当天的课程
        for (int i = 0; i<7; i++) {
            if ([month isEqualToString:horTitles[0]]&&[day isEqualToString:horTitles[i+1]]&&[[self weekDay:todayNum]isEqualToString:dayLabel.text]) {
                dayLabel.textColor = Base_Orange;
            }
        }
        dayView.hidden = NO;
        backView.hidden=NO;
        weekView.hidden = YES;
    }else {
        backBtn.title = @"周";
        backBtn.subtitle = @"日";
        dayView.hidden = YES;
        weekView.hidden = NO;
        backView.hidden = YES;
    }
}
/**
 *  切换日视图和周视图
 *
 *  @param sender
 */
- (void)weekChooseAction:(id)sender
{
    //本来显示，点击之后要隐藏
    if (weekChoseViewShow) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, -60, kScreenWidth, 60);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = NO;
        if(clickTag!=currentWeekTag){
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
            view.isChosen = NO;
            [view reset];
            clickTag = currentWeekTag;
            NSString *week = [[NSString alloc] initWithFormat:@"%d",clickTag-250+1];
            UIButton *weekButton = (UIButton *)[self.navigationItem.titleView viewWithTag:110];
            [weekButton setTitle:[NSString stringWithFormat:@"第%@周",week] forState:UIControlStateNormal];
            [weekButton setImageEdgeInsets:week.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
            [self bounceTargetView:weekButton];
            backLabel.hidden = YES;
            //数据也重新加载
            [self loadCourseDataInfo];
        }
    }else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = YES;
        if(clickTag ==currentWeekTag){
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:currentWeekTag];
            view.isChosen = YES;
            [view reset];
         }
    }
}
/**
 *  切换视图的动画
 *
 *  @param targetView 要加动画的视图
 */
- (void)bounceTargetView:(UIView *)targetView
{
    [UIView animateWithDuration:0.1 animations:^{
        targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            targetView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                targetView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}
/**
 *  修改子类的frame
 *
 *  @param _weekViewShow 是否显示周视图
 */
- (void)changeSubViewsFrameByWeek:(BOOL)_weekViewShow
{
    if (_weekViewShow) {
        //设置日课表视图以及其子视图的frame
        dayView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44);
        CGRect frame = scrollView.frame;
        frame.size.height = dayView.frame.size.height-30;
        scrollView.frame = frame;
        CGSize size = scrollView.contentSize;
        size.height = frame.size.height;
        scrollView.contentSize = size;
        for (int i = 0; i < 7; i++) {
            UITableView *tableView = (UITableView *)[scrollView viewWithTag:10000 + i];
            CGRect tableViewFrame = tableView.frame;
            tableViewFrame.size.height = frame.size.height;
            tableView.frame = tableViewFrame;
        }
        //设置周课表视图以及其子视图的frame
        weekView.frame = dayView.frame;
        weekScrollView.frame = frame;
    } else {
        dayView.frame = CGRectMake(0, 30, kScreenWidth, kScreenHeight-20-44-60);
        CGRect frame = scrollView.frame;
        frame.size.height = dayView.frame.size.height-30;
        scrollView.frame = frame;
        CGSize size = scrollView.contentSize;
        size.height = frame.size.height;
        scrollView.contentSize = size;
        for (int i = 0; i < 7; i++) {
            UITableView *tableView = (UITableView *)[scrollView viewWithTag:10000 + i];
            CGRect tableViewFrame = tableView.frame;
            tableViewFrame.size.height = frame.size.height;
            tableView.frame = tableViewFrame;
        }
        //设置周课表视图以及其子视图的frame
        weekView.frame = dayView.frame;
        weekScrollView.frame = frame;
    }
}
//修改子类的frame
- (void)changeSubViewsFrame:(BOOL)_toolViewShow
{
    if (_toolViewShow) {
        //设置日课表视图以及其子视图的frame
        dayView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44);
        CGRect frame = scrollView.frame;
        frame.size.height = dayView.frame.size.height-30;
        scrollView.frame = frame;
        CGSize size = scrollView.contentSize;
        size.height = frame.size.height;
        scrollView.contentSize = size;
        for (int i = 0; i < 7; i++) {
            UITableView *tableView = (UITableView *)[scrollView viewWithTag:10000 + i];
            CGRect tableViewFrame = tableView.frame;
            tableViewFrame.size.height = frame.size.height;
            tableView.frame = tableViewFrame;
        }
        //设置周课表视图以及其子视图的frame
        weekView.frame = dayView.frame;
        weekScrollView.frame = frame;
    } else {
        dayView.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight-20-44-40);
        CGRect frame = scrollView.frame;
        frame.size.height = dayView.frame.size.height-30;
        scrollView.frame = frame;
        CGSize size = scrollView.contentSize;
        size.height = frame.size.height;
        scrollView.contentSize = size;
        for (int i = 0; i < 7; i++) {
            UITableView *tableView = (UITableView *)[scrollView viewWithTag:10000 + i];
            CGRect tableViewFrame = tableView.frame;
            tableViewFrame.size.height = frame.size.height;
            tableView.frame = tableViewFrame;
        }
        //设置周课表视图以及其子视图的frame
        weekView.frame = dayView.frame;
        weekScrollView.frame = frame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    //本来显示，点击之后要隐藏
    if (weekChoseViewShow) {
        [UIView animateWithDuration:0.5 animations:^{
            weekChoseScrollView.frame = CGRectMake(0, -60, kScreenWidth, 60);
            [self changeSubViewsFrameByWeek:weekChoseViewShow];
            weekChoseViewShow = NO;
        } completion:^(BOOL finished) {
            if (_scrollView == scrollView) {
                int page = scrollView.contentOffset.x/kScreenWidth;
                for (int i = 0; i < 7; i++) {
                    TwoTitleButton *button = (TwoTitleButton *)[dayView viewWithTag:9000+i];
                    if (page == i) {
                        button.backgroundColor = Color_Gray;
                        if (sliderLabel) {
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.2];
                            CGRect rect = sliderLabel.frame;
                            rect.origin.x = (i+0.5)*kWidthGrid;
                            sliderLabel.frame = rect;
                            [UIView commitAnimations];
                        }
                    }else {
                        button.backgroundColor = [UIColor clearColor];
                    }
                    
                }
            }

        }];
    } else {
        if (_scrollView == scrollView) {
            int page = scrollView.contentOffset.x/kScreenWidth;
            if (page==6) {
                rightBtn.hidden =YES;
                leftBtn.hidden=NO;
            }else if (page==0) {
                rightBtn.hidden = NO;
                leftBtn.hidden=YES;
            }else{
                rightBtn.hidden = NO;
                leftBtn.hidden=NO;
            }
            [self day:page];
            [self locatedDaylabelColor:page];
            for (int i = 0; i < 7; i++) {
                TwoTitleButton *button = (TwoTitleButton *)[dayView viewWithTag:9000+i];
                if (page == i) {
                    button.backgroundColor = Base_Orange;
                    if (sliderLabel) {
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:0.2];
                        CGRect rect = sliderLabel.frame;
                        rect.origin.x = (i+0.5)*kWidthGrid;
                        sliderLabel.frame = rect;
                        [UIView commitAnimations];
                    }
                }else {
                    button.backgroundColor = [UIColor clearColor];
                }
            }
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int tag =(int)tableView.tag - 10000;
    return [dataArray[tag] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tag = (int)tableView.tag - 10000;
    DayTableViewCell *dayCell = [[[NSBundle mainBundle] loadNibNamed:@"DayTableViewCell" owner:self options:nil] objectAtIndex:0];
    dayCell.selectionStyle = UITableViewCellSelectionStyleGray;

    dayCell.backgroundColor = [UIColor clearColor];
    dayCell.courseName = self.roomNum;
    dayCell.weekCourse = [dataArray[tag] objectAtIndex:indexPath.row];
    if (dayCell.weekCourse.haveLesson) {
        tableView.separatorStyle = UITableViewCellSelectionStyleBlue;
    }else{
        dayCell.baseColor = [UIColor clearColor];
    }
    return dayCell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 120) {
        return 44;
    }
    int tag = (int)tableView.tag - 10000;
    WeekCourse *weekCourse = [dataArray[tag] objectAtIndex:indexPath.row];
    if (weekCourse.haveLesson) {
        return 102;
    }
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    int tag = (int)tableView.tag - 10000;
    //切换周视图和日视图
    [self dayOrWeekAction];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - WeekChoseViewDelegate
- (void)tapAction:(int)tag
{
    if (clickTag == 0) {
        clickTag = tag;
    }else {
        WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
        view.isChosen = NO;
        [view reset];
        clickTag = tag;
    }
    NSString *week = [[NSString alloc] initWithFormat:@"%d",tag-250+1];
    UIButton *weekButton = (UIButton *)[self.navigationItem.titleView viewWithTag:110];
    [weekButton setTitle:[NSString stringWithFormat:@"第%@周",week] forState:UIControlStateNormal];
    [weekButton setImageEdgeInsets:week.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
    [self bounceTargetView:weekButton];
    
    if(clickTag !=currentWeekTag){
        backLabel.hidden = NO;
    }
    else if(clickTag == currentWeekTag){
        backLabel.hidden = YES;
    }
    //重新加载
    [self loadCourseDataInfo];
}
-(void)setCurrentWeek:(NSString *)number
{
    
}
#pragma mark - XGAlertViewDelegate
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"course"];
}


@end
