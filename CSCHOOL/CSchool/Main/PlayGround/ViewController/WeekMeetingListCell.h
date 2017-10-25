//
//  WeekMeetingListCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/9/8.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
@interface WeekMeetingListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *member;
@property (nonatomic, copy) NSString *logWeek;
@property (nonatomic, copy) NSString *logTime;
@property (nonatomic, copy) NSString *logId;

@property (nonatomic, assign) BOOL isJoin;

@end

@interface WeekMeetingListCell : UITableViewCell

@property (nonatomic, retain) WeekMeetingListModel *model;

@end
