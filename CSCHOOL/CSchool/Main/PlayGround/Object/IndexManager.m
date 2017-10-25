//
//  IndexManager.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/10/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "IndexManager.h"
#import "ZWAdView.h"
#import "AboutUsViewController.h"
#import "PaySelectViewController.h"
#import "CourseViewController.h"
#import "BaseNavigationController.h"
#import "XGButton.h"
#import "FreeRoomViewController.h"
#import "FreeBuildViewController.h"
#import "ExamViewController.h"
#import "QuestionListViewController.h"
#import "PushMsgViewController.h"
#import "BaseConfig.h"
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
#import "MemberListViewController.h"
#import "DiningHallListController.h"
#import "HQXMPPChatRoomManager.h"
#import "ChatMessageViewController.h"
#import "CSportViewController.h"
#import "ShakeChatViewController.h"
#import "ChatMianViewController.h"
#import "WorldNewsViewController.h"
#import "JZLocationConverter.h"
#import "StudySelfIndexViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "OAMainViewController.h"
#import "WIFILocationSignMainController.h"
#import "StuWifiSignHistoryController.h"

#import "YunListViewController.h"
#import "ActivityListController.h"
#import "ActivityListController.h"
#import <JSONKit.h>
//获取mac地址-->
#import "Address.h"
#import "ICMP.h"
#import "ARP.h"
#import "MDNS.h"
//<--
#import "UserPhoneInputViewController.h"
#import "UserPhoneInput2ViewController.h"
#import "UserPhoneInput3ViewController.h"
#import "BasePhoneViewController.h"
#import "BusForNewStuController.h"
#import "NewStudentInfoViewController.h"
#import "XueBaViewController.h"
#import "IndexManager.h"
#import "ConfigObject.h"
#import "StudyStyleController.h"

@implementation IndexManager
{
    BaseViewController *_indexVC;
}
static IndexManager *_shareConfig;

+ (IndexManager *)shareConfig{
    @synchronized ([IndexManager class]) {
        if (_shareConfig == nil) {
            _shareConfig = [[IndexManager alloc] init];
        }
    }
    return _shareConfig;
}

- (NSArray *)iconsArray{
    return @[@"index_pay",@"index_repair",@"index_connect",@"index_classtable",@"index_score",@"index_exam",@"index_emptyroom",@"index_bus",@"index_schoolDate",@"index_schoolNews",@"index_lectures", @"index_schoolCard",@"index_officePhone",@"index_contacts",@"index_map",@"index_finance",@"index_salary",@"index_heart",@"index_caola",@"index_yunyuedu",@"index_manhua",@"index_teacherPhoneBook",@"index_banshizhinan",@"index_MessageRelease",@"index_OffRelease",@"index_weekMeeting",@"index_baogaoting", @"index_jiankong",@"index_market",@"index_lost_and_found",@"index_parttime",@"index_muke",@"index_rule",@"index_photo_wall", @"index_bus",@"index_library",@"index_rank_reader",@"index_rank_borrow",@"index_jiuye",@"index_goNews",@"index_chat",@"index_sport",@"index_shake",@"index_Prise",@"index_bang",@"index_busForNew", @"index_fenban",@"index_xueba",@"index_can", @"index_xuefeng",@"index_OAOffical",@"index_zi"];
}

-(NSArray *)titlesArray{
    return @[@"缴费",@"报修",@"一键上网",@"课程表",@"成绩查询",
             @"考试查询",@"空教室",@"校车时刻表",@"校历",@"新闻资讯",
             @"讲座预告",@"一卡通查询", @"办公电话",@"班班通",@"校园地图",
             @"报销预约",@"工资查询",@"水花墙",@"考拉海购",@"云阅读",
             @"漫画",@"教工通讯录",@"办事指南",@"信息发布",@"公文发布",
             @"周会议",@"报告厅",@"重点工作",@"二手市场",@"失物招领",
             @"兼职招聘",@"网易慕课",@"规章制度", @"照片墙",@"实时公交",
             @"图书馆",@"读者榜",@"图书榜",@"就业信息",@"天下事",
             @"校内通",@"菁彩运动",@"摇一摇",@"抽奖",@"手机验证",
             @"迎新接站",@"分班信息",@"学霸排行榜",@"餐厅排行榜",@"学风排行榜",@"移动办公",
             @"自习室"];
}

