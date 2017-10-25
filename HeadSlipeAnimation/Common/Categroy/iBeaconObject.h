//
//  iBeaconObject.h
//  prj1115
//
//  Created by ZFJ_APPLE on 15/11/20.
//  Copyright © 2015年 JiRanAsset. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^SucessBlock)(NSDictionary *IBeaconDic);

@interface iBeaconObject : NSObject<CLLocationManagerDelegate,CBCentralManagerDelegate>
@property (nonatomic, copy) SucessBlock editSucessBlock;
@property(strong,nonatomic) CLLocationManager* locationManager;
@property(strong,nonatomic) CBCentralManager* CM;

//第一次开始检测ibeacon
- (void)startScanIbeacon;

//停止检索ibeacon
- (void)stopScanIbeacon;

@end
