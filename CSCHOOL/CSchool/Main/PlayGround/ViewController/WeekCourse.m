//
//  WeekCourse.m
//  ismarter2.0_sz
//
//  Created by MacOS on 14-12-25.
//
//

#import "WeekCourse.h"
#import "DateUtils.h"

@implementation WeekCourse

- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    
    if (self = [super init]) {
        if (dic != nil) {
            self.XH = [dic objectForKey:@"XH"];
            self.XNXQDM = [dic objectForKey:@"XNXQDM"];
            self.SKXQ = [dic objectForKey:@"SKXQ"];
            self.KSJC = [dic objectForKey:@"KSJC"];
            self.JSJC = [dic objectForKey:@"JSJC"];
            self.KCH = [dic objectForKey:@"KCH"];
            self.KCM = [dic objectForKey:@"KCM"];
            self.JSMC = [dic objectForKey:@"JSMC"];
            self.SKLS = [dic objectForKey:@"SKLS"];
            self.SKZC = [dic objectForKey:@"SKZC"];
            self.KXH = [dic objectForKey:@"KXH"];
            int startL =[self.KSJC intValue];
            int endL= [self.JSJC intValue];
            self.lessonsNum=[NSString stringWithFormat:@"%d",endL-startL+1];
            self.weeksArray= [DateUtils getWeekIsHaveClassArray:dic[@"SKZC"]];

            NSMutableArray *numberArr = [NSMutableArray array];
            int index=-1; //首次出现的位置
            for (int i =0; i<self.weeksArray.count; i++) {
                if (index==-1) {
                    //找到课程开始日期
                    if ([self.weeksArray[i] isEqualToString:@"1"]) {
                        index =i+1;
                    }
                }
                //将有课的周数添加到数组（）
                if ([self.weeksArray[i] isEqualToString:@"1"]) {
                    [numberArr addObject:self.weeksArray[i]];
                }
            }

        }
    }
        int oneIndex;
//        _haveLessonWeekArr = [NSMutableArray array];
        NSMutableArray *oneIndexArr = [NSMutableArray array];
        for (int i = 0; i<self.weeksArray.count; i++) {
        //如果是1的话记录下位置和数目
        if ([self.weeksArray[i] isEqualToString:@"1"]) {
            oneIndex=i+1;
            NSString *one = [NSString stringWithFormat:@"%d",oneIndex];
            [oneIndexArr addObject:one];
        }
    }
        self.breakNumArr = [NSMutableArray array];
        for (int i = 0; i<oneIndexArr.count; i++) {
        BOOL isDouble;
        if (oneIndexArr.count<=1) {
            _haveLessonWeekArr =oneIndexArr;
        }else{
        if (i==0) {
            isDouble =[oneIndexArr[i+1] intValue]==[oneIndexArr[i] intValue]+2;
        }else{
            isDouble=[oneIndexArr[i] intValue]==[oneIndexArr[i-1] intValue]+2;
        }
        if (isDouble&&!_noDoubleWeek) {
                _isDoubleWeek = YES;
                //找到最后一个是单双周的周数
                self.lastDoubleWeekNum = i;
                //判断是单周还是双周 并且取到上课的周数
                if ([oneIndexArr[0] intValue]%2==0) {
                    //双周
                    _doubleWeek=YES;
                }else
                {
                    //单周
                    _doubleWeek = NO;
                }
          
        }else{
            //不是单双周的
            _noDoubleWeek = YES;
            //是否是纯连续的  1-24周
            BOOL isSerial;
            if (i==0) {
                isSerial =[oneIndexArr[1] intValue]==[oneIndexArr[0] intValue]+1;
            }else{
                isSerial =[oneIndexArr[i] intValue]==[oneIndexArr[i-1] intValue]+1;
            }
            if (isSerial ) {
                _isSerialWeek = YES;
            }else{
                _NoSerialWeek = YES;
                //找出断点的周数
                [self.breakNumArr addObject:[NSString stringWithFormat:@"%d",i]];
                self.breakSerialWeekNum = i;

            }
        }
            //现在数组中的数据是上课的周数  我们要做的是区分单双周以及连续的周数的情况
            _haveLessonWeekArr = oneIndexArr;
        }
            
    }
    
    return self;
}
@end
