//
//  SchoolMapRouteViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/7/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
@interface SchoolMapRouteViewController : BaseViewController

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviWalkManager *driveManager;

@end
