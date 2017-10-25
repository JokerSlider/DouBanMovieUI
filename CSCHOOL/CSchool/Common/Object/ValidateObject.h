//
//  ValidateObject.h
//  CSchool
//
//  Created by 左俊鑫 on 16/10/10.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateObject : NSObject

/**
 *  判断手机号
 *
 *  @param mobileNum 判断的内容
 *
 *  @return
 */
+ (BOOL)validateMobile:(NSString *)mobileNum;

/**
 *  判断字符是否为数字
 *
 *  @param number
 *
 *  @return 
 */
+ (BOOL)validateNumber:(NSString*)number;

/**
 查询机型

 @return 返回机型名称
 */
+ (NSString *)getDeviceName;

@end
