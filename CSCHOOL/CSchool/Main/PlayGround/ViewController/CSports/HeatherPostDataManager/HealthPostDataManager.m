//
//  HealthPostDataManager.m
//  CSchool
//
//  Created by mac on 17/3/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "HealthPostDataManager.h"
#import "HealthManager.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation HealthPostDataManager
static  HealthPostDataManager *instance;

+ (HealthPostDataManager *) shareInstance {
    @synchronized([HealthPostDataManager class]) {
        if (instance == nil) {
            instance = [[HealthPostDataManager alloc] init];
            [instance getHealthPermissons];

        }
    }
    return instance;
}
-(void)getHealthPermissons
{
    [[HealthManager shareInstance]getPermissions:^(BOOL value, NSError *error) {
        if (value) {
            
        }else{
            NSLog(@"尚未获取权限");
        }
    }];
    
}

-(void)sendStepNumAndColriaData
{
    //大于某个时间点就不再上传数据
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr1 = [formatter1 stringFromDate:now];
    NSArray *array=[dateStr1 componentsSeparatedByString:@" "];
    
    NSArray *array1=[[array objectAtIndex:1] componentsSeparatedByString:@":"];
    //晚上九点半点之后不再上传数据
    if ([[array1 objectAtIndex:0] intValue]>=30) {//&[[array1 objectAtIndex:1]intValue]>=30
        
        return;
    }
    //晚上八点之前继续上传数据
    else{
        [[HealthManager shareInstance] getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
            
            NSLog(@"当天行走步数 = %.2lf",value);
            /*
             value = 300
             1公里约合1333步
             公里数：diistance = 步数/1333
            跑步消耗热量 = 体重（60kg）X diistance X 1.036
             */
            int  caloriNum = 60 *(value/1333)*1.036;
            NSString *caloriValue = [NSString stringWithFormat:@"%d",caloriNum];
            NSString *stepNum =[NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%lf",value] intValue]];
            [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"uploadStepNumWithCalorie",@"step":stepNum,@"calorie":caloriValue,@"userid":[AppUserIndex GetInstance].role_id} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject[@"msg"]);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
                //[JohnAlertManager showFailedAlert:error[@"msg"] andTitle:@"上传步数失败"];
            }];
        }];
    }
}
#pragma clang diagnostic pop

@end
