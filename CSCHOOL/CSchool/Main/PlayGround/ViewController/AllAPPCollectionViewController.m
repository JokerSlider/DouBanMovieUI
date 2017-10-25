//
//  AllAPPCollectionViewController.m
//  CSchool
//
//  Created by mac on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AllAPPCollectionViewController.h"
#import "ModelarCollectionView.h"
#import "DQModel.h"
#import "DQTool.h"
#import "APPCollectionViewCell.h"
#import "ZWAdView.h"
#import "XGAlertView.h"
#import "AboutUsViewController.h"
#import "ConfigObject.h"
#import "Reachability.h"
#import "PaySelectViewController.h"
#import "CourseViewController.h"
#import "BaseNavigationController.h"
#import "XGButton.h"
#import "FreeRoomViewController.h"
#import "FreeBuildViewController.h"
#import "ExamViewController.h"
#import "QuestionListViewController.h"
#import "PushMsgViewController.h"
#import "CCLocationManager.h"
#import <JSONKit.h>
#import "BaseConfig.h"
#include <sys/socket.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "QueryScoreViewController.h"
#import "ExamPlanViewController.h"
#import "WebViewController.h"
#import "DepartmentListViewController.h"
#import "NewsViewController.h"
#import "SchoolCardBalanceViewController.h"
#import "OneCardViewController.h"
#import "UIButton+BackgroundColor.h"
#import "SchoolMapRouteViewController.h"
#import "QueryScoreClassListViewController.h"
#import "ChooseTypeViewController.h"
#import "FinanceIndexViewController.h"
#import "OrderTimeViewController.h"
#import "SalaryrqueryLoginViewController.h"
#import "RxWebViewController.h"
#import "RxWebViewNavigationViewController.h"
#import "SalaryViewController.h"
#import "ShuihuaqiangViewController.h"
#import "SchoolBusListViewController.h"
#import "CounselorViewController.h"
#import "ClassPhoneNumViewController.h"
#import "PackageInfoViewController.h"
#import "BaseListSelectViewController.h"
#import "AutoWebViewController.h"
#import "WeekListViewController.h"
#import "JhtLoadDocViewController.h"
#import "OfficialReleaseViewController.h"
#import "ImportWorkListViewController.h"
#import "NewChooseTimeViewController.h"
#import "MarketSendViewController.h"
#import "FinfLosedViewController.h"
#import "EmployessPhoneNumViewController.h"
#import "SignViewController.h"
#import "PhotoWallIndexViewController.h"
#import "EmployessContactBookViewController.h"
#import "MukeViewController.h"
#import "BusRouteViewController.h"
#import "SchoolBusLocatedViewController.h"
#import "LibarySearchViewController.h"
#import "LibraryViewController.h"
#import "JobMessageViewController.h"
#import "BookListViewController.h"
#import "ReaderListViewController.h"
#import "IndexNewsCell.h"
#import "SDAutoLayout.h"
#import "FinderBottomView.h"
#import "PhotoWallDetailViewController.h"
#import "FinanceOderListViewController.h"
#import <YYModel.h>
#import "WorldNewsViewController.h"
#import "GuideView.h"
#import "ChatMianViewController.h"

#import "MemberListViewController.h"
#import "ChatMessageViewController.h"
#import "CSportViewController.h"
#import "ShakeChatViewController.h"
//#import "BestSchoolMainViewController.h"
#import "AllAppActionViewController.h"
#import "MyLayout.h"
#import "BaseDataReportViewController.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
//每个格子的高度
#define GridHeight 120
//每行显示格子的列数
#define PerRowGridCount 4
//每个格子的宽度
#define GridWidth (KScreenWidth/PerRowGridCount)-1

@interface AllAPPCollectionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,RTDragCellTableViewDataSource,RTDragCellTableViewDelegate>

@property (nonatomic, strong) ModelarCollectionView *DQCollectionView;

