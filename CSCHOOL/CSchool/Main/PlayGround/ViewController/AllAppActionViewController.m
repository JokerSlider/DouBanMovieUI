//
//  AllAppActionViewController.m
//  CSchool
//
//  Created by mac on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AllAppActionViewController.h"
#import "UIView+SDAutoLayout.h"
#import "UIButton+BackgroundColor.h"
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
#import "BaseDataReportViewController.h"

#import "YLButton.h"
#define numOfLine 4

@interface AllAppActionViewController ()
{
    UIView *_buttonView;
    NSMutableArray *_buttonMutArray;//存放所有功能按钮
    NSMutableArray *_buttonShowArray; //存放要显示的功能按钮


}
@property (strong, nonatomic)  UIScrollView *mainScrollView;
@property (nonatomic, strong) UIButton *connectNetBtn;

@end

@implementation AllAppActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Base_Color2;
    self.title = @"全部功能";
    _mainScrollView = ({
        UIScrollView *view = [UIScrollView new];
        view;
    });
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    [self createViews];
    [self buttonShow];

}
- (void)createViews{

        //按钮
    [_mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSArray *btnTitleArray = @[@"缴费",@"报修",@"一键上网",@"课程表",@"成绩查询",@"考试查询",@"空教室",@"校车时刻表",@"校历",@"新闻资讯",@"讲座预告",@"一卡通查询", @"办公电话",@"班班通",@"校园地图",@"报销预约",@"工资查询",@"水花墙",@"考拉海购",@"云阅读",@"漫画",@"教工通讯录",@"办事指南",@"信息发布",@"公文发布", @"周会议",@"报告厅",@"重点工作",@"二手市场",@"失物招领",@"兼职招聘",@"网易慕课",@"规章制度", @"照片墙",@"实时公交",@"图书馆",@"读者榜",@"图书榜",@"就业信息",@"天下事",@"校内通",@"菁彩运动",@"摇一摇",@"消费统计",@"偏科统计表",@"个人成绩表",@"班级消费表",@"个人消费表",@"综合排名"];
    
    NSArray *btnImageArray = @[@"index_pay",@"index_repair",@"index_connect",@"index_classtable",@"index_score",@"index_exam",@"index_emptyroom",@"index_bus",@"index_schoolDate",@"index_schoolNews",@"index_lectures", @"index_schoolCard",@"index_officePhone",@"index_contacts",@"index_map",@"index_finance",@"index_salary",@"index_heart",@"index_caola",@"index_yunyuedu",@"index_manhua",@"index_teacherPhoneBook",@"index_banshizhinan_1",@"index_MessageRelease",@"index_OffRelease",@"index_weekMeeting",@"index_baogaoting", @"index_jiankong",@"index_market",@"index_lost_and_found",@"index_parttime",@"index_muke",@"index_rule",@"index_photo_wall", @"index_bus",@"index_library",@"index_rankreader",@"index_rankborrow",@"index_jiuye",@"index_worldNews",@"index_schoolChat",@"index_SchoolSport",@"index_shake",@"index_onecardPort",@"index_personScore",@"index_ScorePort",@"index_classCostPort",@"index_personCost",@"index_neesStudentList"];

    _buttonView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });

    
    [_mainScrollView addSubview:_buttonView];
    [_mainScrollView setupAutoContentSizeWithBottomView:_buttonView bottomMargin:0];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    
    _buttonView.sd_layout
    .leftSpaceToView(_mainScrollView,0)
    .rightSpaceToView(_mainScrollView,0)
    .topSpaceToView(_mainScrollView,1);
    
    CGFloat btnWith = kScreenWidth/numOfLine;
    _buttonMutArray = [NSMutableArray array];
    for (int i=0; i<btnTitleArray.count; i++) {
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:btnImageArray[i]] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(85, 85, 85) forState:UIControlStateNormal];
        btn.titleLabel.font = Title_Font;
        btn.imageRect = CGRectMake((btnWith-LayoutHeightCGFloat(30))/2, 10, 40, 40);
        btn.titleRect = CGRectMake(5, 55, btnWith, 20);

        [btn setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
//        btn.imageEdgeInsets = UIEdgeInsetsMake(10,(btnWith-LayoutHeightCGFloat(28))/2,LayoutHeightCGFloat(34),(btnWith-LayoutHeightCGFloat(36))/2);
//        btn.titleEdgeInsets = UIEdgeInsetsMake(LayoutHeightCGFloat(45), -btn.titleLabel.bounds.size.width-25, 0, 0);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i==2) {
            [btn setImage:[UIImage imageNamed:@"index_break"] forState:UIControlStateSelected];
            [btn setTitle:@"断开" forState:UIControlStateSelected];
            _connectNetBtn = btn;
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonViewAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonMutArray addObject:btn];
    }
}

