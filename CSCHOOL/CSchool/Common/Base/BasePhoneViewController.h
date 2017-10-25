//
//  BasePhoneViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/8/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
//验证手机类型
typedef enum : NSUInteger {
    XGPayPhone, //缴费时
    XGChangePhone,   //次月切换时
} XGPhoneType;

@interface BasePhoneViewController : BaseViewController

@property (nonatomic, assign) XGPhoneType phoneType;

@end