@property (nonatomic, strong) NSMutableArray <DQModel *> *DataArr;
@end

@implementation AllAPPCollectionViewController

- (NSMutableArray<DQModel *> *)DataArr{
    if (!_DataArr) {
        _DataArr = [NSMutableArray new];
    }
    return _DataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部功能";
    self.view.backgroundColor = [UIColor whiteColor];
    MyLayout    *flowLayout = [[MyLayout alloc]init] ;
    flowLayout.itemSize = CGSizeMake(GridWidth, GridHeight) ;
    flowLayout.minimumLineSpacing = 0.1;
    flowLayout.minimumInteritemSpacing = 0.1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical ;
    
    self.DQCollectionView = [[ModelarCollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) collectionViewLayout:flowLayout] ;
    [_DQCollectionView registerClass:[APPCollectionViewCell class] forCellWithReuseIdentifier:@"APPcell"];
    self.DQCollectionView.delegate = self ;
    self.DQCollectionView.dataSource = self ;
    self.DQCollectionView.adelegate = self ;
    self.DQCollectionView.adataSource = self ;
    self.DQCollectionView.alwaysBounceVertical = YES;
    self.DQCollectionView.showsVerticalScrollIndicator = NO;
    self.DQCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.DQCollectionView] ;
    self.DQCollectionView.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *Arr = [NSMutableArray array];//假如 这是后面返回 要显示的内容
     NSArray *titleArr = @[@"缴费",@"报修",@"一键上网",@"课程表",@"成绩查询",@"考试查询",@"空教室",@"校车时刻表",@"校历",@"新闻资讯",@"讲座预告",@"一卡通查询", @"办公电话",@"班班通",@"校园地图",@"报销预约",@"工资查询",@"水花墙",@"考拉海购",@"云阅读",@"漫画",@"教工通讯录",@"办事指南",@"信息发布",@"公文发布", @"周会议",@"报告厅",@"重点工作",@"二手市场",@"失物招领",@"兼职招聘",@"网易慕课",@"规章制度", @"照片墙",@"实时公交",@"图书馆",@"读者榜",@"图书榜",@"就业信息",@"天下事",@"校内通",@"菁彩运动",@"摇一摇",@"一卡通消费统计",@"个人偏科统计",@"个人成绩相关统计",@"班级消费统计",@"个人消费统计",@"贫困生排名"];
    for (int i=0; i<titleArr.count; i++) {
        NSString *num = [NSString stringWithFormat:@"%d",i];
        [Arr addObject:num];
    }
    
    NSArray *array = [DQTool InitializeDateFunction:Arr];
    self.DataArr = [array mutableCopy];
    [self.DQCollectionView reloadData];
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.DataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    APPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"APPcell" forIndexPath:indexPath] ;
    [cell SetDataFromModel:self.DataArr[indexPath.row]];
    return cell ;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(GridWidth, GridHeight);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1);//上 左  下 右
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击事件
    APPCollectionViewCell *cell =(APPCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%@----------%@",cell.title.text,cell.ai_id);
    int  num = [cell.ai_id intValue];
    switch (num) {
        case 0:
        {
            [self payViewAction];
        }
            break;
        case 1:
        {
            [self callRepair];
        }
            break;
        case 2:
        {
            
            [JohnAlertManager showFailedAlert:@"请回到操场界面进行一键上网" andTitle:@"提示"];
        }
            break;
            //课程表
        case 3:
        {
            [self openCourseVC];
        }
            break;
        case 4:{
            
            [self openQueryScoreVC];
            
        }
            break;
        case 5:{
            [self openExamViewC];
        }
            break;
        case 6:{
            [self openFreeRoomVC];
        }
            break;
        case 7:{
            [self openSchoolBus];
        }
            break;
        case 8:{
            [self openCalender];
        }
            break;
        case 9:
        {
            [self openNews];
        }
            break;
        case 10:{
            [self openJZVC];
        }
            break;
        case 11:{
            [self oneCardVC];
        }
            break;
        case 12:{
            [self openPhoneBook];
        }
            break;
        case 13:{
            
            [self openConselorVC];
        }
            break;
        case 14:{
            [self openMap];
        }
            break;
        case 15:{
            [self openFinance];
        }
            break;
        case 16:{
            //工资
            [self openQuerySalary];
        }
            break;
        case 17:{
            //水花强
            [self openShuihua];
        }
            break;
        case 18:{
            //考拉海购
            [self openKaola];
        }
            break;
        case 19:{
            //云阅读
            [self openRead];
        }
            break;
        case 20:{
            //漫画
            [self openManhua];
        }
            break;
        case 21:{
            //教职工通讯录
            [self openOfficeAddressBook];
            
        }
            break;
        case 22:{
            //办公指南
            [self openBangongZhinan];
            
        }
            break;
        case 23:{
            //信息发布
            [self openMessageRelease];
            
        }
            break;
        case 24:{
            //公文发布
            [self openOfficalRelease];
        }
            break;
        case 25:
        {
            //每周会议
            [self openWeekMeeting:@"1"];
        }
            break;
        case 26:
        {
            //报告厅
            [self openWeekMeeting:@"2"];
        }
            break;
        case 27:{
            //重点工作监控
            [self openImportWork];
        }
            break;
        case 28:
        {
            //二手
            [self openMarket];
        }
            break;
        case 29:
        {
            //失物招领
            [self openLostFind];
        }
            break;
        case 30:
        {
            //兼职招聘
            [self Parttimjob];
        }
            break;
        case 31:
        {
            //慕课
            [self openMukeVC];
        }
            break;
        case 32:{
            //规章制度
            [self openGuizhangZhidu];
        }
            break;
        case 33:{
            //照片墙
            [self openPhotoWall];
        }
            break;
        case 34:{
            //实时公交
            [self openBusRoute];
        }
            break;
        case 35:{
            //实时公交
            [self openLibary];
        }
            break;
            //读者榜
        case 36:
        {
            [self openReaderList];
        }
            break;
            //借阅榜
        case 37:
        {
            [self openBookList];
        }
            break;
            //就业咨询
        case 38:
        {
            [self openJobMessage];
        }
            break;
        case 39:{
            //天下事
            
            [self openWorldNews];
        }
            break;
        case 40:{
            [self openChatView];
        }
            break;
        case 41:{
            [self openSportListView];
        }
            break;
        case 42:{
            [self openShakeView];
        }
            break;
        case 43:{
            [self openPort:num-43 withTitle:cell.title.text];
        }
            break;
        case 44:{
            [self openPort:num-43 withTitle:cell.title.text];
            
        }
            break;
        case 45:{
            [self openPort:num-43 withTitle:cell.title.text];
            
        }
            break;
        case 46:{
            [self openPort:num-43 withTitle:cell.title.text];
            
        }
            break;
        case 47:{
            [self openPort:num-43 withTitle:cell.title.text];
            
        }
            break;
        case 48:{
            [self openPort:num-43 withTitle:cell.title.text];
            
        }
            break;
        default:
            
            break;
    }
    
}
#pragma mark  点击事件
-(void)openPort:(NSInteger)type withTitle:(NSString *)title
{
    BaseDataReportViewController *vc = [[BaseDataReportViewController alloc]init];
    vc.dataType = type;
    vc.title = title;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openShakeView
{
    ShakeChatViewController *vc = [[ShakeChatViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//打开菁彩运动
-(void)openSportListView
{
    //    ChatMianViewController *vc = [[ChatMianViewController alloc]init];
    CSportViewController *vc = [[CSportViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//校内通
-(void)openChatView
{
    ChatMianViewController *vc = [[ChatMianViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)openWorldNews
{
    WorldNewsViewController *vc = [[WorldNewsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//就业信息
-(void)openJobMessage
{
    JobMessageViewController *vc = [[JobMessageViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//读者排行榜
-(void)openReaderList
{
    ReaderListViewController *vc = [[ReaderListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
//借阅排行榜
-(void)openBookList
{
    BookListViewController *vc = [[BookListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//图书馆
-(void)openLibary
{//
    LibraryViewController *vc = [[LibraryViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//公交车
-(void)openBusRoute
{
    SchoolBusLocatedViewController *vc = [[SchoolBusLocatedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//慕课
-(void)openMukeVC
{
    MukeViewController *vc = [[MukeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//失物招领
-(void)openLostFind
{
    FinfLosedViewController *vc = [[FinfLosedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.funcType = @"1";
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//兼职招聘
-(void)Parttimjob
{
    FinfLosedViewController *vc = [[FinfLosedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.funcType = @"3";
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//二手市场
-(void)openMarket
{
    FinfLosedViewController *vc = [[FinfLosedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.funcType = @"2";
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//重点工作监控
- (void)openImportWork{
    ImportWorkListViewController *vc = [[ImportWorkListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//信息发布
-(void)openMessageRelease{
    
    
    OfficialReleaseViewController *vc = [[OfficialReleaseViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"1";
    vc.title = @"信息发布";
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//公文发布
-(void)openOfficalRelease
{
    OfficialReleaseViewController *vc = [[OfficialReleaseViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"2";
    vc.title = @"公文发布";
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//办公指南
- (void)openBangongZhinan{
    BaseListSelectViewController *vc = [[BaseListSelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    vc.delegate = self;
    vc.commitDic = @{@"rid":@"getGuideInfo",@"type":@"1"};
    vc.navigationItem.title = @"办事指南";
    [self.navigationController pushViewController:vc animated:YES];
}

//规章制度
- (void)openGuizhangZhidu{
    BaseListSelectViewController *vc = [[BaseListSelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    vc.delegate = self;
    vc.commitDic = @{@"rid":@"getGuideInfo",@"type":@"2"};
    vc.navigationItem.title = @"规章制度";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectVc:(UIViewController *)vc didSelectCellWithDic:(NSDictionary *)dic{
    NSDictionary *commitDic = @{@"rid":@"showGuideInfoById",@"uid":dic[@"RTID"]};
    AutoWebViewController *webVC = [[AutoWebViewController alloc] init];
    webVC.commitDic = commitDic;
    webVC.valueForKeyPath = @"data.SGCONTENT";
    webVC.navigationItem.title = dic[@"RTNAME"];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

//每周会议WeekListViewController
- (void)openWeekMeeting:(NSString *)typeString{
    WeekListViewController *vc = [[WeekListViewController alloc] init];
    vc.typeString = typeString;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//教工通讯录
-(void)openOfficeAddressBook
{
    //    EmployessPhoneNumViewController *vc = [[EmployessPhoneNumViewController alloc]init];
    EmployessContactBookViewController*vc = [[EmployessContactBookViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"教工通讯录";
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)openShuihua{
//    BestSchoolMainViewController *vc = [[BestSchoolMainViewController alloc]init];
    ShuihuaqiangViewController *vc = [[ShuihuaqiangViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//班级通讯录查询
-(void)openConselorVC
{
    
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *role_type = [NSString stringWithFormat:@"%@",user.role_type];
    if ([role_type isEqualToString:@"1"]) {
        CounselorViewController *vc = [[CounselorViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"班班通";
        vc.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        ClassPhoneNumViewController *vc = [[ClassPhoneNumViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"班班通";
        vc.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//工资查询
-(void)openQuerySalary
{
    if ([AppUserIndex GetInstance].salaryUserName) {
        SalaryViewController *vc = [[SalaryViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        SalaryrqueryLoginViewController *vc = [[SalaryrqueryLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//打开云阅读
- (void)openRead{
    
    //    WebViewController *vc = [[WebViewController alloc] init];
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://m.yuedu.163.com/?_tdchannel=X8Joccry5&_tdcid=j3Oocekjr"]];//
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//漫画
- (void)openManhua{
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://manhua.163.com?utm_source=qingcai"]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//考拉
- (void)openKaola{
    
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://m.kaola.com/"]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//打开预约报销
- (void)openFinance{
    FinanceIndexViewController *vc = [[FinanceIndexViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//打开地图
- (void)openMap{
    SchoolMapRouteViewController *vc = [[SchoolMapRouteViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//一卡通余额
-(void)oneCardVC
{
    OneCardViewController *vc = [[OneCardViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//讲座预告
-(void)openJZVC
{
    NewsViewController *vc = [[NewsViewController alloc]init];
    vc.title = @"讲座预告";
    vc.isNews = NO;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)openNews
{
    NewsViewController *vc = [[NewsViewController alloc]init];
    vc.title = @"新闻资讯";
    vc.isNews = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//办公电话
- (void)openPhoneBook{
    DepartmentListViewController *vc = [[DepartmentListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)openSchoolBus{
    
    SchoolBusListViewController *vc = [[SchoolBusListViewController alloc] init];
    vc.type = @"2";
    vc.navigationItem.title = @"校车";
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self UMengEvent:@"schoolBus"];
    
}
//打开校历
- (void)openCalender{
    
    SchoolBusListViewController *vc = [[SchoolBusListViewController alloc] init];
    vc.type = @"1";
    //    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:WEB_URL_HELP(@"SchoolCalander.html")]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    vc.navigationItem.title = @"校历";
    [self.navigationController pushViewController:vc animated:YES];
}

//打开考试查询界面
-(void)openExamViewC
{
    ExamPlanViewController *vc = [[ExamPlanViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self UMengEvent:@"examPlan"];
}
//打开套餐选择页面
- (void)payViewAction{
    PaySelectViewController *vc = [[PaySelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//打开空教室界面
- (void)openFreeRoomVC{
    //    FreeBuildViewController *vc = [[FreeBuildViewController alloc] init];
    ShakeChatViewController *vc = [[ShakeChatViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self UMengEvent:@"emptyRoom"];
    
}
//打开课程表界面
-(void)openCourseVC
{
    CourseViewController *courseVC = [[CourseViewController alloc] init];
    courseVC.hidesBottomBarWhenPushed = YES;
    courseVC.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:courseVC animated:YES];
    [self UMengEvent:@"timeTable"];
    
}

//打开成绩查询界面
- (void)openQueryScoreVC{
    
    QueryScoreViewController *vc = [[QueryScoreViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    //    if ([[AppUserIndex GetInstance].role_type isEqualToString:@"1"]) {
    //        QueryScoreClassListViewController *vc = [[QueryScoreClassListViewController alloc] init];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        vc.tabBarController.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }else{
    //        QueryScoreViewController *vc = [[QueryScoreViewController alloc] init];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        vc.tabBarController.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
    
    [self UMengEvent:@"queryScore"];
    
}

- (void)callRepair{
    
    QuestionListViewController *vc = [[QuestionListViewController alloc] init];
    //    PhotoWallIndexViewController *vc = [[PhotoWallIndexViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openPhotoWall{
    //    WorldNewsViewController *vc =
    
    PhotoWallIndexViewController *vc = [[PhotoWallIndexViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openSignVC{
    
    SignViewController *vc = [[SignViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
- (void)tableView:(ModelarCollectionView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    //改变数组
    self.DataArr = [NSMutableArray arrayWithArray:newArray] ;
    
}
/**选中的cell完成移动，手势已松开*/
- (void)cellDidEndMovingInTableView:(ModelarCollectionView *)tableView{
    //保存数据
    [DQTool SaveUserDefaultsDataFunction:self.DataArr];
    
}
- (NSArray *)originalArrayDataForTableView:(ModelarCollectionView *)tableView{
    
    return self.DataArr;
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
