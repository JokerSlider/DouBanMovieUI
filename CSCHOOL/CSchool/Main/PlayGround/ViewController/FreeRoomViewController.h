//
//  FreeRoomViewController.h
//  XGCourse
//
//  Created by 左俊鑫 on 16/4/14.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FreeRoomViewController : BaseViewController

@property (nonatomic, strong) NSString *requestTimeStr;

@property (nonatomic, strong) NSString *buildNoStr;

@property (nonatomic, assign) NSInteger floorNum;

@property (nonatomic, copy) NSString *buildName;

@end
