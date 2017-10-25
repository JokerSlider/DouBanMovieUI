//
//  DayTableViewCell.m
//  Course
//
//  Created by MacOS on 14-12-16.
//  Copyright (c) 2016年 Joker. All rights reserved.
//

#import "DayTableViewCell.h"

@implementation DayTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setWeekCourse:(WeekCourse *)weekCourse
{
    if (_weekCourse != weekCourse) {
        _weekCourse = weekCourse;
    }
    AppUserIndex *user = [AppUserIndex GetInstance];
    NSDictionary *kssjDic = user.kssjDic;
    NSDictionary *jssjDic = user.jssjDic;
    NSArray *widArr = user.widArr;
    
    self.capterLabel.text = weekCourse.capter;
    self.capterLabel.font = Title_Font;
    if (weekCourse.KCM) {
        if (weekCourse.KXH) {
            self.courseNameLabel.text = [NSString stringWithFormat:@"%@[%@]",weekCourse.KCM,weekCourse.KXH];
        }else{
            self.courseNameLabel.text = weekCourse.KCM;
        }
    }
    if (weekCourse.JSMC) {
        self.addressLabel.text = weekCourse.JSMC;
    }else
    {
        if (weekCourse.KSJC) {
            if (self.courseName) {
                self.addressLabel.text =self.courseName;
            }else
            {
                self.addressLabel.text = @"";
            }
        }else
        {
            self.addressLabel.text = @"";

        }
    }
    //纯单双周
    if (weekCourse.haveLesson) {
        if (weekCourse.haveLessonWeekArr.count==1) {
            self.circleLabel.text= [NSString stringWithFormat:@"第%@周",weekCourse.haveLessonWeekArr[0]];

        }
        if (weekCourse.isDoubleWeek&&!weekCourse.noDoubleWeek) {
            if (weekCourse.doubleWeek) {
                self.circleLabel.text= [NSString stringWithFormat:@"%@-%@(双周)",weekCourse.haveLessonWeekArr[0],weekCourse.haveLessonWeekArr[weekCourse.haveLessonWeekArr.count-1]];
            }
            else{
                self.circleLabel.text= [NSString stringWithFormat:@"%@-%@(单周)",weekCourse.haveLessonWeekArr[0],weekCourse.haveLessonWeekArr[weekCourse.haveLessonWeekArr.count-1]];
            }
        }
        //单双周加混合排列
        else if (weekCourse.isDoubleWeek&&weekCourse.noDoubleWeek){
            if (weekCourse.doubleWeek) {
                self.circleLabel.text = [NSString stringWithFormat:@"%@-%@(双周),%@-%@周",weekCourse.haveLessonWeekArr[0],weekCourse.haveLessonWeekArr[weekCourse.lastDoubleWeekNum],weekCourse.haveLessonWeekArr[weekCourse.lastDoubleWeekNum+1],weekCourse.haveLessonWeekArr[weekCourse.haveLessonWeekArr.count-1]];
            }
            else{
                self.circleLabel.text = [NSString stringWithFormat:@"%@-%@(单周),%@-%@周",weekCourse.haveLessonWeekArr[0],weekCourse.haveLessonWeekArr[weekCourse.lastDoubleWeekNum],weekCourse.haveLessonWeekArr[weekCourse.lastDoubleWeekNum+1],weekCourse.haveLessonWeekArr[weekCourse.haveLessonWeekArr.count-1]];
            }
            
        }else if (!weekCourse.isDoubleWeek&&weekCourse.noDoubleWeek){
            //是连续周数
            if (weekCourse.isSerialWeek&&!weekCourse.NoSerialWeek) {
                
                self.circleLabel.text = weekCourse.SKZC?[NSString stringWithFormat:@"%@-%@周",weekCourse.haveLessonWeekArr[0],weekCourse.haveLessonWeekArr[weekCourse.haveLessonWeekArr.count-1]]:nil;
            }
            //不只是连续周数
            else if(weekCourse.isSerialWeek&&weekCourse.NoSerialWeek)
            {
                //断续周数较多的情况  比如1-5周 6-13周  14-17周这种情况
                if (weekCourse.breakNumArr.count>1) {
                    NSMutableString *ms = [NSMutableString string];
                    NSString *text;
                    for (int i = 0; i<weekCourse.breakNumArr.count;i++) {
                        if (i==0) {
                            [ms appendFormat:@"%@-%@周,",weekCourse.haveLessonWeekArr[0],weekCourse.breakNumArr[i]];
                        }else{
                            int fNum =[weekCourse.breakNumArr[i-1] intValue];
                            int secNum = [weekCourse.breakNumArr[i] intValue];
                            [ms appendFormat:@"%@-%@周",weekCourse.haveLessonWeekArr[fNum],weekCourse.haveLessonWeekArr[secNum-1]];
                            text = [NSString stringWithFormat:@"%@,%@-%@周",ms,weekCourse.haveLessonWeekArr[secNum],weekCourse.haveLessonWeekArr[weekCourse.haveLessonWeekArr.count-1]];
                        }
                    }
                    self.circleLabel.text = weekCourse.SKZC?text:nil;
                }
                else{
                    self.circleLabel.text = weekCourse.SKZC?[NSString stringWithFormat:@"%@-%@周,%@-%@周",weekCourse.haveLessonWeekArr[0],weekCourse.haveLessonWeekArr[weekCourse.breakSerialWeekNum-1],weekCourse.haveLessonWeekArr[weekCourse.breakSerialWeekNum],weekCourse.   haveLessonWeekArr[weekCourse.haveLessonWeekArr.count-1]]:nil;
                }
            }
        }
    }
    if (weekCourse.haveLesson) {
        if (weekCourse.SKLS) {
            self.teacher.text =[NSString stringWithFormat:@"%@", weekCourse.SKLS];
        }else
        {
            self.teacher.hidden = YES;
            self.teacherNameL.hidden = YES;
        }
        for (int i = 0; i<widArr.count; i++) {
            NSString *KSJC = [NSString stringWithFormat:@"%@",weekCourse.KSJC];
            if ([KSJC isEqualToString: widArr[i]]) {
                self.startTime = [kssjDic objectForKey:KSJC];
                int num =[weekCourse.JSJC intValue]-[weekCourse.KSJC intValue]+1;
                //大于一节时重新计算上课的时间以及下课的时间
                if (num>1) {
                    num = num+[KSJC intValue]-1;
                    NSString *JssNum = [NSString stringWithFormat:@"%d",num];
                    self.endTime = [jssjDic objectForKey:JssNum];
                }else{
                self.endTime = [jssjDic objectForKey:KSJC];
                }
            }
        }
        self.courseTime.text = [NSString stringWithFormat:@"%@-%@",_startTime,_endTime];
        if ([_startTime isEqual:[NSNull null]]||[_endTime isEqual:[NSNull null]]) {
            self.courseTime.text =@"";
        }
        
        return;
    }
    self.teacher.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.seaptearImage.backgroundColor = Color_Gray;
       if (_weekCourse.haveLesson) {
        
        self.addressIcon.hidden = NO;
        self.capterLabel.numberOfLines = 0;
           self.teacher.numberOfLines = 0;
        self.circleLabel.numberOfLines = 0;
        self.capterLabel.font = Small_TitleFont;
        self.addressLabel.font = Small_TitleFont;
        self.circleLabel.font = Small_TitleFont;
        self.courseTime.font = Small_TitleFont;
        self.courseNameLabel.font = Small_TitleFont;
        self.teacher.font = Small_TitleFont;
        self.courseAddressL.font = Small_TitleFont;
        self.courseNameL.font = Small_TitleFont;
        self.courseTimeL.font = Small_TitleFont;
        self.teacherNameL.font = Small_TitleFont;
        
        self.backgroundColor = self.baseColor;
        self.capterLabel.textColor = Color_Black;
        self.addressLabel.textColor = Color_Gray;
        self.courseNameL.textColor = Color_Gray;
        self.teacher.textColor = Color_Gray;
        self.courseTime.textColor= Color_Gray;
        self.courseTimeL.textColor = Color_Gray;
        self.courseAddressL.textColor = Color_Gray;
        self.courseNameLabel.textColor  = Color_Gray;
        self.circleLabel.textColor = Color_Gray;
        self.teacherNameL.textColor = Color_Gray;

    } else{
        self.teacherNameL.hidden = YES;
        self.courseAddressL.hidden = YES;
        self.courseNameL.hidden = YES;
        self.courseTimeL.hidden = YES;
        self.addressIcon.hidden = YES;
        self.courseTime.hidden = YES;
        CGRect frame = self.capterLabel.frame;
        int y = (self.bounds.size.height - frame.size.height)/2;
        frame.origin.y = y;
        self.capterLabel.frame = frame;
        self.capterLabel.numberOfLines = 3;
        self.capterLabel.font = Title_Font;
        self.capterLabel.textColor = Color_Black;

    }
    
}

@end
