//
//  OrderTimeViewController.m
//  CSchool
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OrderTimeViewController.h"
#import "UIView+SDAutoLayout.h"
#import "OrdeiTimeTableViewCell.h"
#import "OrderTimeChooseTableViewCell.h"
#import "ChooseTypeViewController.h"
#import "NSDate+Extension.h"
#import "UITextField+IndexPath.h"
#import "FinanceIndexViewController.h"
#import "XGAlertView.h"
#import "FinancePhoneNumTableViewCell.h"
#import "NewChooseTimeViewController.h"
#import <EventKit/EventKit.h>
#import "CheckTelePhoneNum.h"
@interface OrderTimeViewController ()<UITableViewDelegate,UITableViewDataSource,XGAlertViewDelegate,TimeChooseDelegate>
{
    //switch的开关状态
    BOOL  isOpened;
    //存放时间的数组  2016年4月3日星期四,8:00
    NSMutableArray *timeArr;
    NSString *T_WIDName;//窗口名称
    NSString *_RIID ;//预约号
    NSString *_RIHANDLEZGH;//实际报账人
    NSString *_RIHANDLEPHONE ;//实际报账人电话
    NSString *_RISTARTTIME;//预约开始时间
    NSString *_RIENDTIME;//预约结束时间
    
    UITextField *_textField;

}
@property (nonatomic,strong)UITableView *tableView;
//确认预约按钮
@property (nonatomic,strong)UIButton *orderBtn;
//存放选中的列表行数
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic ,strong)NSMutableArray  *indexPathArr;
//保存代办人的信息
@property (nonatomic ,strong)NSMutableArray *arrayDataSouce;


@end

