//
//  ConfigObject.m
//  CSchool
//
//  Created by 左俊鑫 on 16/2/1.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "ConfigObject.h"

@implementation ConfigObject

static ConfigObject *_shareConfig;

+ (ConfigObject *)shareConfig{
    @synchronized ([ConfigObject class]) {
        if (_shareConfig == nil) {
            _shareConfig = [[ConfigObject alloc] init];
        }
    }
    return _shareConfig;
}

- (void)setPayInfo:(NSDictionary *)dic{
    _payInfoDic = dic;
    _isPayShowPhone = [dic[@"pay_popups"] boolValue];
    BOOL trip_popups = dic[@"trip_popups"]; //修改电话号码提示是否开启
    BOOL time_limit = dic[@"time_limit"]; //是否受时间限制1，受限制
    
    _trip1 = [dic valueForKeyPath:@"trip.trip1"];
    _trip2 = [dic valueForKeyPath:@"trip.trip2"];
    
    
    if (trip_popups) {
        if (time_limit) {
            NSTimeInterval timer = [dic[@"currenttime"] doubleValue];
            NSString *date = [self timeWithTimeIntervalString:timer];

            NSArray *arr = dic[@"time_group"];
            if ([arr containsObject:date]) {
                _isShowChangePhone = YES;
            }
        }else{
            _isShowChangePhone = YES;
        }
    }
}

- (NSString *)timeWithTimeIntervalString:(NSTimeInterval )timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeString];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (NSString *)phoneNum{
    if (!_phoneNum) {
        return @"0";
    }
    return _phoneNum;
}

- (void)clean{
    _isPayShowPhone = NO;
    _isShowChangePhone = NO;
    _trip1 = @"";
    _trip2 = @"";
    _payInfoDic = nil;
    _isGetInfo = NO;
    _phoneNum = @"0";
    _msgCodeNum = 0;
}

@end
