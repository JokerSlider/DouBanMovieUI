//
//  CalenderObject.m
//  CSchool
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CalenderObject.h"
#import <EventKit/EventKit.h>

@implementation CalenderObject


+(void)initWithTitle:(NSString *)title andIdetifider:(NSString *)idefitier WithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime Location:(NSString *)location andNoticeFirTime:(double)noticeFirTime withNoticeEndTime:(double)noticeSecTime
{
    [[self alloc]initWithTitle:title andIdetifider:idefitier WithStartTime:startTime andEndTime:endTime Location:location andNoticeFirTime:noticeFirTime withNoticeEndTime:noticeSecTime];
}
-(void)initWithTitle:(NSString *)title andIdetifider:(NSString *)idefitier WithStartTime:(NSString *)startTime andEndTime:(NSString *)endTime Location:(NSString *)location andNoticeFirTime:(double)noticeFirTime withNoticeEndTime:(double)noticeSecTime
{
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
                        NSLog(@"用户拒绝访问日历");                        
                    }
                    else
                    {
                        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                        NSDate *sDate = [NSDate dateWithTimeIntervalSince1970:[startTime  intValue]];
                        NSDate *eDate = [NSDate dateWithTimeIntervalSince1970:[endTime intValue]];
                        event.startDate = sDate;
                        event.endDate   = eDate;
                        /*@"这个时间是当你需要展示该事件的日历时间的时候用的 转化为本地时间"*/
                        sDate = [self changeDate:sDate];
                        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
                        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                        event.title =title;
                        event.location =location;
                        event.notes =idefitier;
                        //添加提醒    默认半小时--一小时进行提醒。
                        if (!noticeFirTime||!noticeSecTime) {
                            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:60.0f * -60.0f];
                            EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:60.0f*-30.0f];
                            [event addAlarm:alarm];
                            [event addAlarm:alarm2];
                            [event setCalendar:[eventStore defaultCalendarForNewEvents]];

                        }else{
                            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:noticeFirTime];
                            EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:noticeSecTime];
                            [event addAlarm:alarm];
                            [event addAlarm:alarm2];
                            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                            
                        }
                                NSError *err;
                        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    }
                });
            }];
        }
}
+(void)deleteCalenderEvent:(NSString *)startTime andEndTime:(NSString *)endTime  withIdetifier:(NSString *)idetifier
{
    [[self alloc]deleteCalenderEvent:startTime andEndTime:endTime withIdetifier:idetifier];
}

//移除日历事件中对应的事件
-(void)deleteCalenderEvent:(NSString *)startTime andEndTime:(NSString *)endTime  withIdetifier:(NSString *)idetifier
{
    EKEventStore* eventStore = [[EKEventStore alloc] init];
    NSDate* ssdate = [NSDate dateWithTimeIntervalSince1970:[startTime intValue]];//事件段，开始时间
    NSDate* ssend = [NSDate dateWithTimeIntervalSince1970:[endTime intValue]];//结束时间，取中间
    NSPredicate* predicate = [eventStore predicateForEventsWithStartDate:ssdate
                                                                 endDate:ssend
                                                               calendars:nil];
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    for (EKEvent *event in events) {
        if ([event.notes isEqualToString:idetifier]) {
            if([eventStore removeEvent:event span:EKSpanFutureEvents error:nil]){
                NSLog(@"移除成功！");
            
            }
        }
        
    }
}

//转化为本地时间
-(NSDate *)changeDate:(NSDate *)originDate
{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:originDate];
    
    NSDate *localeDate = [originDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

@end