//buttonView点击事件
- (void)buttonViewAction:(UIButton *)sender withVC:(UIViewController *)vc{
    _indexVC = vc;
    if (sender.tag!=2) {
        AppUserIndex *shareConfig = [AppUserIndex GetInstance];
        NSMutableArray *funcArr =[NSMutableArray arrayWithArray:shareConfig.funcMsgArr];
        [funcArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            if ([obj[@"funcID"] isEqualToString:[NSString stringWithFormat:@"%ld",sender.tag]]&&![obj[@"msgNum"] isEqualToString:@"remove"]) {
                // do sth
                [self removeFunctionNotification:sender.tag];
                *stop = YES;
            }
        }];

    }
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
//            if (ISNEWVERSION) {
//                sender.selected?[self LogoutToNet]:[self newKeyToInternet];
//
//            }else{
//                sender.selected?[self breakToNet]:[self oneKeyToNet];
//            }
            
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
            [self openMessageRelease:sender];
            
        }
            break;
        case 24:{
            //公文发布
            [self openOfficalRelease:sender];
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
            [self openPriseView];
        }
            break;
        case 44:
            [self showBundPhone:sender];
            break;
        case 45:
            [self  openBusForNewStu];
            break;
        case 46:{
            [self newStudentInfo:sender]; //新生班级信息
        }
            break;
        case 47:
            [self openXueba];
            break;
        case 48:
            //餐厅
            [self openDingHallList];
            break;
        case 49:
            //学风排行
            [self openXuefeng];
            break;
        case 50:
            //移动OA
            [self openOA];
            break;
            case 51:
            [self openSelfStudy];
            break;
        default:
            
            break;
    }
}
//点击移除小角标
-(void)removeFunctionNotification:(NSInteger)ID
{
    NSDictionary *dic = @{
                          @"funcID":[NSString stringWithFormat:@"%ld",ID],
                          @"msgNum":@"remove"
                          };
    NSNotification *allFuncNote = [[NSNotification alloc]initWithName:RemoveFunctionNotication object:dic userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:allFuncNote];
    
    AppUserIndex *shareConfig = [AppUserIndex GetInstance];
    NSMutableArray *funcArr =[NSMutableArray arrayWithArray:shareConfig.funcMsgArr];

    [funcArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"funcID"] isEqualToString:[NSString stringWithFormat:@"%ld",ID]]) {
            // do sth
            [funcArr removeObject:obj];
            [funcArr addObject:dic];
            *stop = YES;
        }
    }];
    shareConfig.funcMsgArr = funcArr;
    [shareConfig saveToFile];
}

