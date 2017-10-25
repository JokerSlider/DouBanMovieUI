//
//  TecStartSignController.h
//  CSchool
//
//  Created by mac on 17/6/30.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

typedef enum{
    StartSignType=0,//点击进入发起签到
    SignCountType=1,//签到统计
    SubSignType=2//补签
}FunctionType;

@interface TecStartSignController : BaseViewController
@property (nonatomic, assign) FunctionType chooseType; // 类型

@end
