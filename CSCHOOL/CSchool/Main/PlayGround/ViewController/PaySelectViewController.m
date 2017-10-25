//
//  PaySelectViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/11.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "PaySelectViewController.h"
#import "UIView+SDAutoLayout.h"
#import "XJComboBoxView.h"
#import "PayDetailViewController.h"
#import "NetworkCore.h"
#import "BaseGMT.h"
#import "UIButton+BackgroundColor.h"
#import "NSDate+Extension.h"
#import "ProgressHUD.h"
#import <YYText.h>
#import "AboutUsViewController.h"
#import "XGAlertView.h"
#import "PayInfoView.h"
#import "PackageInfoViewController.h"
#import "ConfigObject.h"

#define MealInfoDic [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"0",@"0",@"1", nil]  //0对应1个月，1对应0个月
#define nameDic [NSDictionary dictionaryWithObjectsAndKeys:@"包月",@"0",@"包学期",@"1", nil]

@interface PaySelectViewController ()<XJComboBoxViewDelegate,XGAlertViewDelegate, UIScrollViewDelegate>
{
    YYLabel *_moneyLabel;
    UILabel *_bitLabel;
    UILabel *_timeLabel;
    UIButton *_agreeBtn;
    UIView *_selectBtnView;
    UILabel *_noticeLabel;
    UIButton *buyProtocol;
    UIButton *nextBtn;
    
    UIImageView *_noticeImageView;
    UILabel *_noticeImageLabel;
    
    PayInfoView *_payInfoView;
}
//@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, assign) NSInteger bitSelect; //选择第几个套餐

@property (nonatomic, strong) NSMutableDictionary *mealMutableDic;
@property (nonatomic, strong) NSMutableArray *mealBitMutbleArr;
@property (nonatomic, strong) NSString *keySelectStr; //带宽button选择的标题
@property (nonatomic, strong) NSString *finalStr; //选中文字提交给服务器字符串
@property (nonatomic, assign) NSTimeInterval nowTimer;

@property (nonatomic,assign)BOOL isShowTrip;//是否显示提示
@property (nonatomic,copy)NSString *trip;//提示文字
@property (nonatomic,assign)BOOL isPay;//是否能进行支付

@property (nonatomic, strong) NSDictionary *packageTemplateDic; //存放套餐对应的名称，用于取代宏nameDic
@property (nonatomic, strong) NSMutableDictionary *packageInfoDic; //存放所有套餐
@property (nonatomic, strong) NSString *firstShow; //默认选择选项
//存放优惠政策信息
@property (nonatomic, strong) NSDictionary *markInfoDic;
@end