- (void)openOA{
    OAMainViewController *vc = [OAMainViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
-(void)openDingHallList
{
    DiningHallListController *vc = [DiningHallListController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
-(void)openXuefeng
{
    StudyStyleController *vc = [[StudyStyleController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
- (void)openXueba{
    XueBaViewController *vc = [[XueBaViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

-(void)openBusForNewStu
{
    BusForNewStuController *vc = [[BusForNewStuController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
//自习室签到
- (void)openSelfStudy{
    //    BusForNewStuController *vc = [[BusForNewStuController alloc] init];
    
    StudySelfIndexViewController *vc = [[StudySelfIndexViewController alloc] init];
    //    YunListViewController *vc = [[YunListViewController alloc] initWithPath:nil];
    //    OAMainViewController *vc = [OAMainViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}

-(void)openWIFISign
{
    if ([[AppUserIndex GetInstance].role_type isEqualToString:@"1"]) {
        WIFILocationSignMainController *vc = [[WIFILocationSignMainController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [_indexVC.navigationController pushViewController:vc animated:YES];
    }else{
        StuWifiSignHistoryController *vc = [StuWifiSignHistoryController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [_indexVC.navigationController pushViewController:vc animated:YES];
    }
}

//OA办公
-(void)openOAOffical
{
    OAMainViewController *vc = [[OAMainViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
-(void)openPriseView
{
    ActivityListController *vc1 = [[ActivityListController alloc]init];
    vc1.hidesBottomBarWhenPushed = YES;
    vc1.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc1 animated:YES];
    
}

-(void)openShakeView
{
    ShakeChatViewController *vc = [[ShakeChatViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//打开菁彩运动
-(void)openSportListView
{
    CSportViewController *vc = [[CSportViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}
//校内通
-(void)openChatView
{
    ChatMianViewController *vc = [[ChatMianViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];

}
-(void)openWorldNews
{
    WorldNewsViewController *vc = [[WorldNewsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
//就业信息
-(void)openJobMessage
{
    JobMessageViewController *vc = [[JobMessageViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
//读者排行榜
-(void)openReaderList
{
    ReaderListViewController *vc = [[ReaderListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
-(void)openBookList
{
    BookListViewController *vc = [[BookListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
-(void)openLibary
{
    LibraryViewController *vc = [[LibraryViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}

-(void)openBusRoute
{
    SchoolBusLocatedViewController *vc = [[SchoolBusLocatedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

-(void)openMukeVC
{
    MukeViewController *vc = [[MukeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}
//失物招领
-(void)openLostFind
{
    FinfLosedViewController *vc = [[FinfLosedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.funcType = @"1";
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}
//兼职招聘
-(void)Parttimjob
{
    FinfLosedViewController *vc = [[FinfLosedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.funcType = @"3";
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
//二手市场
-(void)openMarket
{
    FinfLosedViewController *vc = [[FinfLosedViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.funcType = @"2";
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}

//重点工作监控
- (void)openImportWork{
    ImportWorkListViewController *vc = [[ImportWorkListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//信息发布
-(void)openMessageRelease:(UIButton *)sender{
    
    OfficialReleaseViewController *vc = [[OfficialReleaseViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"1";
    vc.title = sender.titleLabel.text?sender.titleLabel.text:@"信息发布";
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}
//公文发布
-(void)openOfficalRelease:(UIButton *)sender
{
    OfficialReleaseViewController *vc = [[OfficialReleaseViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.type = @"2";
    vc.title = sender.titleLabel.text?sender.titleLabel.text:@"公文发布";
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}
//办公指南
- (void)openBangongZhinan{
    BaseListSelectViewController *vc = [[BaseListSelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    vc.delegate = self;
    vc.commitDic = @{@"rid":@"getGuideInfo",@"type":@"1"};
    vc.navigationItem.title = @"办事指南";
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//规章制度
- (void)openGuizhangZhidu{
    BaseListSelectViewController *vc = [[BaseListSelectViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    vc.delegate = self;
    vc.commitDic = @{@"rid":@"getGuideInfo",@"type":@"2"};
    vc.navigationItem.title = @"规章制度";
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

- (void)selectVc:(UIViewController *)vc didSelectCellWithDic:(NSDictionary *)dic{
    NSDictionary *commitDic = @{@"rid":@"showGuideInfoById",@"uid":dic[@"RTID"]};
    AutoWebViewController *webVC = [[AutoWebViewController alloc] init];
    webVC.commitDic = commitDic;
    webVC.valueForKeyPath = @"data.SGCONTENT";
    webVC.navigationItem.title = dic[@"RTNAME"];
    [_indexVC.navigationController pushViewController:webVC animated:YES];
    
}

//每周会议WeekListViewController
- (void)openWeekMeeting:(NSString *)typeString{
    WeekListViewController *vc = [[WeekListViewController alloc] init];
    vc.typeString = typeString;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
//教工通讯录
-(void)openOfficeAddressBook
{
    //    EmployessPhoneNumViewController *vc = [[EmployessPhoneNumViewController alloc]init];
    EmployessContactBookViewController*vc = [[EmployessContactBookViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"教工通讯录";
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
}

- (void)openShuihua{
    ShuihuaqiangViewController *vc = [[ShuihuaqiangViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
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
        [_indexVC.navigationController pushViewController:vc animated:YES];
        
    }else{
        ClassPhoneNumViewController *vc = [[ClassPhoneNumViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"班班通";
        vc.navigationController.navigationBarHidden = YES;
        [_indexVC.navigationController pushViewController:vc animated:YES];
    }
}
//工资查询
-(void)openQuerySalary
{
    if ([AppUserIndex GetInstance].salaryUserName) {
        SalaryViewController *vc = [[SalaryViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [_indexVC.navigationController pushViewController:vc animated:YES];
        
    }else{
        SalaryrqueryLoginViewController *vc = [[SalaryrqueryLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [_indexVC.navigationController pushViewController:vc animated:YES];
    }
}

//打开云阅读
- (void)openRead{
    
    //    WebViewController *vc = [[WebViewController alloc] init];
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://m.yuedu.163.com/?_tdchannel=X8Joccry5&_tdcid=j3Oocekjr"]];//
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//漫画
- (void)openManhua{
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://manhua.163.com?utm_source=qingcai"]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//考拉
- (void)openKaola{
    
    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://m.kaola.com/"]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//打开预约报销
- (void)openFinance{
    FinanceIndexViewController *vc = [[FinanceIndexViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
//打开地图
- (void)openMap{
    SchoolMapRouteViewController *vc = [[SchoolMapRouteViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
//一卡通余额
-(void)oneCardVC
{
    OneCardViewController *vc = [[OneCardViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//讲座预告
-(void)openJZVC
{
    NewsViewController *vc = [[NewsViewController alloc]init];
    vc.title = @"讲座预告";
    vc.isNews = NO;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
-(void)openNews
{
    NewsViewController *vc = [[NewsViewController alloc]init];
    vc.title = @"新闻资讯";
    vc.isNews = YES;
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//办公电话
- (void)openPhoneBook{
    DepartmentListViewController *vc = [[DepartmentListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}
- (void)openSchoolBus{
    
    SchoolBusListViewController *vc = [[SchoolBusListViewController alloc] init];
    vc.type = @"2";
    vc.navigationItem.title = @"校车";
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    [_indexVC UMengEvent:@"schoolBus"];
    
}
//打开校历
- (void)openCalender{
    
    SchoolBusListViewController *vc = [[SchoolBusListViewController alloc] init];
    vc.type = @"1";
    //    RxWebViewController* vc = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:WEB_URL_HELP(@"SchoolCalander.html")]];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    vc.navigationItem.title = @"校历";
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

//打开考试查询界面
-(void)openExamViewC
{
    ExamPlanViewController *vc = [[ExamPlanViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    [_indexVC UMengEvent:@"examPlan"];
}
//打开套餐选择页面
- (void)payViewAction:(UIButton *)sender{
    
    if ([ConfigObject shareConfig].isPayShowPhone) {
        BasePhoneViewController *vc = [[BasePhoneViewController alloc] init];
        vc.phoneType = XGPayPhone;
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [_indexVC.navigationController pushViewController:vc animated:YES];
    }else{
        PaySelectViewController *vc = [[PaySelectViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBarHidden = YES;
        [_indexVC.navigationController pushViewController:vc animated:YES];
    }
}

//打开空教室界面
- (void)openFreeRoomVC{
    FreeBuildViewController *vc = [[FreeBuildViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tabBarController.hidesBottomBarWhenPushed = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    [_indexVC UMengEvent:@"emptyRoom"];
    
}
//打开课程表界面
-(void)openCourseVC
{
    CourseViewController *courseVC = [[CourseViewController alloc] init];
    courseVC.hidesBottomBarWhenPushed = YES;
    courseVC.tabBarController.hidesBottomBarWhenPushed = YES;
    [_indexVC.navigationController pushViewController:courseVC animated:YES];
    [_indexVC UMengEvent:@"timeTable"];
    
}

//打开成绩查询界面
- (void)openQueryScoreVC{
    
    QueryScoreViewController *vc = [[QueryScoreViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tabBarController.hidesBottomBarWhenPushed = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
    
    //    if ([[AppUserIndex GetInstance].role_type isEqualToString:@"1"]) {
    //        QueryScoreClassListViewController *vc = [[QueryScoreClassListViewController alloc] init];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        vc.tabBarController.hidesBottomBarWhenPushed = YES;
    //        [_indexVC.navigationController pushViewController:vc animated:YES];
    //    }else{
    //        QueryScoreViewController *vc = [[QueryScoreViewController alloc] init];
    //        vc.hidesBottomBarWhenPushed = YES;
    //        vc.tabBarController.hidesBottomBarWhenPushed = YES;
    //        [_indexVC.navigationController pushViewController:vc animated:YES];
    //    }
    
    [_indexVC UMengEvent:@"queryScore"];
    
}

- (void)callRepair{
    
    QuestionListViewController *vc = [[QuestionListViewController alloc] init];
    //    NewStudentInfoViewController *vc = [[NewStudentInfoViewController alloc] init];
    //    YunListViewController *vc = [[YunListViewController alloc] initWithPath:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

- (void)newStudentInfo:(UIButton *)sender{
    
    //    QuestionListViewController *vc = [[QuestionListViewController alloc] init];
    NewStudentInfoViewController *vc = [[NewStudentInfoViewController alloc] init];
    //    YunListViewController *vc = [[YunListViewController alloc] initWithPath:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    vc.title = sender.titleLabel.text?sender.titleLabel.text:@"分班信息";
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

- (void)openPhotoWall{
    PhotoWallIndexViewController *vc = [[PhotoWallIndexViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

- (void)openSignVC{
    
    SignViewController *vc = [[SignViewController alloc] init];
    //    PhotoWallIndexViewController *vc = [[PhotoWallIndexViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [_indexVC.navigationController pushViewController:vc animated:YES];
}

- (void)showBundPhone:(UIButton *)sender{
    if ([[AppUserIndex GetInstance].yanzhengPhoneArray count] == 0) {
        UserPhoneInputViewController *phoneVC = [[UserPhoneInputViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:phoneVC];
        [_indexVC presentViewController:navVC animated:YES completion:nil];
    }else if ([[AppUserIndex GetInstance].yanzhengPhoneArray count] == 1) {
        UserPhoneInput2ViewController *phoneVC = [[UserPhoneInput2ViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:phoneVC];
        [_indexVC presentViewController:navVC animated:YES completion:nil];
    }else if ([[AppUserIndex GetInstance].yanzhengPhoneArray count] == 2) {
        UserPhoneInput3ViewController *phoneVC = [[UserPhoneInput3ViewController alloc] init];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:phoneVC];
        [_indexVC presentViewController:navVC animated:YES completion:nil];
    }else if (([[AppUserIndex GetInstance].yanzhengPhoneArray count] == 3) && sender){
        [ProgressHUD showError:@"您已验证手机号码，无需再次验证。"];
    }
}
@end
