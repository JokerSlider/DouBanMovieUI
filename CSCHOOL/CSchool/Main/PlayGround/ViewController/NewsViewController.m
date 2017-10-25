//
//  NewsViewController.m
//  CSchool
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewsInfoViewController.h"
#import <MJRefresh.h>
#import "UILabel+stringFrame.h"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,XGAlertViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NewsViewController
{
    NSMutableArray *_newsArr;
    NSMutableArray *_infoArr;
    NSMutableArray *_timeArr;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [ProgressHUD dismiss];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
}
-(void)loadData
{
    _newsArr = [NSMutableArray array];
    _timeArr = [NSMutableArray array];
    _infoArr = [NSMutableArray array];
    [ProgressHUD show:@"正在加载..."];
    NSString *type;
    type= _isNews?@"0":@"1";
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"showNews",@"type":type} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            [ProgressHUD dismiss];
            for (NSDictionary * dic in responseObject[@"data"]) {
                [_newsArr addObject:dic[@"NEWS_TITLE"]];
                [_infoArr addObject:dic[@"NEWSID"]];
                [_timeArr addObject:dic[@"TIME"]];
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [ProgressHUD dismiss];
            [self showErrorViewLoadAgain:[error objectForKey:@"msg"]];
        }];
}
#pragma mark
-(void)createView{
    self.tableView = [UITableView new];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}
//解决分割线不到左边界的问题
-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark 私有方法
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]== [comp2 day] &&[comp1 month] == [comp2 month] &&[comp1 year]==[comp2 year];
}
//将数组按照时间顺序重新排列
-(void)reloadTimeArr
{

    [self.tableView reloadData];
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"NewsCell";
    NewsTableViewCell *cell= [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.title.text = _newsArr[indexPath.row];
    NSString *releaseTime = _timeArr[indexPath.row];
    cell.time.text = [self changeTimeStr:releaseTime];
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *newsDate =[dateFormat dateFromString:_timeArr[indexPath.row]];
    BOOL result = [self isSameDay:date date2:newsDate];
    //不是新闻  new隐藏
    if (!result) {
        cell.newsLabel.hidden = YES;
    }
    return cell;
}
/**
 *  将时间精确到天
 *
 *  @param timeStr 原始时间字符串
 *
 *  @return 返回精确到天的字符串
 */
-(NSString *)changeTimeStr:(NSString *)timeStr
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date = [dateFormat dateFromString:timeStr];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    timeStr = [dateFormat stringFromDate:date ];
    return timeStr;
}


#pragma XgAlrtDelete
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title;
{
    if (view.tag==1000) {
        [self loadData];
    }
}

#pragma mark UITableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsInfoViewController *info = [[NewsInfoViewController alloc]init];
    info.infoTitle = _newsArr[indexPath.row];
    info.newsinfotime = [self changeTimeStr:_timeArr[indexPath.row]];
    info.newsID = _infoArr[indexPath.row];
    if (_isNews) {
        info.title = @"新闻详情";
    }else
    {
        info.title = @"讲座详情";
    }
    [self.navigationController pushViewController:info animated:YES];
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 60;
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
