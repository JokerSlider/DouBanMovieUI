//
//  WifiSignEditController.h
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^FinishEditBlock)(NSArray *modelArr);
@interface WifiSignEditController : BaseViewController
@property (nonatomic, copy) FinishEditBlock finishEditBlock;
@property (nonatomic,copy)NSMutableArray *modelArr;
@end