@implementation PaySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"套餐选择";
    [self UMengEvent:@"pay_select"];
    [self loadYouhuiInfo];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
}
-(void)loadData{
    
    _mealMutableDic = [NSMutableDictionary dictionary];
    _mealBitMutbleArr = [NSMutableArray array];
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSString *token =user.token?user.token:@"1";
    NSString *rid = @"getAllUserPkgInfo";
    NSString *userName = user.accountId;
    NSDictionary *dic = @{
                          @"rid":rid,
                          @"token":token,
                          @"username":userName,
                          @"phone":[ConfigObject shareConfig].phoneNum
                          };
    [ProgressHUD show:@"正在获取套餐信息"];
    [NetworkCore requestPOST:user.API_URL parameters:dic success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",user.API_URL);
//        if (![[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
//            [ProgressHUD showError:@"暂时无法缴费。"];
//            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@YES afterDelay:1];
//            return ;
//        }
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        
        NSArray *resArr = [dataDic objectForKey:@"packages"];
//      NSArray *resArr = @[@"4M无线+6M有线|0|1|35",
//                          @"6M无线+10M有线|0|1|45",
//                          @"6M无线+10M有线|0|1|45",
//                          @"6M无线+10M有线|0|0|45",
//                          @"6M无线+10M有线|0|2|245",
//                          @"10M无线+20M有线|0|2|355"];
        _nowTimer = [[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"serverTime"]] doubleValue];
        
        
        if ([resArr count] == 0) {
            [ProgressHUD dismiss];
//            XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:[responseObject objectForKey:@"msg"] WithCancelButtonTitle:@"确定" withOtherButton:nil];
//            [alert show];
            
//            [self showErrorView:[responseObject objectForKey:@"msg"]];
            [self showErrorViewLoadAgain:[responseObject objectForKey:@"msg"]];

            return ;
        }
        NSMutableArray *keyArr = [NSMutableArray array];
        
        _packageInfoDic = [NSMutableDictionary dictionary];
        for (NSString *str in resArr) {
            NSArray *subArr = [str componentsSeparatedByString:@"|"];
            if ([subArr count] == 4) {
//                NSString *keyValue = @"";
//                if ([subArr[2] isEqualToString:@"0"]) {
//                    keyValue = @"包月";
//                }else{
//                    keyValue = @"包学期";
//                }
                if ([subArr[3] isEqualToString:@"0"]) {
                    continue;
                }
                if (!_finalStr) {
                    _finalStr = subArr[2];
                }
                [_mealMutableDic setObject:subArr[2] forKey:str];
                
                BOOL isFind = NO;
                for (NSString *keyStr in keyArr) {
                    if ([subArr[2] isEqualToString:keyStr]) {
                        isFind = YES;
                    }
                }
                if (!isFind) {
                    [keyArr addObject:subArr[2]];
                }
                
                
                //处理套餐内容
                NSMutableArray *dataArr;
                if ([[_packageInfoDic allKeys] containsObject:subArr[2]]) {
                    dataArr = _packageInfoDic[subArr[2]];
                }else{
                    dataArr = [NSMutableArray array];
                }
                [dataArr addObject:str];
                [_packageInfoDic setObject:dataArr forKey:subArr[2]];
                
                
            }
//            [_mealBitMutbleArr addObject:subArr[2]];
        }
        NSArray *tempArr = [_mealMutableDic allValues];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (NSString *key in tempArr) {
            [tempDic setObject:@"1" forKey:key];

        }
//        _mealBitMutbleArr = [self insertSortWithArray:[tempDic allKeys]];
        _mealBitMutbleArr = keyArr;//[self newSortWithArray:[tempDic allKeys]];
        [ProgressHUD dismiss];
        [self initSubViews];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
//        [self showErrorView:[error objectForKey:@"msg"]];
        [self showErrorViewLoadAgain:[error objectForKey:@"msg"]];
    }];
    
}

//获取学校优惠政策信息
- (void)loadYouhuiInfo{
    [ProgressHUD show:@""];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getMarketingBySchoolCode",@"phone":[AppUserIndex GetInstance].userInputPhonenum?[AppUserIndex GetInstance].userInputPhonenum:@""} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        _markInfoDic = responseObject;
        _packageTemplateDic = responseObject[@"packageTemplate"];
        _isShowTrip = [responseObject[@"mobileTrip"][@"isShowTrip"] boolValue];
        _trip       = [NSString stringWithFormat:@"%@", responseObject[@"mobileTrip"][@"trip"]];
        _isPay      = [responseObject[@"mobileTrip"][@"isPay"] boolValue];
        BOOL isDic =[responseObject[@"marketInfo"] isKindOfClass:[NSDictionary class]];
        
        if (isDic) {
                NSString *urlString = responseObject[@"marketInfo"][@"marketContent"];
                if(![urlString isEqualToString:@""] && ![urlString isEqual:[NSNull null]]) {
                    XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withWebViewContent:urlString];
                    alert.isBackClick = YES;
                    alert.delegate = self;
                    alert.tag = 1214;
                    [alert WebviewShow];
                }else{
                    [self showPhoneAlertView];
                }
        }else{
                [self showPhoneAlertView];
        }

//        [self loadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
//        [self loadData];  失败的时候是不是要走弹窗接口
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"遇到点意外，刷新试试" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        alert.tag = 1217;
        [alert show];
        
    }];
}
-(void)showPhoneAlertView
{
    if (_isShowTrip) {
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:_trip WithCancelButtonTitle:@"知道了" withOtherButton:nil];
        alert.delegate = self;
        alert.isBackClick = YES;
        alert.tag = 1215;
        [alert show];
    }else{
        if (_isPay) {
            [self loadData];
        }else{
            [ProgressHUD dismiss];
            [self showErrorView:@"缴费服务暂不可用" andImageName:nil];
        }
    }
}


