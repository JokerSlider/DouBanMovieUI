//
//  JohnAlertManager.h
//  顶部提示框
//
//  Created by YuanQuanTech on 2016/11/11.
//  Copyright © 2016年 John Lai. All rights reserved.
//
//二次封装，可将头文件放入pch文件中，方便全局调用
#import <Foundation/Foundation.h>
#import "JohnTopAlert.h"
@interface JohnAlertManager : NSObject

+ (void)showSuccessAlert:(NSString *)msg andTitle:(NSString *)title ;

+ (void)showFailedAlert:(NSString *)msg andTitle:(NSString *)title;

+ (void)showSuccessAlert:(NSString *)msg andTitle:(NSString *)title AndDelegate:(id )obj;

@end