- (void)buttonShow{
    CGFloat btnWith = kScreenWidth/numOfLine;
    UIButton *lastButton;
    //将要显示的按钮，存放到这个数组中。
#ifdef isDEBUG
    _buttonShowArray = _buttonMutArray;
#else
    [_buttonView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _buttonShowArray = [NSMutableArray array];
    for (NSDictionary *dic in [AppUserIndex GetInstance].appListArray) {
        NSInteger index = [dic[@"AI_ID"] integerValue]-1;
        if (index < _buttonMutArray.count) {
            if ([dic[@"RSA_ENABLE"] boolValue]) {
                UIButton *btn = _buttonMutArray[index];
                [btn setTitle:dic[@"AI_NAME"] forState:UIControlStateNormal];
                
                [_buttonShowArray addObject:btn];
            }else{
                UIButton *btn = _buttonMutArray[index];
                [btn addTarget:self action:@selector(notOpenShow:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 99999;
                [_buttonShowArray addObject:btn];
            }
        }
    }
#endif
    //绘制按钮
    for (int i=0; i<_buttonShowArray.count; i++) {
        UIButton *btn = _buttonShowArray[i];
        btn.frame = CGRectMake((i%numOfLine)*btnWith, i/numOfLine*LayoutHeightCGFloat(80), btnWith, LayoutHeightCGFloat(80));
        
        [_buttonView addSubview:btn];
        if (i%numOfLine!=0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((i%numOfLine)*btnWith, i/numOfLine*LayoutHeightCGFloat(80)+5, 1, LayoutHeightCGFloat(70))];
            lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buttonView addSubview:lineView];
        }
        if (i/numOfLine != 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5+(i%numOfLine)*btnWith, i/numOfLine*LayoutHeightCGFloat(80), btnWith-10, 1)];
            lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buttonView addSubview:lineView];
        }
        lastButton = btn;
        
    }
    
    //没按钮时，画上多余的线
    if (_buttonShowArray.count%numOfLine!=0) {
        for (int i=_buttonShowArray.count; i<_buttonShowArray.count+(numOfLine-_buttonShowArray.count%numOfLine); i++) {
            if (i%numOfLine!=0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((i%numOfLine)*btnWith, i/numOfLine*LayoutHeightCGFloat(80)+5, 1, LayoutHeightCGFloat(70))];
                lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [_buttonView addSubview:lineView];
            }
            if (i/numOfLine != 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5+(i%numOfLine)*btnWith, i/numOfLine*LayoutHeightCGFloat(80), btnWith-10, 1)];
                lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [_buttonView addSubview:lineView];
            }
        }
    }
    if (lastButton) {
        [_buttonView setupAutoHeightWithBottomView:lastButton bottomMargin:0];
    }else{
        _buttonView.sd_layout.heightIs(0);
    }
    
}

- (void)notOpenShow:(UIButton *)sender{
    XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"暂未开放！" WithCancelButtonTitle:@"确定" withOtherButton:nil];
    [alert show];
}
#pragma mark   点击事件

//buttonView点击事件
- (void)buttonViewAction:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:
        {
            [self payViewAction:sender];
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
            [self openPort:sender];
        }
            break;
        case 44:{
            [self openPort:sender];
            
        }
            break;
        case 45:{
            [self openPort:sender];
            
        }
            break;
        case 46:{
            [self openPort:sender];
            
        }
            break;
        case 47:{
            [self openPort:sender];
            
        }
            break;
        case 48:{
            [self openPort:sender];
            
        }
            break;
        case 49:{
//            [self openAllFunction];
            
        }
            break;
        default:
            
            break;
    }
    
}

-(void)openPort:(UIButton *)sender
{
    BaseDataReportViewController *vc = [[BaseDataReportViewController alloc]init];
    vc.dataType = sender.tag-43;
    vc.title = sender.titleLabel.text;
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
- (void)payViewAction:(UIButton *)sender{
    PaySelectViewController *vc = [[PaySelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//打开空教室界面
- (void)openFreeRoomVC{
    FreeBuildViewController *vc = [[FreeBuildViewController alloc] init];
//    ShakeChatViewController *vc = [[ShakeChatViewController alloc] init];
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
    //    PhotoWallIndexViewController *vc = [[PhotoWallIndexViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
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
