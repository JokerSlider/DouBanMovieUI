//
//  NewChooseTimeViewController.m
//  CSchool
//
//  Created by mac on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "NewChooseTimeViewController.h"
#import "UIView+SDAutoLayout.h"
#import "LFUIbutton.h"
#import "TimeCollectionViewCell.h"
#import "NSDate+Extension.h"
#import "TePopList.h"
#import <EventKit/EventKit.h>

@interface NewChooseTimeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XGAlertViewDelegate>
{
    UIView *backView;
    NSArray *titleArr;
    NSArray *imageArr;
    UIView *bootomView;
    UILabel *noticeLabel;//您已经选择了9月1号星期一8:00-8:50作为您的报销时间;
//    UIButton *chooseToNoticeBtn;//闹钟提醒
    //日期数据
    NSMutableArray *_data;
    NSString *dayChoose;//选择的日期2016-9-12
    //元数据
    NSMutableArray * _dataSource;
    
    NSMutableArray *_timeData;//18：00，9：00数据
    
    NSString *chooseDayString;//选择好的天
  
    
    NSString *_RISTARTTIME;//开始时间时间戳
    NSString *end_Time;
    NSString *_RIENDTIME;//结束时间时间戳
    
    NSArray *timeOriginData;
    
    long  differTime;//时间差值
    
    UIButton *_sureChooseBtn;//最后选择按钮
}
@property (strong, nonatomic)UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selZoneNum;//时间选择的选项3
@end

