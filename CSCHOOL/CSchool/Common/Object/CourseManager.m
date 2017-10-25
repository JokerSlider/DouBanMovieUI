//
//  CourseManager.m
//  CSchool
//
//  Created by 左俊鑫 on 16/4/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "CourseManager.h"
#import "NSDate+Extension.h"

@implementation CourseManager
{
    NSMutableDictionary *_timeDic;
}

-(NSString *)getCourseNum{
   return [self startCourseNum];
}

- (NSString *)startCourseNum{
    
    NSArray *timeArr = @[@"7.50",@"8.20",@"8.30",@"9.05",@"9.50",@"10.00",@"10.45",@"11.15",@"11.20",@"12.05",@"13.39",@"14.20",@"14.35",@"15.10",@"15.25",@"16.05",@"16.10",@"17.00",@"18.00",@"19.15",@"19.20",@"20.15",@"20.20",@"21.15"];
    
    _timeDic = [NSMutableDictionary dictionary];

    for (int i =0; i<[timeArr count]; i++) {
        NSInteger a = [timeArr[i] integerValue];
        NSString *key = [NSString stringWithFormat:@"%@|%d,%@",timeArr[i],i/2,i%2==0?@"s":@"e"];
        [_timeDic setObject:@(a) forKey:key];
    }
    
    return [self getCourseNum:[NSDate date] isNow:YES];
}

- (NSString *)getCourseNum:(NSDate *)date isNow:(BOOL)isNow{
    
    NSInteger hour = [date hour];
    NSInteger min=[date minute];
    
    isNow?(min=[date minute]):(min=0);
    
    double nowTime = hour+min*0.01;
    
    NSArray *arr = [_timeDic allKeysForObject:@(hour)];
    
    NSMutableArray *hourArr = [NSMutableArray arrayWithArray:arr];
    [hourArr sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSArray *strArr = [obj1 componentsSeparatedByString:@"|"];
        double a = [strArr[0] doubleValue];
        NSArray *strArrB = [obj1 componentsSeparatedByString:@"|"];
        double b = [strArrB[0] doubleValue];
        if (a < b) {
            return NSOrderedAscending;
        }else if (a == b){
            return NSOrderedSame;
        }else{
            return NSOrderedDescending;
        }
        
    }];
    
    for (NSString *str in hourArr) {
        NSArray *strArr = [str componentsSeparatedByString:@"|"];
        double a = [strArr[0] doubleValue];
        if (nowTime < a) {
            return strArr[1];
        }
    }
    
    int hourNum = 0;
    hourArr>0?(hourNum=1):(hourNum=-1);
    return [self getCourseNum:[date offsetHours:hourNum] isNow:NO];

}

@end