//排序
-(NSMutableArray *)insertSortWithArray:(NSArray *)aData{
    NSMutableArray *data = [[NSMutableArray alloc]initWithArray:aData];
    for (int i = 1; i < [data count]; i++) {
        id tmp = [data objectAtIndex:i];
        int j = i-1;
        while (j != -1 && [data objectAtIndex:j] > tmp) {
            [data replaceObjectAtIndex:j+1 withObject:[data objectAtIndex:j]];
            j--;
        }
        [data replaceObjectAtIndex:j+1 withObject:tmp];
    }
//    NSLog(@"插入排序后的结果：%@",[data description]);
    return data;
}

- (NSMutableArray *)newSortWithArray:(NSArray *)aData{

    NSMutableArray *p = [[NSMutableArray alloc] initWithArray:aData];
    
    [p sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *a = (NSString *)obj1;
        NSString *b = (NSString *)obj2;
        
        int aNum = [[a stringByReplacingOccurrencesOfString:@"M" withString:@""] intValue];
        int bNum = [[b stringByReplacingOccurrencesOfString:@"M" withString:@""] intValue];
        
        if (aNum > bNum) {
            return NSOrderedDescending;
        }
        else if (aNum < bNum){
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    return p;
}

- (void)initSubViews{
    
    
    
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    _mainScrollView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);

    _payInfoView = ({
        PayInfoView *view = [[PayInfoView alloc] init];
//        view.hidden = YES;
        view.payInfoHiddenBlock = ^(){
            for (int i=0; i<[_mealMutableDic allValues].count; i++) {
                UIButton *btn = [[UIButton alloc] init];
                btn = (UIButton *)[_selectBtnView viewWithTag:2000+i];
                btn.selected = NO;
                [btn setBackgroundColor:Base_Color2];
            }
        };
        view;
    });

    [self.view addSubview:_payInfoView];
    _payInfoView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,0)
    .heightIs(kScreenHeight-64);
    
    _payInfoView.hidden = YES;

    
    UILabel *bitSelectLabel = [[UILabel alloc] init];
    bitSelectLabel.font = Title_Font;
    bitSelectLabel.text = @"时长选择:";
    
    UILabel *timeSelectLabel = [[UILabel alloc] init];
    timeSelectLabel.font = Title_Font;
    timeSelectLabel.text = @"套餐选择:";
    
    _noticeImageView = [[UIImageView alloc] init];
    UIImage* img=[UIImage imageNamed:@"bac123.png"];//原图
    UIEdgeInsets edge=UIEdgeInsetsMake(25, 25, 25,25);
    //UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
    //UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图
    img= [img resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    _noticeImageView.image=img;
    
    _noticeImageLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = RGB(255, 0, 0);
        view;
    });
    
    [_noticeImageView addSubview:_noticeImageLabel];
    
    UILabel *monTitleLabel = [[UILabel alloc] init];
    monTitleLabel.font = Title_Font;
    monTitleLabel.text = @"金额:";
    
    UILabel *bitTitleLabel = [[UILabel alloc] init];
    bitTitleLabel.font = Title_Font;
    bitTitleLabel.text = @"带宽:";
    
    UILabel *timTitleLabel = [[UILabel alloc] init];
    timTitleLabel.font = Title_Font;
    timTitleLabel.text = @"时长:";
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:Base_Orange];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAtion:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.userInteractionEnabled = YES;
    if (_mealBitMutbleArr.count < 1) {
        nextBtn.userInteractionEnabled = NO;
    }
    
    buyProtocol = [UIButton buttonWithType:UIButtonTypeSystem];
    [buyProtocol setTitle:@"《购买协议》" forState:UIControlStateNormal];
    [buyProtocol setTitleColor:Title_Color1 forState:UIControlStateNormal];
    [buyProtocol addTarget:self action:@selector(showProtocol:) forControlEvents:UIControlEventTouchUpInside];
    buyProtocol.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    [_mainScrollView addSubview:bitTitleLabel];
    [_mainScrollView addSubview:timTitleLabel];