@implementation NewChooseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadBaseData];
    [self createView];
 
    
}
-(void)loadData
{
    AppUserIndex *user = [AppUserIndex GetInstance];
   
    [NetworkCore requestPOST:user.API_URL parameters:@{@"rid":@"getTimeRanges",@"bookid":_bookid} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        for (NSDictionary *dic in responseObject[@"data"]) {
            [_data addObject:dic];
            NSString *weekDay = [self weekDaywithDateString:dic[@"DAYS"]];
            weekDay = [NSString stringWithFormat:@"%@  %@",dic[@"DAYS"],weekDay];
            [_dataSource addObject:weekDay];
        }
        //此处要传一个固定的时间
        [self loadTimeData:_data[0][@"DAYS"]];
        dayChoose = _data[0][@"DAYS"];
        chooseDayString =_dataSource[0];
        self.title = chooseDayString;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];

}
//根据时间查找时间范围
-(void)loadTimeData:(NSString *)select
{
    [ProgressHUD show:@""];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getBooktimeWithdate",@"bookid":_bookid,@"timedate":select} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        //取出原始时间 具体的时间
        long  startTime = 0;
        long time =0;
        long endTime=0;
        _timeData = [NSMutableArray array];
        timeOriginData =responseObject[@"data"];
        for (NSDictionary *dic in responseObject[@"data"]) {

            time = [dic[@"S_TIME"] longValue];
            endTime =[dic[@"E_TIME"] longValue];
            startTime = time;
            //差值时间
            differTime = endTime-time;

            long num = differTime/(10*60);
            for (int i =0; i<num; i++) {
                [_timeData addObject:[self timeStr:startTime]];
                startTime = startTime+600;
            }
            [_timeData addObject:[self timeStr:endTime]];//预约结束时间
        }
        [self.collectionView layoutSubviews];
        [self.collectionView reloadData];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];
}
/*@“加载基本数据”**/
-(void)loadBaseData
{
    titleArr = @[@"已选",@"可选"];
    imageArr =@[@"choosed",@"canChoose2"];
    _data = [NSMutableArray array];
    _dataSource = [NSMutableArray array];
    _timeData = [NSMutableArray array];

}
-(void)createView
{
    self.view.backgroundColor = Base_Color2;
  
    backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(251, 252, 252);
        view;
    });
    LFUIbutton *chooseDay = ({
        LFUIbutton *view = [LFUIbutton buttonWithType:UIButtonTypeCustom];
        view.frame = CGRectMake(10, 5, 100, 30);
        [view setTitle:@"更换日期" forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateNormal];
        [view addTarget:self action:@selector(chooseDayDate) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame =CGRectMake(190+(kScreenWidth-110-240)+i*80, 5, 80, 30);
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [button setTitleColor:Color_Black forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:imageArr[i]] ;
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
            button.enabled = NO;
        [backView addSubview:button];
    }
    [self.view addSubview:backView];
    [backView sd_addSubviews:@[chooseDay]];
    
    backView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(kScreenWidth).heightIs(40);
    [self setUpCollectionView];

    [self setUpBottopmView];

}
-(void)setUpCollectionView
{
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, kScreenHeight-40-20-120-35-35-2/2) collectionViewLayout:flowLayout];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing= 0.0;

    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:Base_Color2];
    
    UINib *nib = [UINib nibWithNibName:@"TimeCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"collectioinCell"];
    [self.view addSubview:self.collectionView];
 
}
-(void)setUpBottopmView
{
    bootomView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    UILabel *timeChooseLable = ({
        UILabel *view = [UILabel new];
        view.text = @"预约时间";
        view.textColor = [UIColor blackColor];
        view.font = [UIFont systemFontOfSize:15];
        view;
    });
    noticeLabel = ({
        UILabel  *view = [UILabel new];
        view.text = @"您还未选择预约报销时间，赶紧点击选择吧！";
        view.numberOfLines = 0;
        view.font = [UIFont systemFontOfSize:13];
        view.textColor = RGB(107, 107, 107);
        view;
    });
        _sureChooseBtn =({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setTitle:@"就选它了" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        [view addTarget:self action:@selector(sureChoose) forControlEvents:UIControlEventTouchUpInside];
        view.enabled = NO;
        view.backgroundColor = Base_Color3;
        view;
    });
    UIImageView *sep1 = ({
        UIImageView *view = [UIImageView new];
        view.backgroundColor = Base_Color2;
        view;
    });
    UIImageView *sep2 = ({
        UIImageView *view = [UIImageView new];
        view.backgroundColor = Base_Color2;
        view;
    });
    [self.view addSubview:bootomView];
    [self.view bringSubviewToFront:bootomView];
    [bootomView sd_addSubviews:@[timeChooseLable,noticeLabel,_sureChooseBtn,sep1,sep2]];
    bootomView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(120);
    timeChooseLable.sd_layout.leftSpaceToView(bootomView,25).topSpaceToView(bootomView,2).widthIs(65).heightIs(20);
    noticeLabel.sd_layout.leftSpaceToView(bootomView,15).topSpaceToView(timeChooseLable,5).rightSpaceToView(bootomView,0).heightIs(40).autoHeightRatio(0);
//    chooseToNoticeBtn.sd_layout.leftSpaceToView(bootomView,15).topSpaceToView(noticeLabel,20).widthIs(110).heightIs(20);
    _sureChooseBtn.sd_layout.rightSpaceToView(bootomView,25).topSpaceToView(noticeLabel,10).widthIs(120).heightIs(30);
    sep1.sd_layout.leftSpaceToView(bootomView,0).topSpaceToView(bootomView,timeChooseLable.height/2+2).rightSpaceToView(timeChooseLable,0).heightIs(1);
    sep2.sd_layout.rightSpaceToView(bootomView,0).topEqualToView(sep1).leftSpaceToView(timeChooseLable,0).heightIs(1);
}
#pragma mark 私有方法
/**
 *  将时间戳转化为mm:hh的字符串
 *
 *  @param date 日期
 *
 *  @return 返回时间字符串
 */
-(NSString *)timeStr:(long )date
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *strDate = [dateFormatter stringFromDate:confromTimesp];
    return strDate;
}

/**
 *  获取该天是周几
 *
 *  @param date 传入的日期
 *
 *  @return 返回星期几 的字符串
 */
