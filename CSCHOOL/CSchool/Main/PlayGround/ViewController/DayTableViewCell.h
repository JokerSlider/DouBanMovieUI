//
//  DayTableViewCell.h
//  Course
//
//  Created by MacOS on 14-12-16.
//  Copyright (c) 2014年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekCourse.h"
#import "YFRollingLabel.h"
@interface DayTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *capterLabel;

@property (retain, nonatomic) IBOutlet UILabel *courseNameLabel;

@property (retain, nonatomic) IBOutlet UIImageView *addressIcon;

@property (retain, nonatomic) IBOutlet UILabel *addressLabel;


@property (retain, nonatomic) IBOutlet UILabel *circleLabel;

@property (weak, nonatomic) IBOutlet UILabel *teacher;

@property (weak, nonatomic) IBOutlet UILabel *courseTime;


@property (weak, nonatomic) IBOutlet UILabel *courseNameL;

@property (weak, nonatomic) IBOutlet UILabel *courseTimeL;

@property (weak, nonatomic) IBOutlet UILabel *courseAddressL;

//课程开始时间
@property(nonatomic,copy)NSString *startTime;
//课程结束时间
@property(nonatomic,copy)NSString *endTime;
//课程节次代码
@property(nonatomic,copy)NSString *courseNum;

@property(retain,nonatomic)UIColor *baseColor;
@property (nonatomic, retain) WeekCourse *weekCourse;

@property(nonatomic,retain)NSArray *timeArr;
@property (weak, nonatomic) IBOutlet UIImageView *seaptearImage;

@property(nonatomic,strong)YFRollingLabel *weekLabel;

@property (weak, nonatomic) IBOutlet UILabel *teacherNameL;

@property(nonatomic,copy)NSString *courseName;//从空教室加载课程表的时候的教室名

@end
