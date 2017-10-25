//
//  HealthPostDataManager.h
//  CSchool
//
//  Created by mac on 17/3/20.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPostDataManager : NSObject

/**
 初始化

 @return shareInstance
 */
+(id)shareInstance;

/**
 获取允许
 */
-(void)getHealthPermissons;

/**
 上传步数和卡路里
 */
-(void)sendStepNumAndColriaData;

@end
