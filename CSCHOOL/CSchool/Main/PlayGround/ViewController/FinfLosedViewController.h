//
//  FinfLosedViewController.h
//  CSchool
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
#import "FindViewController.h"
#import "ReceiveViewController.h"

@interface FinfLosedViewController : BaseViewController

@property (nonatomic, retain) FindViewController *news;//找东西

@property (nonatomic, retain) ReceiveViewController *news2;//找失主

@property (nonatomic,copy)  NSString *funcType;//功能类型

@end
