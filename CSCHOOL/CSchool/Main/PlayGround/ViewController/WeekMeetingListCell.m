//
//  WeekMeetingListCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/9/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WeekMeetingListCell.h"
#import "SDAutoLayout.h"
#import "NSDate+Extension.h"

@implementation WeekMeetingListModel

/**
 *  @property (nonatomic, copy) NSString *;
     @property (nonatomic, copy) NSString *;
     @property (nonatomic, copy) NSString *;
     @property (nonatomic, copy) NSString *;
     @property (nonatomic, copy) NSString *;
     @property (nonatomic, copy) NSString *;
 *
 *  @return
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"title" : @"logName",
             @"time" : @"logDate",
             @"address" : @"logAddress",
             @"host" : @"logHost",
             @"department":@"logCompany",
             @"member":@"logJoined"
             };
}
@end

@implementation WeekMeetingListCell
{
    UIView *_backView;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_addLabel;
    UILabel *_holderLabel;
    UILabel *_departLabel;
    UILabel *_memberLabel;
    UILabel *_memberTitleLabel;
    UIImageView *_timeView;
    UIImageView *_addView;
    UIImageView *_holderView;
    UIImageView *_departView;
    UIImageView *_memberView;
    UIImageView *_needJoinView;
    UILabel *_needJoinLabel;
    UISwitch *_addNoticSwitch;
    UIView *_lineView;
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
    _backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        view;
    });
    
    _titleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:18];
        view.textColor = RGB(51, 51, 51);
        view;
    });
    
    _timeLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _addLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _holderLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _departLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _memberLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view;
    });
    
    _memberTitleLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(85, 85, 85);
        view.text = @"参加人员:";
        view;
    });
    
    _timeView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"meeting_time"];
        view;
    });
    
    _addView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"meeting_location"];
        view;
    });
    
    _holderView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"meeting_host"];
        view;
    });
    
    _departView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"meeting_department"];
        view;
    });
    
    _memberView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"meeting_group"];
        view;
    });
    
    _needJoinView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"meeting_join"];
        view;
    });
    
    _needJoinLabel = ({
        UILabel *view = [UILabel new];
        view.font = [UIFont systemFontOfSize:15];
        view.textColor = RGB(51, 51, 51);
        view.text = @"我需参加，请提醒";
        view;
    });
    
    _addNoticSwitch = ({
        UISwitch *view = [[UISwitch alloc] init];
        [view addTarget:self action:@selector(addNotice:) forControlEvents:UIControlEventValueChanged];
        view;
    });
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.contentView addSubview:_backView];
    [_backView sd_addSubviews:@[_titleLabel, _timeLabel, _addLabel, _holderLabel, _departLabel, _memberTitleLabel, _memberLabel, _timeView, _addView, _holderView, _departView, _memberView, _needJoinLabel, _lineView,_needJoinView, _addNoticSwitch]];
    
    _backView.sd_layout
    .leftSpaceToView(self.contentView,14)
    .rightSpaceToView(self.contentView,14)
    .topSpaceToView(self.contentView,7);
    
    _titleLabel.sd_layout
    .leftSpaceToView(_backView,14)
    .topSpaceToView(_backView,15)
    .rightSpaceToView(_backView,2)
    .autoHeightRatio(0);
    
    _timeView.sd_layout
    .leftSpaceToView(_backView,14)
    .topSpaceToView(_titleLabel,22)
    .widthIs(15)
    .heightIs(15);
    
    _timeLabel.sd_layout
    .leftSpaceToView(_timeView,10)
    .topSpaceToView(_titleLabel,22)
    .rightSpaceToView(_backView,2)
    .heightIs(15);
    
    _addView.sd_layout
    .leftSpaceToView(_backView,14)
    .topSpaceToView(_timeView,9)
    .widthRatioToView(_timeView,1)
    .heightRatioToView(_timeView,1);
    
    _addLabel.sd_layout
    .leftSpaceToView(_addView,10)
    .topSpaceToView(_timeLabel,9)
    .rightSpaceToView(_backView,2)
    .heightIs(15);
    
    _holderView.sd_layout
    .leftSpaceToView(_backView,14)
    .topSpaceToView(_addView,9)
    .widthRatioToView(_timeView,1)
    .heightRatioToView(_timeView,1);
    
    _holderLabel.sd_layout
    .leftSpaceToView(_holderView,10)
    .topSpaceToView(_addLabel,9)
    .rightSpaceToView(_backView,2)
    .heightIs(15);
    
    _departView.sd_layout
    .leftSpaceToView(_backView,14)
    .topSpaceToView(_holderView,9)
    .widthRatioToView(_timeView,1)
    .heightRatioToView(_timeView,1);
    
    _departLabel.sd_layout
    .leftSpaceToView(_departView,10)
    .topSpaceToView(_holderLabel,9)
    .rightSpaceToView(_backView,2)
    .heightIs(15);
    
    _memberView.sd_layout
    .leftSpaceToView(_backView,14)
    .topSpaceToView(_departView,9)
    .widthRatioToView(_timeView,1)
    .heightRatioToView(_timeView,1);
    
    _memberTitleLabel.sd_layout
    .leftSpaceToView(_memberView,10)
    .topSpaceToView(_departLabel,9)
    .widthIs(70)
    .heightIs(15);
    
    _memberLabel.sd_layout
    .leftSpaceToView(_memberTitleLabel,3)
    .topEqualToView(_memberTitleLabel)
    .rightSpaceToView(_backView,2)
    .autoHeightRatio(0);
    
    _needJoinView.sd_layout
    .bottomSpaceToView(_backView,2)
    .rightSpaceToView(_backView,2)
    .widthIs(60)
    .heightIs(60);
    
    _lineView.sd_layout
    .leftSpaceToView(_backView,0)
    .rightSpaceToView(_backView,0)
    .topSpaceToView(_memberLabel,6)
    .heightIs(0.5);
    
    _needJoinLabel.sd_layout
    .leftSpaceToView(_backView,14)
    .topSpaceToView(_lineView,10)
    .widthIs(200)
    .heightIs(18);
    
    _addNoticSwitch.sd_layout
    .rightSpaceToView(_backView,5)
    .topSpaceToView(_lineView,4)
    .widthIs(30)
    .heightIs(15);
}

- (void)setModel:(WeekMeetingListModel *)model{
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"周%@：%@", model
                        .logWeek, model.title];
    _timeLabel.text = [NSString stringWithFormat:@"会议时间:  %@  %@",model.time, model.logTime];
    _addLabel.text = [NSString stringWithFormat:@"会议地点:  %@",model.address];
    _holderLabel.text = [NSString stringWithFormat:@"主持人:      %@",model.host];
    _departLabel.text = [NSString stringWithFormat:@"承办部门:  %@",model.department];
    _memberLabel.text = model.member;
    
    NSArray *labelArr = @[_titleLabel, _timeLabel, _addLabel, _holderLabel, _departLabel, _memberLabel, _memberTitleLabel];
    
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *meetDate = [tempFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",_model.time,_model.logTime]];
    NSDate *earlierDate = [meetDate earlierDate:[NSDate date]];
    
    
    //在本天之前的不显示提醒。
//    if (![earlierDate isSameDay:[NSDate date]]) {
    if (([meetDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970])<0) {
        _addNoticSwitch.hidden = YES;
        _needJoinLabel.hidden = YES;
        _lineView.hidden = YES;
        [_backView setupAutoHeightWithBottomView:_memberLabel bottomMargin:15];
    }else{
        _addNoticSwitch.hidden = NO;
        _needJoinLabel.hidden = NO;
        [_backView setupAutoHeightWithBottomView:_addNoticSwitch bottomMargin:4];
    }
    
    //存在日历中，并且时间还没有过，标红。
    if ([AppUserIndex GetInstance].meetingNoticDic[_model.logId] && [[AppUserIndex GetInstance].meetingNoticDic[_model.logId] length] >0 && (([meetDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970])>0)) {
        for (UILabel *label  in labelArr) {
            label.textColor = RGB(203, 88, 113);
        }
        _needJoinView.hidden = YES;
        _addNoticSwitch.on = YES;
    }else{
        for (UILabel *label  in labelArr) {
            label.textColor = RGB(85, 85, 85);
        }
        _needJoinView.hidden = YES;
        _addNoticSwitch.on = NO;
    }
    
    [self setupAutoHeightWithBottomView:_backView bottomMargin:7];
}

- (void)addNotice:(UISwitch *)sender{
    if (sender.on) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"添加到日历提醒？"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"好的",nil];
        alert.tag = 1963;
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"取消日历提醒？"
                              delegate:self
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"好的",nil];
        alert.tag = 1964;
        [alert show];

    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1963 && buttonIndex == 1) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误细心
                    // display error message here
                    _addNoticSwitch.on = NO;
                }
                else if (!granted)
                {
                    //被用户拒绝，不允许访问日历
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"提示"
                                          message:@"获取日历权限失败！"
                                          delegate:nil
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil];
                    [alert show];
                    _addNoticSwitch.on = NO;
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    
                    //事件保存到日历
                    
                    
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = _model.title;
                    event.location = _model.address;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    
                    event.startDate = [tempFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",_model.time,_model.logTime]];
                    event.endDate   = [NSDate dateWithTimeInterval:3600 sinceDate:event.startDate];
                    //                event.allDay = YES;
                    NSLog(@"%@",[NSString stringWithFormat:@"%@ %@",_model.time,_model.logTime]);
                    
                    //添加提醒
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                    //                [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"提示"
                                          message:@"保存成功，系统将提前15分钟提醒您。"
                                          delegate:nil
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil];
                    [alert show];
                    
                    if (![AppUserIndex GetInstance].meetingNoticDic) {
                        [AppUserIndex GetInstance].meetingNoticDic = [NSMutableDictionary dictionary];
                    }
                    
                    [[AppUserIndex GetInstance].meetingNoticDic setObject:event.eventIdentifier forKey:_model.logId];
                    [[AppUserIndex GetInstance] saveToFile];
                    self.model = _model;
                    NSLog(@"保存成功");
                    
                }
            });
        }];
    }else if (alertView.tag == 1964 && buttonIndex == 1){
        
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        EKEvent *event = [eventStore eventWithIdentifier:[AppUserIndex GetInstance].meetingNoticDic[_model.logId]];// ;
        NSError *err;
        [eventStore removeEvent:event span:EKSpanThisEvent error:&err];
        [[AppUserIndex GetInstance].meetingNoticDic setObject:@"" forKey:_model.logId];
        [[AppUserIndex GetInstance] saveToFile];
        self.model = _model;
    }else{
        _addNoticSwitch.on = !_addNoticSwitch.on;
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