@implementation OrderTimeViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    //开启通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    _indexPathArr = [NSMutableArray array];
    [self createView];
    [self loadData];
}
#pragma mark 加载数据
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    timeArr = [NSMutableArray array];
    NSMutableArray *data = [NSMutableArray array];
    AppUserIndex *user = [AppUserIndex GetInstance];

    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"saveAccount",@"userid":user.accountId,@"totaltime":_totaltime,@"standardInfo":_standardInfo} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            [data addObject:dic];
        }
        NSDictionary *Dic = [data objectAtIndex:0];
        NSString *day = [self timeStr:[Dic[@"RISTARTTIME"]longValue] isDay:YES];
        NSString *hour = [self timeStr:[Dic[@"RISTARTTIME"]longValue] isDay:NO];
        [timeArr addObject:day];
        [timeArr addObject:hour];
        
        NSString *T_WIID = [NSString stringWithFormat:@"%ld",[Dic[@"WIID"] longValue]];
        T_WIDName = [NSString stringWithFormat:@"%@号窗口",T_WIID];
        //预约号
        _RIID  = [NSString stringWithFormat:@"%@",Dic[@"RIID"]];
        //实际预约人
        _RIHANDLEZGH = [NSString stringWithFormat:@"%@",Dic[@"RIHANDLEZGH"]];
        _RIHANDLEPHONE  = [NSString stringWithFormat:@"%@",Dic[@"RIHANDLEPHONE"]];
        //预约开始时间
        _RISTARTTIME = [NSString stringWithFormat:@"%@",Dic[@"RISTARTTIME"]];
        _RIENDTIME = [NSString stringWithFormat:@"%@",Dic[@"RIENDTIME"]];
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
    
}
#pragma mark  初始化视图
-(void)createView{
    self.view.backgroundColor = Base_Color2;
    self.navigationItem.title = @"预约时间";
    UIView *bottomView =({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    UIView *backView= ({
        UIView *view = [UIView new];
        view.backgroundColor = Base_Color2;
        view;
    });
    self.tableView = ({
        UITableView *view = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        view.separatorStyle = UITableViewCellSelectionStyleNone;
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        view.delegate = self;
        view.dataSource = self;
        view;
    });
    self.orderBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.layer.cornerRadius = 5;
        view.backgroundColor = Base_Orange;
        [view setTitle:@"确定预约" forState:UIControlStateNormal];
        [view addTarget:self action:@selector(orderAction:) forControlEvents:UIControlEventTouchUpInside];
        view.titleLabel.textColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = backView;
    self.tableView.tableFooterView = bottomView;
    [bottomView addSubview:self.orderBtn];
    backView.sd_layout.leftSpaceToView(self.tableView,0).rightSpaceToView(self.tableView,0).topSpaceToView(self.tableView,0).heightIs(10);
    self.tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    bottomView.sd_layout.leftSpaceToView(self.tableView,0).leftSpaceToView(self.view,0).heightIs(85);
    self.orderBtn.sd_layout.leftSpaceToView(bottomView,18).rightSpaceToView(bottomView ,18).heightIs(37).bottomSpaceToView(bottomView,25);
}
#pragma  mark 私有方法
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  开关
 *
 *  @param sender switch按钮
 */
-(void)openReplaceCell:(UISwitch *)sender
{
    BOOL isOpen = [sender isOn];
    if (isOpen) {
        isOpened = YES;
        _selectedIndexPath = _indexPathArr[2];
    }else{
        isOpened = NO;
        _selectedIndexPath = nil;
    }
    [self.tableView reloadRowsAtIndexPaths:@[_indexPathArr[2]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[_indexPathArr[1]] withRowAnimation:UITableViewRowAnimationFade];
}
/*@"选择时间"*/
-(void)chooseTimeBtn:(UIButton *)sender
{
    NewChooseTimeViewController  *vc = [[NewChooseTimeViewController alloc]init];
    vc.delegate = self;
    vc.title = @"选择预约时间";
    vc.bookid = _RIID;
    vc.totaltime = _totaltime;

    [self.navigationController pushViewController:vc animated:YES];
//    ChooseTypeViewController *vc = [[ChooseTypeViewController alloc]init];
//    vc.ChooseDelegate = self;
//    vc.chooseType =TimeType;
//    vc.title = @"选择预约时间";
//    vc.bookid = _RIID;
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}
//转化时间字符串
-(NSString *)timeStr:(long )date isDay:(BOOL)day
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *strDate;
    if(day){
        strDate = [NSDate formatYMD:confromTimesp];
        NSString *weekDay =  [NSDate dayFromWeekday:confromTimesp];
        strDate = [NSString stringWithFormat:@"%@ %@",strDate,weekDay];
    }else{
        [dateFormatter setDateFormat:@"HH:mm"];
        strDate = [dateFormatter stringFromDate:confromTimesp];
    }
    
    return strDate;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**
 *  保存数据的方法；

 *
 *  @param void 通知的方式
 *
 *  @return 。
 */

- (void)textFieldDidChanged:(NSNotification *)noti{
    _textField=noti.object;
    [self.arrayDataSouce replaceObjectAtIndex:_textField.tag withObject:_textField.text];
}
//保存代办人的信息的数组
- (NSMutableArray *)arrayDataSouce{
    if (!_arrayDataSouce) {
        _arrayDataSouce = [NSMutableArray array];
        [_arrayDataSouce addObject:@""];
        [_arrayDataSouce addObject:@""];
    }
    return _arrayDataSouce;
}

-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"" " ~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
/**
 *  确认预约
 *
 *  @param sender 。。
 */
-(void)orderAction:(UIButton *)sender
{
    NSDictionary *param;
    AppUserIndex *user = [AppUserIndex GetInstance];
    [_textField resignFirstResponder];
    if (isOpened) {
        //判读代办联系人信息是否完整
        _RIHANDLEZGH = self.arrayDataSouce[0];//代办人姓名
        _RIHANDLEPHONE = self.arrayDataSouce[1];//代办人电话
        
        if ([self isIncludeSpecialCharact:_RIHANDLEZGH]) {
            [ProgressHUD showError:@"名字中不允许含有特殊字符！"];
            return;
        }
        if ([_RIHANDLEZGH isEqualToString:@""]||[_RIHANDLEPHONE isEqualToString:@""]) {
            [ProgressHUD showError:@"请检测代办人信息是否完整"];
            return;
        }
//        if (_RIHANDLEPHONE.length!=11) {
//            [ProgressHUD showError:@"手机号不合法"];
//            return;
//        }
        if ([self isMobileNumber:_RIHANDLEPHONE]) {
            param = @{@"rid":@"updBookInfoWithAccountAndtime",@"bookid":_RIID,@"starttime":_RISTARTTIME,@"senseOptusr":_RIHANDLEZGH,@"senseOptphone":_RIHANDLEPHONE};
 
        }else{
            [ProgressHUD showError:@"手机号不合法"];
            return;
        }
    }else{
            _RIHANDLEPHONE = self.arrayDataSouce[0];//代办人电话
//        if (_RIHANDLEPHONE.length!=11) {
//            [ProgressHUD showError:@"手机号不合法"];
//            return;
//        }
        if ([self isMobileNumber:_RIHANDLEPHONE]) {
            param = @{@"rid":@"updBookInfoWithAccountAndtime",@"bookid":_RIID,@"starttime":_RISTARTTIME,@"senseOptusr":_RIHANDLEZGH,@"senseOptphone":_RIHANDLEPHONE};
            
        }else{
            [ProgressHUD showError:@"手机号不合法"];
            return;
        }
    }
    [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"预约成功" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        alert.delegate = self;
        alert.isBackClick = YES;
        alert.tag= 1000;
        [alert show];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];

}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,152,155,156,170,171,176,185,186
     * 电信号段: 133,134,153,170,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,170,171,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|7[016]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,170,177,180,181,189
     */
    NSString *CT = @"^1(3[34]|53|7[07]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//#pragma mark  选择报销类型界面代理方法
//-(void)pushOrPopMethod:(UIViewController *)vc withDataDictionary:(NSDictionary *)dic
//{
//    timeArr = [NSMutableArray array];
//    [self.navigationController popViewControllerAnimated:vc];
//    _RISTARTTIME = dic[@"S_TIME"];
//    NSString *day = [self timeStr:[dic[@"S_TIME"]longValue] isDay:YES];
//    NSString *hour = [self timeStr:[dic[@"S_TIME"]longValue] isDay:NO];
//    [timeArr addObject:day];
//    [timeArr addObject:hour];
//    NSString *T_WIID = [NSString stringWithFormat:@"%ld",[dic[@"T_WIID"] longValue]];
//    T_WIDName = [NSString stringWithFormat:@"%@号窗口",T_WIID];
//    [self.tableView reloadRowsAtIndexPaths:@[_indexPathArr[0],_indexPathArr[1]] withRowAnimation:UITableViewRowAnimationNone];
//}
#pragma mark  选择报销类型界面代理方法
-(void)pushOrPopMethod:(UIViewController *)vc withStartTime:(NSDictionary *)TimeDic
{
    timeArr = [NSMutableArray array];
    [self.navigationController popViewControllerAnimated:vc];
    _RISTARTTIME =TimeDic[@"S_TIME"];
    _RIENDTIME   = TimeDic[@"E_TIME"];
    NSString *day = [self timeStr:[_RISTARTTIME longLongValue] isDay:YES];
    NSString *hour = [self timeStr:[_RISTARTTIME longLongValue] isDay:NO];
    [timeArr addObject:day];
    [timeArr addObject:hour];
    [self.tableView reloadRowsAtIndexPaths:@[_indexPathArr[0],_indexPathArr[1]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma  mark  tableViewDataspource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *cellIdentifier = @"chooseTimeCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([OrderTimeChooseTableViewCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            nibsRegistered = YES;
        }
        OrderTimeChooseTableViewCell *cell = (OrderTimeChooseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.firsTime.textColor = Base_Orange;
        cell.secTime.textColor = Base_Orange;
        cell.chooseTimeBtn.tintColor = Base_Orange;
        if (timeArr.count>0) {
            cell.secTime.text = timeArr[0];
            cell.firsTime.text = timeArr[1];
            }
        [cell.chooseTimeBtn addTarget:self action:@selector(chooseTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_indexPathArr addObject:indexPath];
        return cell;
    }else if (indexPath.row==1) {
//        static NSString *cellId = @"orderTimeCell";
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
//        if (!cell ) {
//            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        }
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsZero];
//        }
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//            [cell setSeparatorInset:UIEdgeInsetsZero];
//        }
////        cell.hidden = YES;
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.textLabel.text  = @"预约窗口:";
//        cell.textLabel.font = [UIFont systemFontOfSize:16];
//        cell.detailTextLabel.text = T_WIDName;
//        cell.detailTextLabel.textColor = Color_Black ;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [_indexPathArr addObject:indexPath];
        static NSString *phoneNumCellId = @"phoneNumCellId";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([FinancePhoneNumTableViewCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:phoneNumCellId];
            nibsRegistered = YES;
        }
        FinancePhoneNumTableViewCell *cell = (FinancePhoneNumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:phoneNumCellId];
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:phoneNumCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (isOpened) {
            cell.hidden=YES;
        }
        [_indexPathArr addObject:indexPath];
        return cell;
    }else if (indexPath.row==2) {
        static NSString *cellNum = @"openCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([OrdeiTimeTableViewCell class]) bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellNum];
            nibsRegistered = YES;
        }
        OrdeiTimeTableViewCell *cell = (OrdeiTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellNum];
        [_indexPathArr addObject:indexPath];
        [cell.replaceSwitch addTarget:self action:@selector(openReplaceCell:) forControlEvents:UIControlEventValueChanged];
        [cell.replaceSwitch setOn:isOpened];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return  0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 90;
            break;
        case 1:
            if (isOpened) {
                return 0;
            }
            return 50;
            break;
        case 2:
        {
            if (_selectedIndexPath && _selectedIndexPath.row == indexPath.row) {
                return 157;
            } else {
                return 55;
            }

        }
            break;
        
        default:
            break;
    }
    return YES;

}
#pragma mark 弹窗代理方法
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    switch (view.tag) {
        case 1000:
        {
            
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"是否将预约添加到日历提醒?" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            
            alert.delegate = self;
            alert.isBackClick = YES;
            alert.tag= 1001;
            [alert show];
        }
            break;
        case 1001:
        {
            [self calenderEvents];
        }
            break;
        case 1002:{
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([[vc class] isEqual:[FinanceIndexViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
            break;
        default:
            break;
    }

}
//取消按钮代理事件
- (void)alertView:(XGAlertView *)view didClickCancel:(NSString *)title
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([[vc class] isEqual:[FinanceIndexViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
}

#pragma mark 添加闹钟代理事件
//日历事件
-(void)calenderEvents
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //6.0及以上通过下面方式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误信息
                    // display error message here
                }
                else if (!granted)
                {
                    //被用户拒绝，不允许访问日历
                    [ProgressHUD show:@"用户拒绝访问日历"];
                }
                else
                {
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    NSDate *sDate = [NSDate dateWithTimeIntervalSince1970:[_RISTARTTIME  intValue]];
                    NSDate *eDate = [NSDate dateWithTimeIntervalSince1970:[_RIENDTIME intValue]];
                    event.startDate = sDate;
                    event.endDate   = eDate;
                    sDate = [self changeDate:sDate];
                    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
                    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                    NSString *dateString = [dateFormat stringFromDate:sDate];
                    event.title =[NSString stringWithFormat:@"您有预约报销事件，预约处理的时间是%@-%@,预约号是%@,请您提前准备好所需单据，不要迟到哦。",dateString,[NSDate dayFromWeekday:sDate],_RIID];
                    event.location =user.schoolName;
                    event.notes = _RIID;
                    //添加提醒  半小时--一小时进行提醒。
                    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:60.0f * -60.0f];
                    EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:60.0f*-30.0f];
                    
                    [event addAlarm:alarm];
                    [event addAlarm:alarm2];
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                }
            });
        }];
    }
    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"添加成功,您可以去系统日历查看您的预约事件相关信息" WithCancelButtonTitle:@"确定" withOtherButton:nil];
    alert.delegate = self;
    alert.isBackClick = YES;
    alert.tag= 1002;
    [alert show];
}
//转化为本地时间
-(NSDate *)changeDate:(NSDate *)originDate
{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:originDate];
    
    NSDate *localeDate = [originDate  dateByAddingTimeInterval: interval];
    return localeDate;
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
