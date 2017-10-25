//
//  JohnAlertManager.m
//  顶部提示框
//
//  Created by YuanQuanTech on 2016/11/11.
//  Copyright © 2016年 John Lai. All rights reserved.
//

#import "JohnAlertManager.h"
#import "UIColor+HexColor.h"
@implementation JohnAlertManager

+ (void)showSuccessAlert:(NSString *)msg andTitle:(NSString *)title{
    JohnTopAlert *alert = [[JohnTopAlert alloc]init];
    [alert showAlertMessage:msg andTitle:title alertType:SuccessAlert];
    /**可在此定制背景颜色和显示时间**/
//     alert.alertBgColor = [UIColor colorWithHexString:NavBgColor];
    alert.alertBgColor =RGB(60, 174, 255);
    //    alert.alertBgColor =[UIColor colorWithHexString:@"#d4237a"];
    alert.alertTextColor = [UIColor whiteColor];
    alert.alertShowTime = 2.0f;
    [alert alertShow];
}

+ (void)showFailedAlert:(NSString *)msg andTitle:(NSString *)title{
    JohnTopAlert *alert = [[JohnTopAlert alloc]init];
    [alert showAlertMessage:msg andTitle:title alertType:FailedAlert];
     alert.alertBgColor =RGB(60, 174, 255);
//    alert.alertBgColor =[UIColor colorWithHexString:@"#d4237a"];
    alert.alertTextColor = [UIColor whiteColor];
     alert.alertShowTime = 2.0f;
    [alert alertShow];
}
#pragma mark 带代理事件的顶部弹窗
+ (void)showSuccessAlert:(NSString *)msg andTitle:(NSString *)title AndDelegate:(id )obj
{
    JohnTopAlert *alert = [[JohnTopAlert alloc]init];
    [alert showAlertMessage:msg andTitle:title alertType:FailedAlert];
    alert.alertBgColor =RGB(60, 174, 255);
    //                  ---------                           //
//    alert.alertBgColor =[UIColor colorWithHexString:@"#d4237a"];
    alert.alertTextColor = [UIColor whiteColor];
    //                  ---------                           //
    alert.alertShowTime = 2.0f;
    alert.delegate = obj;
    [alert alertShow];
}
@end
