//
//  iBeaconObject.m
//  prj1115
//
//  Created by ZFJ_APPLE on 15/11/20.
//  Copyright © 2015年 JiRanAsset. All rights reserved.
//

#import "iBeaconObject.h"

#define IOS8A   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7A   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

//需要提供当前登录用户的uuid 重要uuid必须要传
#define beaconUUID @"FDA50693-A4E2-4FB1-AFCF-C6EB07647824"
#define palcomm [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc]initWithUUIDString:beaconUUID] identifier:@"palcomm"]

@implementation iBeaconObject

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self judgeVersion];
        [self initServer];
    }
    return self;
}


#pragma mark -- 初始化ibeacon服务
- (void)initServer
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    if (IOS8A)
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - 定位服务代理相关
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways){
        [self.locationManager startMonitoringForRegion:palcomm];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", [error description]);
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:palcomm];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:palcomm];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    region.notifyEntryStateOnDisplay = YES;
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    //遍历搜索到的beacon
    for (CLBeacon* beacon in beacons)
    {
        NSString *UUIDString = beacon.proximityUUID.UUIDString;
        NSString *major = [NSString stringWithFormat:@"%@",beacon.major];
        NSString *minor = [NSString stringWithFormat:@"%@",beacon.minor];
        NSString *proximity = nil;
        if(beacon.proximity==CLProximityUnknown)
        {
            proximity = @"CLProximityUnknown";
        }
        else if(beacon.proximity==CLProximityImmediate)
        {
            //在几厘米内
            proximity = @"CLProximityImmediate";
        }
        else if(beacon.proximity==CLProximityNear)
        {
            //在几米内
            proximity = @"CLProximityNear";
        }
        else if(beacon.proximity==CLProximityFar)
        {
            //超过10米外
            proximity = @"CLProximityFar";
        }
        CLLocationAccuracy accuracy = beacon.accuracy;
        NSInteger rssi = beacon.rssi;
        
        //ibeacon 设备相关信息
        NSLog(@"UUIDString == %@",UUIDString);
        NSLog(@"major == %@",major);
        NSLog(@"minor == %@",minor);
        NSLog(@"proximity == %@",proximity);
        NSLog(@"accuracy == %f",accuracy);
        NSLog(@"rssi == %ld",(long)rssi);
        NSLog(@"---------------------------------");
        NSString *majorSix = [self getHexByDecimal:[major integerValue]];
        NSString *minorSix = [self getHexByDecimal:[minor integerValue]];

        NSMutableDictionary *dic  = [NSMutableDictionary dictionary];
        [dic setValue:@"201511101102" forKey:@"userid"];
        [dic setValue:UUIDString forKey:@"uuid"];
        [dic setValue:majorSix forKey:@"major"];
        [dic setValue:minorSix forKey:@"minor"];
        [dic setValue:proximity forKey:@"proximity"];
        [dic setValue:[NSString stringWithFormat:@"%f",accuracy] forKey:@"accuracy"];
        [dic setValue:[NSString stringWithFormat:@"%ld",rssi] forKey:@"rssi"];
        [dic setValue:[NSString stringWithFormat:@"%f",[self calcDistByRSSI:rssi]] forKey:@"distance"];
        [dic setValue:@"sdizu" forKey:@"schoolCode"];

        if (_editSucessBlock) {
            _editSucessBlock(dic);
        }
    }
}
//计算距离
- (float)calcDistByRSSI:(float)rssi
{
    int iRssi = abs(rssi);
    float power = (iRssi-59)/(10*2.0);
    return pow(10, power);
}
/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

#pragma mark - 第一次开始检测ibeacon
-(void)startScanIbeacon
{
    [self.locationManager startRangingBeaconsInRegion:palcomm];
    [self.locationManager startMonitoringForRegion:palcomm];
    [self.locationManager requestStateForRegion:palcomm];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - 停止检索ibeacon
-(void) stopScanIbeacon{
    [self.locationManager stopRangingBeaconsInRegion:palcomm];
}

#pragma mark - 重新开始检索ibeacon
-(void) reStartScanIbeacon{
    [self.locationManager startRangingBeaconsInRegion:palcomm];
}

#pragma mark - 判断系统版本是否可以使用
- (void)judgeVersion
{
    if (!IOS7A&&!IOS8A)
    {
        NSLog(@"抱歉，导航还不支持ios7以下版本操作系统，请升级以后再尝试!");
        
        return;
    }
    else
    {
        //蓝牙可以用 监听蓝牙状态
        self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}

#pragma mark - 提示蓝牙打开
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message = nil;
    switch (central.state) {
        case 1:
            message = @"该设备不支持蓝牙功能,请检查系统设置";
            break;
        case 2:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 3:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 4:
            message = @"该设备尚未打开蓝牙,请在设置中打开";
            break;
        case 5:
            message = @"蓝牙已经成功开启,请稍后再试";
            break;
        default:
            break;
    }
    if(message!=nil&&message.length!=0)
    {
        NSLog(@"message == %@",message);
    }
}

@end
