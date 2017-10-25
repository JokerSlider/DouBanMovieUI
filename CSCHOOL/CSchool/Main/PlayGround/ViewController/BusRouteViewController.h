//
//  BusRouteViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/12/16.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
#import "XGBusRouteView.h"

@interface BusRouteViewController : BaseViewController

@property (nonatomic, copy) NSString *changeBusID;

@property (nonatomic, retain) XGBusRouteView *busView;

- (void)startTimer;

- (void)stopTimer;

@end