-(NSString *)weekDaywithDateString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    NSString *weekDay = [NSDate dayFromWeekday:inputDate];
    return  weekDay;
}
/*@"选择日期"**/
-(void)chooseDayDate{
    WEAKSELF;
    TePopList *pop = [[TePopList alloc] initWithListDataSource:_dataSource withTitle:@"选择日期" withSelectedBlock:^(NSInteger select) {
        NSString *phoneNum;
        _selZoneNum = select;
        phoneNum = _dataSource[select];
        self.title = phoneNum;
        dayChoose = _data[select][@"DAYS"];
        [weakSelf loadTimeData:_data[select][@"DAYS"]];
        chooseDayString = phoneNum;
        noticeLabel.text = @"请继续选择一个预约开始时间!";
    }];
    [pop selectIndex:_selZoneNum];
    pop.isAllowBackClick = YES;
    [pop show];
    
}
-(void)chooseNotice:(UIButton *)sender
{
    sender.selected =!sender.selected;
}
/**@就选它了**/
-(void)sureChoose
{
    //返回上个界面
    NSMutableDictionary *TimeDic = [NSMutableDictionary dictionary];
    [TimeDic setObject:_RISTARTTIME forKey:@"S_TIME"];
    [TimeDic setObject:_RIENDTIME forKey:@"E_TIME"];
    [self pushOrPopMethod:self withStartTime:TimeDic];
    
}
#pragma mark   delegate
/**
 *  代理方法  在外部实现是push  还是pop
 */
-(void)pushOrPopMethod:(UIViewController *)vc withStartTime:(NSDictionary *)TimeDic;
{
    if (self.delegate  ) {
        [_delegate pushOrPopMethod:self withStartTime:TimeDic];
    }
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _timeData.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"collectioinCell";

    TimeCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.timeLabel.text = _timeData[indexPath.row];
    cell.timeLabel.font = [UIFont systemFontOfSize:12];
    cell.timeLabel.textColor = Color_Black;
    //强制更新cell
    [cell layoutSubviews];
    return cell;
}
-(void)dealloc
{
    
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = collectionView.frame;
    return CGSizeMake((rect.size.width-2)/5.0, 35);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0.001, 0.001, 0.003);//上 左  下 右
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.04f;
}


#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _sureChooseBtn.enabled = YES;
    _sureChooseBtn.backgroundColor = Base_Orange;
    
    TimeCollectionViewCell * cell = (TimeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.timeLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = Base_Orange;
    long time = [_totaltime longLongValue];
    time = time *60;
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSDate* date = [formater dateFromString:_timeData[indexPath.row]];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    long  startTime = [timeSp longLongValue];
    long totalTime = startTime+time;
    NSString *zhongTime = [self timeStr:totalTime];
    NSLog(@"%@",zhongTime);
    noticeLabel.text = [NSString stringWithFormat:@"您已经选择了%@  %@-%@作为您的报销时间(提示:若您选择的时间范围较短,请更换较早时间预约)",chooseDayString,_timeData[indexPath.row],zhongTime];

 
    
    NSString *minute = [NSString stringWithFormat:@"%@:00",_timeData[indexPath.row]];
    NSString *dayweek = [NSString stringWithFormat:@"%@ %@",dayChoose,minute];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *Choose_date = [dateFormatter dateFromString:dayweek];//选定的日期
    //开始时间时间戳
    _RISTARTTIME = [NSString stringWithFormat:@"%ld", (long)[Choose_date timeIntervalSince1970]];
    //结束时间时间戳
    minute =[NSString stringWithFormat:@"%@:00",zhongTime];
    dayweek = [NSString stringWithFormat:@"%@ %@",dayChoose,minute];
    Choose_date = [dateFormatter dateFromString:dayweek];//选定的日期
    _RIENDTIME = [NSString stringWithFormat:@"%ld", (long)[Choose_date timeIntervalSince1970]];
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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据idenxPath获取对应的cell
    TimeCollectionViewCell *cell = (TimeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.timeLabel.textColor = Color_Black;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
