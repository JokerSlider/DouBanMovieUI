//
//  CourseButton.m
//  Course
//
//  Created by MacOS on 14-12-22.
//  Copyright (c) 2016年 Joker. All rights reserved.
//

#import "CourseButton.h"
#import <QuartzCore/QuartzCore.h>
#import "WeekCourse.h"

@implementation CourseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initSetting];
    }
    return self;
}

- (void)_initSetting
{
//    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.titleLabel.font = Title_Font;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.titleLabel.numberOfLines = 0;
    _classRomL = [UILabel new];
    _classNameL = [UILabel new];
    
    _classRomL.numberOfLines = 0;
    _classNameL.numberOfLines = 0;
    
    
    _classNameL.frame = CGRectMake(0, self.bounds.size.height/5, self.bounds.size.width, 40);
    _classRomL.frame = CGRectMake(0,self.bounds.size.height/4+33, self.bounds.size.width, 40);
    
    _classNameL.textColor = Color_Black;
    _classRomL.textColor = Color_Gray;
    
    _classNameL.textAlignment = NSTextAlignmentCenter;
    _classRomL.textAlignment = NSTextAlignmentCenter;
    _classNameL.font = [UIFont systemFontOfSize:11];
    _classRomL.font =[UIFont systemFontOfSize:10];
    
    [self addSubview:_classNameL];
    [self addSubview:_classRomL];
}

- (void)setWeekCourse:(WeekCourse *)weekCourse
{
    if (_weekCourse != weekCourse) {
        _weekCourse = weekCourse;
    }
    if (weekCourse.KCM) {
        if (weekCourse.KXH) {
            _courseName = [NSString stringWithFormat:@"%@[%@]",self.weekCourse.KCM,self.weekCourse.KXH];
        }else{
            _courseName = [NSString stringWithFormat:@"%@",self.weekCourse.KCM];
        }
        
    }
    _day=self.weekCourse.SKXQ;
    _startLesson = self.weekCourse.KSJC;
    _endLesson = self.weekCourse.JSJC;
    _lessonsNum=self.weekCourse.lessonsNum;
    _teacherName = self.weekCourse.SKLS;
    
    _classNameL.text =_courseName;
    if (self.weekCourse.JSMC.length==0) {
        _claRoom = @"";
        _classRomL.text = @"";

    }else{
        _claRoom = self.weekCourse.JSMC;
        _classRomL.text = [NSString stringWithFormat:@"(%@)",_claRoom];
    }
}
//重课的解决办法 
-(void)setNextCourseName:(NSString *)nextCourseName
{
    _nextCourseName = nextCourseName;
    
    _classNameL.text =[NSString stringWithFormat:@"%@&%@",_courseName,_nextCourseName];

}
-(void)setNextCourseClaName:(NSString *)nextCourseClaName
{
    _nextCourseClaName = nextCourseClaName;
    _classRomL.text = _nextCourseClaName;


}
@end
