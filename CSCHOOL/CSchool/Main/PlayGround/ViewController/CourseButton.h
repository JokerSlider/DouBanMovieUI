//
//  CourseButton.h
//  Course
//
//  Created by MacOS on 14-12-22.
//  Copyright (c) 2014年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekCourse.h"

@interface CourseButton : UIButton
{
//    UILabel *classNameL;
//    UILabel *classRomL;

}

@property (nonatomic,retain) WeekCourse *weekCourse;
//课程名
@property(nonatomic,copy)    NSString *courseName;
//教室名
@property(nonatomic,copy)    NSString *claRoom;
//周几
@property(nonatomic,copy) NSString *day;
//课程从第几节开始
@property(nonatomic,copy)NSString *startLesson;           //课程从第几节开始
@property(nonatomic,copy)NSString *endLesson;
@property(nonatomic,copy)NSString *lessonsNum;
//教师名
@property(nonatomic,copy)NSString *teacherName;

@property(nonatomic,strong)UIColor *courseButtonbackcolor;
@property(nonatomic,strong)UILabel *classNameL;
@property(nonatomic,strong)UILabel *classRomL;


@property(nonatomic,copy)NSString *nextCourseName;//上节课的节课的课程名
@property(nonatomic,copy)NSString *nextCourseClaName;//上节课的教室






@end