//    [_mainScrollView addSubview:monTitleLabel];
    [_mainScrollView addSubview:bitSelectLabel];
    [_mainScrollView addSubview:timeSelectLabel];
    [_mainScrollView addSubview:nextBtn];
    [_mainScrollView addSubview:buyProtocol];
    [_mainScrollView addSubview:_noticeImageView];
    
    _moneyLabel = ({
        YYLabel *view = [YYLabel new];
        view.font = [UIFont systemFontOfSize:18];
        view.textColor = Base_Orange;
        view;
    });
    
    _bitLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.text = @"4M";
        view;
    });
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view;
    });
    
    _agreeBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"我已阅读并了解" forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"cs_select_no2"] forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"cs_select_yes1"] forState:UIControlStateSelected];
        view.selected = YES;
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        [view setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _selectBtnView = ({
        UIView *view = [UIView new];
        view;
    });
    
    _noticeLabel = ({
        UILabel *view = [UILabel new];
        view.textColor = [UIColor redColor];
        [view setFont:[UIFont systemFontOfSize:12]];
        view.text = @"温馨提示:由于技术本身的特点,凡办理高带宽套餐的同学请确认自己的终端可支持连接5.8G信道。";
        view.numberOfLines = 0;
        view;
    });
    
    [_mainScrollView addSubview:_moneyLabel];
    [_mainScrollView addSubview:_bitLabel];
    [_mainScrollView addSubview:_timeLabel];
    [_mainScrollView addSubview:_agreeBtn];
    [_mainScrollView addSubview:_selectBtnView];
    [_mainScrollView addSubview:_noticeLabel];
    
    bitSelectLabel.sd_layout
    .leftSpaceToView(_mainScrollView,10)
    .topSpaceToView(_mainScrollView,20)
    .heightIs(30)
    .widthIs(150);
    
    CGFloat bSpace = 15;
    NSInteger bCount = _mealBitMutbleArr.count;
    CGFloat bWith = (kScreenWidth-(bCount+1)*bSpace)/bCount;
    
    CGFloat bHeight = 38;
    UIButton *lastBtn = nil;
    int btnTag = 0;
    UIButton *firstBtn = nil;
    UIButton *selBtn = nil;
    for (NSString *value in _mealBitMutbleArr) {
        UIButton *bitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [bitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [bitBtn setTitle:nameDic[value] forState:UIControlStateNormal];
        [bitBtn setTitle:_packageTemplateDic[[NSString stringWithFormat:@"b%@",value]][@"name"] forState:UIControlStateNormal];
        bitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [bitBtn setBackgroundColor:Base_Color2];
        bitBtn.tag = 1000+[value integerValue];
        [bitBtn addTarget:self action:@selector(bitSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_mainScrollView addSubview:bitBtn];
        if (!lastBtn) {
            bitBtn.selected = YES;
            [bitBtn setBackgroundColor:Base_Orange];
            bitBtn.sd_layout
            .leftSpaceToView(_mainScrollView,bSpace)
            .topSpaceToView(bitSelectLabel,10)
            .widthIs(bWith)
            .heightIs(bHeight);
            firstBtn = bitBtn;
        }else{
            bitBtn.sd_layout
            .leftSpaceToView(lastBtn,bSpace)
            .topEqualToView(lastBtn)
            .widthRatioToView(lastBtn,1)
            .heightRatioToView(lastBtn,1);
        }
        lastBtn = bitBtn;
        if ([value isEqualToString:_finalStr]) {
            selBtn = bitBtn;
        }
        btnTag++;
    }
    
    
    _noticeImageView.sd_layout
    .leftSpaceToView(_mainScrollView,bSpace)
    .topSpaceToView(lastBtn,10)
    .rightSpaceToView(_mainScrollView,bSpace);
    _noticeImageView.hidden = YES;
    _noticeImageLabel.sd_layout
    .leftSpaceToView(_noticeImageView,10)
    .rightSpaceToView(_noticeImageView,10)
    .topSpaceToView(_noticeImageView,10)
    .autoHeightRatio(0);
    [_noticeImageView setupAutoHeightWithBottomView:_noticeImageLabel bottomMargin:10];
    
    timeSelectLabel.sd_layout
    .leftEqualToView(bitSelectLabel)
    .topSpaceToView(_noticeImageView,10)
    .widthRatioToView(bitSelectLabel,1)
    .heightRatioToView(bitSelectLabel,1);
    
    _selectBtnView.sd_layout
    .leftSpaceToView(_mainScrollView,0)
    .rightSpaceToView(_mainScrollView,0)
    .topSpaceToView(timeSelectLabel,10);
    
    monTitleLabel.sd_layout
    .leftEqualToView(bitSelectLabel)
    .topSpaceToView(_selectBtnView,40)
    .widthIs(40)
    .heightIs(25);
    
    _moneyLabel.sd_layout
    .leftSpaceToView(monTitleLabel,5)
    .topEqualToView(monTitleLabel)
    .heightRatioToView(monTitleLabel,1)
    .rightSpaceToView(_mainScrollView,10);
    
    
    [_mainScrollView setupAutoContentSizeWithBottomView:_selectBtnView bottomMargin:20];

    if (!selBtn) {
        selBtn = firstBtn;
    }
    if (selBtn) {
        [self bitSelectAction:selBtn];
    }
    
}

//组名称（包月、包学期）
- (void)bitSelectAction:(UIButton *)sender{
//    for (int i=0; i<[_mealMutableDic allValues].count; i++) {
//        UIButton *btn = [[UIButton alloc] init];
//        btn = (UIButton *)[_mainScrollView viewWithTag:1000+i];
//        btn.selected = NO;
//        [btn setBackgroundColor:Base_Color2];
//    }
    
    for (NSString *values in [_mealMutableDic allValues]) {
        UIButton *btn = [[UIButton alloc] init];
        btn = (UIButton *)[_mainScrollView viewWithTag:1000+[values integerValue]];
        btn.selected = NO;
        [btn setBackgroundColor:Base_Color2];
    }
    
    sender.selected = YES;
    [sender setBackgroundColor:Base_Orange];
    
    //设置优惠提示文本
    _noticeImageLabel.text = @"";
    
    if (!sender.titleLabel.text) {
        //出现了一次不知缘由的闪退，是text为nil，这里进行一些判定防闪退。
        return;
    }
    
    NSString *keyTrip = _packageTemplateDic[[NSString stringWithFormat:@"b%ld",sender.tag-1000]][@"trip"];
    
    if ([_markInfoDic[keyTrip] isKindOfClass:[NSDictionary class]] &&![[_markInfoDic valueForKeyPath:[NSString stringWithFormat:@"%@.tripContent",keyTrip]] isEqual:[NSNull null]]) {
        _noticeImageLabel.text = [_markInfoDic valueForKeyPath:[NSString stringWithFormat:@"%@.tripContent",keyTrip]];
    }
    
    
    //验证不是字典、nsnull等问题
//    if ([[nameDic allKeysForObject:sender.titleLabel.text][0] isEqualToString:@"0"] && [_markInfoDic[@"b1tripInfo"] isKindOfClass:[NSDictionary class]] &&![[_markInfoDic valueForKeyPath:@"b1tripInfo.tripContent"] isEqual:[NSNull null]]) {
//        _noticeImageLabel.text = [_markInfoDic valueForKeyPath:@"b1tripInfo.tripContent"];
//    }else if([_markInfoDic[@"bttripInfo"] isKindOfClass:[NSDictionary class]] && ![[_markInfoDic valueForKeyPath:@"bttripInfo.tripContent"] isEqual:[NSNull null]]){
//        _noticeImageLabel.text = [_markInfoDic valueForKeyPath:@"bttripInfo.tripContent"];
//    }
    if ([_noticeImageLabel.text length]>1 || [_noticeImageLabel.text isEqualToString:@"null"] || [_noticeImageLabel.text isEqualToString:@"<null>"] ||([_noticeImageLabel.text isEqual: [NSNull null]])) {
        _noticeImageView.hidden = NO;
    }else{
        _noticeImageView.hidden = YES;
    }
    
    
//        [self getMealTrip:[nameDic allKeysForObject:sender.titleLabel.text][0]];
//    NSArray *keyArr = [_mealMutableDic allKeysForObject:[nameDic allKeysForObject:sender.titleLabel.text][0]];
    
    NSArray *keyArr = [_packageInfoDic objectForKey:[NSString stringWithFormat:@"%ld",sender.tag-1000]];
    
    for (UIView *view in _selectBtnView.subviews) {
        [view removeFromSuperview];
    }
    
    UIButton *lastBtn = nil;
    UIButton *firstBtn = nil;
    int i=0;
    for (NSString *key in keyArr) {
//    for (int i=0; i<8; i++) {
        
//        NSString *key = @"11212";
        NSArray *keyArr = [key componentsSeparatedByString:@"|"];
        
        CGFloat bSpace = 15;

        CGFloat bHeight = 38;
        
        UIButton *bitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [bitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bitBtn setTitle:[NSString stringWithFormat:@"%@",keyArr[0]] forState:UIControlStateNormal];
        bitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        bitBtn.tag = 2000+i;
        [bitBtn setBackgroundColor:Base_Color2 forState:UIControlStateNormal];
        [bitBtn setBackgroundColor:Base_Orange forState:UIControlStateSelected];
//        bitBtn.frame = CGRectMake(bSpace+(i%2)*(bWith+bSpace), i/2*(bHeight+10), bWith, bHeight);
        bitBtn.descripInfo = key;
        bitBtn.frame = CGRectMake(15, bSpace*i+i*bHeight, kScreenWidth-30, bHeight);
        
        [bitBtn addTarget:self action:@selector(btnViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtnView addSubview:bitBtn];
        
        if ([keyArr[1] isEqualToString:@"1"]) {
            UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_hui"]];
            [bitBtn addSubview:logoImageView];
            logoImageView.sd_layout
            .topSpaceToView(bitBtn,0)
            .rightSpaceToView(bitBtn,0)
            .widthIs(36)
            .heightIs(38);
        }
        
        if (i==0) {
//            bitBtn.selected = YES;
            firstBtn = bitBtn;
        }
        i++;
        lastBtn = bitBtn;
    }
    
    _selectBtnView.sd_layout.heightIs(lastBtn.bottom+10);
    
    NSArray *selArr = [keyArr[0] componentsSeparatedByString:@"|"];
    //选择套餐
    _keySelectStr = sender.titleLabel.text;
//    _bitSelect = sender.tag-1000;
    _bitLabel.text = sender.titleLabel.text;
//    _moneyLabel.text = [NSString stringWithFormat:@"%@元",selArr[3]];
    [self setMoneyText:selArr[3]];
    if (firstBtn) {
//        [self btnViewAction:firstBtn];
    }
}

//点击套餐选择事件
- (void)btnViewAction:(UIButton *)sender{
    for (int i=0; i<[_mealMutableDic allValues].count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn = (UIButton *)[_selectBtnView viewWithTag:2000+i];
        btn.selected = NO;
        [btn setBackgroundColor:Base_Color2];
    }
//    sender.selected = YES;
//    [sender setBackgroundColor:Base_Orange];
    
    //显示套餐详情弹出页
//    _payInfoView.hidden = NO;
    
    NSString *valueStr = sender.descripInfo;//[[_mealMutableDic allKeysForObject:[nameDic allKeysForObject:_keySelectStr][0]] objectAtIndex:sender.tag-2000];
    NSArray *keyArr = [valueStr componentsSeparatedByString:@"|"];
//    _moneyLabel.text = [NSString stringWithFormat:@"%@元",keyArr[3]];
//    [self setMoneyText:keyArr[3]];
    _finalStr = valueStr;
    [self getTime:keyArr[2]];
    
    NSLog(@"%@",_finalStr);
    
    PackageInfoViewController *vc = [[PackageInfoViewController alloc] init];
    vc.orderStr = _finalStr;
    vc.timeStr = _timeLabel.text;
    NSLog(@"%@-%@",_finalStr, _timeLabel.text);
    [self.navigationController pushViewController:vc animated:YES];
}

//计算时长
- (void)getTime:(NSString *)monthNum{
    
    if ([monthNum isEqualToString:@"0"]) {
        AppUserIndex *appUser = [AppUserIndex GetInstance];
        NSString *timeStr = [appUser.nextBillingTime substringToIndex:10];
        NSDate *nextDate= [NSDate dateWithString:timeStr format:@"yyyy.MM.dd"];
        NSTimeInterval time1970 = [nextDate timeIntervalSince1970];
        
        NSDate *staDate = nil;
        if (_nowTimer - time1970>0) {
            staDate = [NSDate dateWithTimeIntervalSince1970:_nowTimer];
        }else{
            staDate = nextDate;
        }
        
        NSDate *endDate = nil;
        NSUInteger month = [staDate month];
//        if ([monthNum isEqualToString:@"0"]) {
//            _timeLabel.text = @"本学期";
//            return;
//        }else{
        endDate = [[NSDate offsetMonths:1 fromDate:staDate] dateAfterDay:-1];
//        }
        
        NSString *endStr = [NSDate stringWithDate:endDate format:@"yyyy.MM.dd"];//+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
        NSString *staStr = [NSDate stringWithDate:staDate format:@"yyyy.MM.dd"];
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@",staStr,endStr];
    }else{
        _timeLabel.text = _packageTemplateDic[[NSString stringWithFormat:@"b%@",monthNum]][@"name"];
    }

}

- (void)setMoneyText:(NSString *)price{

    YYTextBorder *border = [YYTextBorder borderWithFillColor:Base_Orange cornerRadius:3];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor whiteColor]];
    [highlight setBackgroundBorder:border];
    [highlight setFont:[UIFont systemFontOfSize:15]];
    // 2. 把"高亮"属性设置到某个文本范围
    
    NSRange range = [[NSString stringWithFormat:@"%@元",price] rangeOfString:price];
    
    // 1. Create an attributed string.
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元",price]];
    [text yy_setTextHighlight:highlight range:range];
    
    // 2. Set attributes to text, you can use almost all CoreText attributes.
    text.yy_color = [UIColor blackColor];
    [text yy_setColor:Base_Orange range:range];
    [text yy_setFont:[UIFont systemFontOfSize:18] range:range];
    text.yy_lineSpacing = 10;
    // 3. Set to YYLabel or YYTextView.
    _moneyLabel.attributedText = text;
//    _moneyLabel.font = Title_Font;
}

- (void)agreeAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        nextBtn.userInteractionEnabled = YES;
        nextBtn.backgroundColor = Base_Orange;
    }else{
        nextBtn.userInteractionEnabled = NO;
        nextBtn.backgroundColor = Base_Color3;
    }
}

