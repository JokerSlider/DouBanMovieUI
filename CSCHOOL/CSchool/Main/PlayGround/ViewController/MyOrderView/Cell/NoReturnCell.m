//
//  NoReturnCell.m
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "NoReturnCell.h"
#import "UIView+SDAutoLayout.h"
#import "LibiraryModel.h"
#import "UILabel+stringFrame.h"
#import "CalenderObject.h"
#define PassColor [UIColor redColor];

@implementation NoReturnCell
{
    UILabel *_bookName;//书名
    UILabel *_authorName;//作者
    UILabel *_pushofficeName;//出版社
//    UILabel *_bookNum;//条码号
    UILabel *_orderTime;//借书时间
    UILabel *_returnTime;//还书时间
    UILabel *_orderState;//状态
    
    UILabel *_noticeL;//归还提醒
    
    UISwitch *_noticeSwitch;//开关
    
    UILabel  *_noticeWord;//提示文字
    
    UIView *_lineView;//分割线

    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    _bookName = ({
        UILabel *view = [UILabel new];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    _authorName = ({
        UILabel *view = [UILabel new];
        view.text = @"作者                ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    _pushofficeName = ({
        UILabel *view = [UILabel new];
        view.text = @"出版社            ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });

    _orderTime = ({
        UILabel *view = [UILabel new];
        view.text = @"借书时间         ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    _returnTime = ({
        UILabel *view = [UILabel new];
        view.text = @"应归还时间     ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });
    _orderState = ({
        UILabel *view = [UILabel new];
        view.text = @"状态                ";
        view.font = Title_Font;
        view.textColor = Color_Gray;
        view;
    });

   _lineView  = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(225, 225, 225);
        view;
    });
    _noticeL = ({
        UILabel *view = [UILabel new];
        view.text = @"归还提醒";
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = Color_Black;
        view;
    });
    _noticeSwitch  = ({
        UISwitch *view = [UISwitch new];
        [view addTarget:self action:@selector(openNotice:) forControlEvents:UIControlEventValueChanged];
        view;
    });
    
    _noticeWord = ({
        UILabel *view = [UILabel new];
        view.text = @"(即将到期,请按时归还)";
        view.font = [UIFont systemFontOfSize:11];
        view.textColor = [UIColor redColor];
        view;
    });
    [self.contentView sd_addSubviews:@[_bookName,_authorName,_pushofficeName,_orderTime,_returnTime,_orderState,_lineView,_noticeSwitch,_noticeL,_noticeWord]];
    UIView *contentView = self.contentView;
    _bookName.sd_layout.leftSpaceToView(contentView,15).topSpaceToView(contentView,10).widthIs(kScreenWidth-20).heightIs(15);
    _authorName.sd_layout.leftEqualToView(_bookName).topSpaceToView(_bookName,5).widthIs(kScreenWidth-20).heightIs(15);
    _pushofficeName.sd_layout.leftEqualToView(_bookName).topSpaceToView(_authorName,5).widthIs(kScreenWidth).heightIs(15);
    _orderTime.sd_layout.leftEqualToView(_bookName).topSpaceToView(_pushofficeName,5).widthIs(kScreenWidth).heightIs(15);
    _returnTime.sd_layout.leftEqualToView(_bookName).topSpaceToView(_orderTime,5).widthIs(kScreenWidth).heightIs(15);
    _orderState.sd_layout.leftEqualToView(_bookName).topSpaceToView(_returnTime,5).widthIs(kScreenWidth).heightIs(15);
    [self layoutViews];
}
-(void)layoutViews
{
    UIView *contentView = self.contentView;
    _lineView.sd_layout.leftSpaceToView(contentView,0).rightSpaceToView(contentView,0).topSpaceToView(_orderState,5).heightIs(0.5);
    _noticeL.sd_layout.leftSpaceToView(contentView,15).topSpaceToView(_lineView,15).widthIs(100).heightIs(15);
    _noticeSwitch.sd_layout.rightSpaceToView(contentView,10).topSpaceToView(_lineView,5).widthIs(20).heightIs(15);
    _noticeWord.sd_layout.leftSpaceToView(_orderState,0).topEqualToView(_orderState).widthIs(100).heightIs(15);
    [self setupAutoHeightWithBottomView:_noticeL bottomMargin:10];
    if (_noticeL.hidden == YES) {
        //关闭归还提醒  并显示已超期
        _orderState.text = @"状态                已超期";
        _orderState.textColor = PassColor;
        _bookName.textColor = PassColor;
        _authorName.textColor = PassColor;
        _pushofficeName.textColor = PassColor;
        _orderTime.textColor = PassColor;
        _returnTime.textColor = PassColor;
        _orderTime.textColor = PassColor;
        
        _lineView.hidden=YES;
        _noticeL.hidden=YES;;
        _noticeSwitch.hidden = YES;
        _noticeWord.hidden = YES;
        [self setupAutoHeightWithBottomView:_orderState bottomMargin:10];
    }
   
}
-(void)setModel:(LibiraryModel *)model
{
    _model = model;
    _bookName.text =[NSString stringWithFormat:@"%@", model.bookName];
    _authorName.text =[NSString stringWithFormat:@"作者                %@",model.authorName];
    _pushofficeName.text = [NSString stringWithFormat:@"出版社            %@",model.publishOfficeName];
    NSString *orderTime = [self dateString:model.orderTime];

    _orderTime.text = [NSString stringWithFormat:@"借书时间         %@",orderTime];
    _returnTime.text =[NSString stringWithFormat:@"应归还时间     %@",model.returnTime];
 
    int differDate = [self compareOneDay:model.returnTime withAnotherDay:model.libiraryDate];
    //没到期
    if (differDate<=1&&differDate>=0) {
        _orderState.text = @"状态                未归还";
      //判断差多少天
        int differDay = (int)[self getDaysFrom:model.libiraryDate To:model.returnTime];
        if (differDay<=3) {
           //距离归还时间还有3天
            _noticeWord.hidden = NO;

        }else{
            _noticeWord.hidden = YES;
        }
    }
    //到期了
    else if(differDate<0){
        _noticeL.hidden = YES;
        [self layoutViews ];
    }
    

    CGSize size = [_pushofficeName boundingRectWithSize:CGSizeMake(0, 15)];
    _pushofficeName.sd_layout.widthIs(size.width);
    size = [_orderTime boundingRectWithSize:CGSizeMake(0, 15)];
    _orderTime.sd_layout.widthIs(size.width);
    size = [_returnTime boundingRectWithSize:CGSizeMake(0, 15)];
    _returnTime.sd_layout.widthIs(size.width);
    size = [_orderState boundingRectWithSize:CGSizeMake(0, 15)];
    _orderState.sd_layout.widthIs(size.width);
    
    size = [_noticeWord boundingRectWithSize:CGSizeMake(0, 15)];
    _noticeWord.sd_layout.widthIs(size.width);
    
    //记录打开状态
    NSString *idetifider = [NSString stringWithFormat:@"%@%@",[AppUserIndex GetInstance].role_id,_model.PROP_NO];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:idetifider] isEqualToString:idetifider]) {
        _noticeSwitch.selected = YES;
        [_noticeSwitch setOn:YES];

    }
}
-(void)openNotice:(UISwitch *)sender
{
    //添加日历提醒
    NSString *title = [NSString stringWithFormat:@"您借阅的图书《%@》明日到期,请及时归还",_model.bookName];
    NSString *statrtTime = [self timeSwitchTimestamp:[self getDatePastDay:_model.returnTime] andFormatter:@"yyyy-MM-dd"];//提前一日提醒
    NSString *endTime    =[self timeSwitchTimestamp:_model.returnTime andFormatter:@"yyyy-MM-dd"];
    NSString *location = [AppUserIndex GetInstance].schoolName;
    NSString *idetifider = [NSString stringWithFormat:@"%@%@",[AppUserIndex GetInstance].role_id,_model.PROP_NO];

    if (!sender.selected) {
        //添加提醒  半小时--一小时进行提醒。
        [CalenderObject initWithTitle:title andIdetifider:idetifider  WithStartTime:statrtTime andEndTime:endTime Location:location andNoticeFirTime:60.0f * 60.0f*10 withNoticeEndTime:60.0f * 30.0f*12];
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"添加提醒成功" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        alert.isBackClick = YES;
        [alert show];
        [[NSUserDefaults standardUserDefaults]setObject:idetifider forKey:idetifider];
    }else{
        [CalenderObject deleteCalenderEvent:statrtTime andEndTime:endTime withIdetifier:idetifider];
        XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"删除提醒成功" WithCancelButtonTitle:@"确定" withOtherButton:nil];
        alert.isBackClick = YES;
        [alert show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:idetifider];
    }
    sender.selected = !sender.selected;

}
-(NSString *)dateString:(NSString *)date
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Asia/Beijing"]];
    [inputFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [inputFormatter stringFromDate:inputDate];
    return str;
}
- (int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Shanghai"]];
    NSDate *inputDate = [dateFormatter dateFromString:oneDay];
    NSDate *anotherDate = [dateFormatter dateFromString:anotherDay];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:inputDate];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDate];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
//        NSLog(@"还没到期");
        return 1;
    }
    else if (result == NSOrderedAscending){
//        NSLog(@"到期了");
        return -1;
    }
//    NSLog(@"同一天");
    return 0;
    
}
-(NSInteger)getDaysFrom:(NSString *)serverDate To:(NSString *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Shanghai"]];
    NSDate *inputDate = [dateFormatter dateFromString:serverDate];
    NSDate *anotherDate = [dateFormatter dateFromString:endDate];

    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:inputDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:anotherDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return dayComponents.day;
}
//时间转时间戳
-(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return [NSString stringWithFormat:@"%ld",timeSp];
    
}
//获取给定日期的前一天
-(NSString *)getDatePastDay:(NSString *)datString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:datString];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:date];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *str = [formatter stringFromDate:yesterday];
    return  str;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
