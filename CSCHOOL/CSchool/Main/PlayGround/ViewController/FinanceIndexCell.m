//
//  FinanceIndexCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/8/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FinanceIndexCell.h"
#import "SDAutoLayout.h"
#import "UIButton+BackgroundColor.h"
#import "NSDate+Extension.h"
#import "UIView+UIViewController.h"
#import "FinanceAddViewController.h"
#import <YYText.h>
#import "UIView+UIViewController.h"
#import "FinanceStepViewController.h"
#import "UILabel+stringFrame.h"
#import <EventKit/EventKit.h>

@implementation FinanceIndexModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"timeStr" : @"RISTARTTIME",
             @"contentStr" : @"RTTNAME",
             @"numStr" : @"WIID",
             @"chuangkou" : @"WINAME",
             @"status":@"RISTATUS",
             @"financeId":@"RIID",
             @"CalenderEventS_Time":@"RISTARTTIME",
             @"CalenderEventE_Time":@"RIENDTIME",
             };
}

/**
 *  @property (nonatomic, copy) NSString *timeStr;
 @property (nonatomic, copy) NSString *contentStr;
 @property (nonatomic, copy) NSString *numStr;
 @property (nonatomic, copy) NSString *chuangkou;
 @property (nonatomic, copy) NSString *status;
 @property (nonatomic, copy) NSString *financeId;
 @property (nonatomic, retain) NSArray *standardInfo;
 @property (nonatomic, copy) NSMutableString *typeString; //根据数组拼接而成
 @property (nonatomic, assign) NSInteger totalNum; //根据数组相加
 @property (nonatomic,copy)NSString *CalenderEventS_Time;//日历开始时间
 @property (nonatomic,copy)NSString *CalenderEventE_Time;//日历结束时间
 *
 *  @param dic <#dic description#>
 */
- (void)modelSetDic:(NSDictionary *)dic{
    self.timeStr = dic[@"RISTARTTIME"];
    self.contentStr = dic[@"RTTNAME"];
    self.numStr = dic[@"WIID"];
    self.chuangkou = dic[@"WINAME"];
    self.status = dic[@"RISTATUS"];
    self.financeId = dic[@"RIID"];
    self.standardInfo = dic[@"standardInfo"];
    self.CalenderEventS_Time = dic[@"RISTARTTIME"];
    self.CalenderEventE_Time = dic[@"RIENDTIME"];
}

//将数组中的类别和张数进行处理
- (void)setStandardInfo:(NSArray *)standardInfo{
    _standardInfo = standardInfo;
    if (!_typeString) {
        _typeString = [NSMutableString string];
    }
    if (_totalNum) {
        _totalNum = 0;
    }
    for (NSDictionary *dic in standardInfo) {
//        [_typeString stringByAppendingString:dic[@"RTNAME"]];
        [_typeString appendString:dic[@"RTNAME"]];
        [_typeString appendString:@"; "];
        _totalNum += [dic[@"RRNUMBER"] integerValue];
    }
}

//将字符串
- (void)setTimeStr:(NSString *)timeStr{
    NSTimeInterval second2 = [timeStr doubleValue];
    NSDate *date3 = [NSDate dateWithTimeIntervalSince1970:second2];
    NSString *weekStr = [NSDate dayFromWeekday:date3];
    //格式化日期类
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    
    //将日期按照格式化日期类转换为字符串
    NSString *str2 = [df stringFromDate:date3];
    _timeStr = [NSString stringWithFormat:@"%@(%@)",str2, weekStr];
}
-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;

}
-(void)setCalenderEventS_Time:(NSString *)CalenderEventS_Time
{
    _CalenderEventS_Time = CalenderEventS_Time;
}
-(void)setCalenderEventE_Time:(NSString *)CalenderEventE_Time
{
    _CalenderEventE_Time  = CalenderEventE_Time;
}
-(void)setFinanceId:(NSString *)financeId
{
    _financeId = financeId;
}
@end

@implementation FinanceIndexCell
{
    UIView *bgView;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UILabel *_numLabel;
    UILabel *_chuangkouLabel;
    UIButton *_bottomButton;
    UILabel *_statusLabel;
    UIView *_tagsView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _contentLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _numLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _chuangkouLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _bottomButton = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.sd_cornerRadius = @(3);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.titleLabel.font = Title_Font;
        [view setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [view setTitleColor:Base_Orange forState:UIControlStateSelected];
        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        [view addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _statusLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
        view;
    });
    
    _tagsView = ({
        UIView *view = [[UIView alloc] init];
        view;
    });
    
    [self.contentView addSubview:bgView];
    [bgView sd_addSubviews:@[_timeLabel, _tagsView, _numLabel, _chuangkouLabel, _bottomButton, _statusLabel]];
    
    bgView.sd_layout
    .topSpaceToView(self.contentView,2)
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15);
    
    _timeLabel.sd_layout
    .topSpaceToView(bgView,10)
    .leftSpaceToView(bgView,10)
    .rightSpaceToView(bgView,0)
    .heightIs(20);
    
    _tagsView.sd_layout
    .topSpaceToView(_timeLabel,3)
    .leftEqualToView(_timeLabel)
    .rightEqualToView(_timeLabel);
    
    _numLabel.sd_layout
    .topSpaceToView(_tagsView,3)
    .leftEqualToView(_timeLabel)
    .rightEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1);
    
    _chuangkouLabel.sd_layout
    .topSpaceToView(_numLabel,3)
    .leftEqualToView(_timeLabel)
    .rightEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1);
    
    _statusLabel.sd_layout
    .topSpaceToView(_chuangkouLabel,3)
    .leftEqualToView(_timeLabel)
    .rightEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1);
    
    _bottomButton.sd_layout
    .topSpaceToView(_statusLabel,5)
    .rightSpaceToView(bgView,5)
    .widthIs(70);
}

