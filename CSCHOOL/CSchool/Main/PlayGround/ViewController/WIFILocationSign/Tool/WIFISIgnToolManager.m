//
//  WIFISIgnToolManager.m
//  CSchool
//
//  Created by mac on 17/7/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WIFISIgnToolManager.h"

@implementation WIFISIgnToolManager
+(id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
-(NSString *)tranlateDateString:(NSString *)soureceData withDateFormater:(NSString *)formatter andOutFormatter:(NSString *)outFormatter
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSSSSZ"];
    [inputFormatter setDateFormat:formatter];

    NSDate* inputDate = [inputFormatter dateFromString:soureceData];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:outFormatter];
    NSString *str = [outputFormatter stringFromDate:inputDate];

    return str;
}

@end
