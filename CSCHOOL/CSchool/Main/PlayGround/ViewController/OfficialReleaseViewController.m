//
//  OfficialReleaseViewController.m
//  CSchool
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OfficialReleaseViewController.h"
#import "OfficeReleaseTableViewCell.h"
#import "OfficalInfoViewController.h"
#import <MJRefresh.h>
#import "OfficalSearchController.h"
#import <objc/message.h>
@interface OfficialReleaseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_newsArr;
    NSMutableArray *_infoArr;
    NSMutableArray *_timeArr;
    NSMutableArray *_deparArr;
    NSString *_page;//页数
    NSMutableArray *_idArr;
    int  _pageNum;//页数
    
}
@property (nonatomic,strong)UITableView *mainTableView;
@end

@implementation OfficialReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=@"-1";
    _pageNum = -1;
    [self createView];
    [self loadData];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _newsArr = [NSMutableArray array];
    _timeArr = [NSMutableArray array];
    _idArr = [NSMutableArray array];
    _deparArr = [NSMutableArray array];

    if ([_type isEqualToString:@"2"]) {
        [self createNavBtn];
    }
}
//创建导航栏搜索按钮
-(void)createNavBtn
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(50, 0, 50, 50);
    [searchBtn setImage:[UIImage imageNamed:@"news_sou"] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(openSearchVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -8;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
}
-(void)createView{
    self.mainTableView = [UITableView new];
    self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
-(void)loadData
{
    if (_pageNum==-1) {
        _pageNum=1;
        [ProgressHUD show:@"正在加载..."];
        _page  =[NSString stringWithFormat:@"%d",_pageNum];
    }else{
        _pageNum++;
        _page  =[NSString stringWithFormat:@"%d",_pageNum];
    }
    int pageCount = kScreenHeight/50;
    NSString *count = [NSString stringWithFormat:@"%d",pageCount];

    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"showInfomationOrDocumentByInput",@"type":_type,@"page":_page,@"pageCount":count} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        [self.mainTableView.mj_footer endRefreshing];
        NSArray *arr = responseObject[@"data"];
        if (arr.count==0) {
            [ProgressHUD showError:@"没有更多信息了"];
            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        for (NSDictionary *dic in arr) {
            [_newsArr addObject:dic[@"title"]];
            [_timeArr addObject:dic[@"releaseTime"]];
            [_idArr addObject:dic[@"id"]];
            [_deparArr addObject:dic[@"releaseDepart"]];
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}
#pragma mark 打开搜索界面
-(void)openSearchVC
{
    OfficalSearchController *vc = [[OfficalSearchController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  私有方法
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]== [comp2 day] &&[comp1 month] == [comp2 month] &&[comp1 year]==[comp2 year];
}
-(int)cha:(NSDate *)newsDate
{
    NSDate *date = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:newsDate];
    if ([comp1 month] == [comp2 month] &&[comp1 year]==[comp2 year]) {
//        NSLog(@"时间差%d",(int)((long)[comp1 day]-(long)[comp2 day]));
        return (int)((long)[comp1 day]-(long)[comp2 day]);
    }else{
        return -1;
    }
    return -1;
}
#pragma mark UITableviewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"officeReleaseCell";
    OfficeReleaseTableViewCell *cell= [[OfficeReleaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.title.text = _newsArr[indexPath.row];
    cell.time.text = _timeArr[indexPath.row];
    cell.depatalLabel.text = [NSString stringWithFormat:@"发布部门:%@",_deparArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    switch ([self cha:newsDate]) {
        case 0:
        {
            cell.time.textColor = [UIColor redColor];
            cell.timeLabel.textColor = [UIColor redColor];
        }
            break;
        case 1:
        {
            cell.time.textColor = Base_Orange;
            cell.timeLabel.textColor = Base_Orange;
        }
            break;
            case 2:
        {
            cell.time.textColor = RGB(242, 177, 1);
            cell.timeLabel.textColor = RGB(242, 177, 1);
        }
            break;
        default:
            cell.time.textColor = Color_Gray;
            cell.timeLabel.textColor = Color_Gray;
            break;
    }
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
#pragma mark UITableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OfficalInfoViewController *vc = [[OfficalInfoViewController alloc]init];
    vc.newsID = _idArr[indexPath.row];
    vc.type = _type;
    [self.navigationController pushViewController:vc animated:YES];
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
