//
//  ToolMannger.m
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/23.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ToolMannger.h"
#import "LZProgressView.h"
#import <CoreLocation/CoreLocation.h>
@interface  ToolMannger()<CLLocationManagerDelegate>
@property (nonatomic,strong) LZProgressView *progressView;

@property (nonatomic,strong) CLLocationManager *locationManager;

@end
@implementation ToolMannger
static  ToolMannger *instance;

+ (ToolMannger *) shareInstance {
    @synchronized([ToolMannger class]) {
        if (instance == nil) {
            instance = [[ToolMannger alloc] init];
        }
    }
    return instance;
}



- (BOOL)isChinese:(NSString *)obj
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:obj];
}

-(void)showProgressView
{
    
    NSArray *colors = @[
                        [UIColor purpleColor],
                        [UIColor orangeColor],
                        [UIColor cyanColor],
                        [UIColor redColor],
                        [UIColor greenColor],
                        [UIColor blueColor],
                        [UIColor yellowColor]
                        ];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.progressView = [[LZProgressView alloc] initWithFrame:CGRectMake(0, 0, 26, 26) andLineWidth:3.0 andLineColor:colors];
    
    self.progressView.center = window.center;
    [window addSubview:self.progressView];
}
-(void)dissmissProgressView
{
    [UIView animateWithDuration:1.5 animations:^{
        [self.progressView removeFromSuperview];
    } completion:^(BOOL finished) {
        self.progressView.alpha = self.progressView.alpha--;

    }];
}
#pragma mark  定位使用 
//开始定位
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue] >8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        _locationManager.allowsBackgroundLocationUpdates =YES;
    }
    [self.locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *newLocation = locations[0];
    
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    NSString *longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSString *latitude  = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError * _Nullable error) {
        
        
        NSString *placelocality=@"定位失败";
        NSString *subLocality=@"";
        NSString *thoroughfare=@"";
        NSString *placeName=@"";

        for (CLPlacemark *place in placemarks) {
            placelocality = place.locality?place.locality:@"定位失败";
            subLocality = place.subLocality?place.subLocality:@"";
            thoroughfare = place.thoroughfare?place.thoroughfare:@"";
            placeName = place.name?place.name:@"";
            NSLog(@"name,%@",place.name);                      // 位置名
            
            NSLog(@"thoroughfare,%@",place.thoroughfare);      // 街道
            
            NSLog(@"subThoroughfare,%@",place.subThoroughfare);// 子街道
            
            NSLog(@"locality,%@",place.locality);              // 市
            
            NSLog(@"subLocality,%@",place.subLocality);        // 区
            
            NSLog(@"country,%@",place.country);                // 国家
//            NSString *locationName = [NSString stringWithFormat:@"%@%@%@%@",place.locality,place.subLocality,place.thoroughfare,place.name];
        }
        if (self.loctationBlock) {
            self.loctationBlock(@[longitude,latitude],@[placelocality,subLocality,thoroughfare,placeName]);
        }
    }];
    
}


@end