- (void)setModel:(FinanceIndexModel *)model{
    _model = model;
    _timeLabel.text = [NSString stringWithFormat:@"预约时间: %@",model.timeStr];
//    _contentLabel.text = [NSString stringWithFormat:@"预约内容: %@",model.typeString];
    _numLabel.text = [NSString stringWithFormat:@"单据数量: %ld",model.totalNum];
    _chuangkouLabel.text = [NSString stringWithFormat:@"预约窗口: %@",model.chuangkou];
    NSDictionary *dic = @{@"1":@"处理中",@"2":@"处理完成",@"3":@"无效",@"4":@"用户已取消",@"5":@"逾期",@"6":@"待处理"};
    
    _statusLabel.text = [NSString stringWithFormat:@"预约状态: %@",dic[_model.status]];
    
    NSArray *tagsArr = [model.contentStr componentsSeparatedByString:@","];
    CGFloat btnWith = (kScreenWidth-75)/4;
    UILabel *lastBtn = nil;
    [_tagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat lineWith = kScreenWidth-75;
    CGFloat lineUseWith = lineWith;
    NSInteger numOfline = 0;
    for (int i=0; i<tagsArr.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = RGB(253, 162, 84);
        if (model.standardInfo.count == tagsArr.count) {
            label.text = [NSString stringWithFormat:@"%@(%@)",model.standardInfo[i][@"FNAME"],model.standardInfo[i][@"RTID"]];
        }else{
            label.text = tagsArr[i];
        }
        label.textAlignment = NSTextAlignmentCenter;
        CGSize size = [label boundingRectWithSize:CGSizeMake(200, 10)];
        if ((lineUseWith - size.width-5)>0) {
            label.frame = CGRectMake((lineWith-lineUseWith)+5, numOfline*30, size.width+20, 25);
            lineUseWith = lineUseWith - size.width - 5-20;
        }else{
            lineUseWith = lineWith;
            numOfline++;
            label.frame = CGRectMake((lineWith-lineUseWith)+5, numOfline*30, size.width+20, 25);
            lineUseWith = lineUseWith - size.width - 5-20;
        }
        [_tagsView addSubview:label];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.userInteractionEnabled = YES;
        lastBtn = label;
        label.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openFinanceStep:)];
//        tap.view.tag = i;
        [label addGestureRecognizer:tap];
    }
    
    
    if (lastBtn) {
        [_tagsView setupAutoHeightWithBottomView:lastBtn bottomMargin:10];
    }
    
    if ([_model.status isEqualToString:@"6"]) {
        _bottomButton.layer.borderColor = [UIColor grayColor].CGColor;
        _bottomButton.selected = NO;
        [_bottomButton setTitle:@"取消预约" forState:UIControlStateNormal];
        _bottomButton.sd_layout.heightIs(25);
    }else if ([_model.status isEqualToString:@"4"] || [_model.status isEqualToString:@"5"]){
        [_bottomButton setTitle:@"重新预约" forState:UIControlStateNormal];
        _bottomButton.layer.borderColor = Base_Orange.CGColor;
        _bottomButton.selected = YES;
        _bottomButton.sd_layout.heightIs(25);
    }else{
        _bottomButton.sd_layout.heightIs(0);
        [_bottomButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    [bgView setupAutoHeightWithBottomView:_bottomButton bottomMargin:10];
    [self setupAutoHeightWithBottomView:bgView bottomMargin:3];
    
}

- (void)openFinanceStep:(UITapGestureRecognizer *)sender{
    FinanceStepViewController *vc1 = [[FinanceStepViewController alloc] init];
    vc1.typeDic = _model.standardInfo[sender.view.tag];
    vc1.isDetail = YES;
    [self.viewController.navigationController pushViewController:vc1 animated:YES];
}


- (void)bottomButtonClick:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"取消预约"]) {
        XGAlertView *alert = [[XGAlertView alloc] initWithTarget:self withTitle:@"提示" withContent:@"确定要取消预约吗？" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
        [alert show];
        
    }else if([sender.titleLabel.text isEqualToString:@"重新预约"]){
        FinanceAddViewController *vc = [[FinanceAddViewController alloc] init];
        [self.viewController.navigationController pushViewController:vc animated:YES];
        [vc addDataWithArray:_model.standardInfo];
    }
}


- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title{
    [ProgressHUD show:nil];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"cancelAccountById", @"bookid":_model.financeId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        //移除对应的日历事件
        [self deleteCalenderEvent];
        SEL faSelector=NSSelectorFromString(@"loadData");
        [self.viewController performSelector:faSelector withObject:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            
    }];
}
//移除日历事件中对应的事件
-(void)deleteCalenderEvent
{
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    NSDate* ssdate = [NSDate dateWithTimeIntervalSince1970:[_model.CalenderEventS_Time intValue]];//事件段，开始时间
    NSDate* ssend = [NSDate dateWithTimeIntervalSince1970:[_model.CalenderEventE_Time intValue]];//结束时间，取中间
    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:ssdate
                                                                 endDate:ssend
                                                               calendars:nil]; 
    NSArray *events = [eventStore eventsMatchingPredicate:predicate]; 
    for (EKEvent *event in events) {
        if ([event.notes isEqualToString:_model.financeId]) {
            if([eventStore removeEvent:event span:EKSpanFutureEvents error:nil]){
                NSLog(@"移除成功！");
            }
        }
    
    }
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