-(void)comboBoxView:(XJComboBoxView *)comboBoxView didSelectRowAtValueMember:(NSString *)valueMember displayMember:(NSString *)displayMember{
//    NSLog(@"valueMember = %@, displayMember=%@", valueMember, displayMember);
}


- (void)nextAtion:(UIButton *)sender{
//    NSLog(@"%@",_finalStr);
//    PayDetailViewController *vc = [[PayDetailViewController alloc] init];
//    vc.orderStr = _finalStr;
//    vc.timeStr = _timeLabel.text;
//    vc.priceStr = _moneyLabel.text;
//    vc.bitStr = _bitLabel.text;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (void)showProtocol:(UIButton *)sender{
    AboutUsViewController *about = [[AboutUsViewController alloc]init];
    
    about.title = @"购买协议";
    about.baseUrl = WEB_URL_HELP(@"Buy.html");
    about.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:about animated:YES];
}
#pragma XGAlertViewDelegate
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    if (view.tag == 1215) {
        if (_isPay) {
            [self loadData];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else if (view.tag==1217){
    
        [self loadYouhuiInfo];
    }
  
}
-(void)alertViewDidClickNoticeImageView:(XGAlertView *)view
{
    if (view.tag == 1214) {
        [self  showPhoneAlertView];
    }else if (view.tag == 1215){
        [self.navigationController popViewControllerAnimated:YES];
    }
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
