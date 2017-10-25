//
//  ToolMannger.h
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/23.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LocationBlock)(NSArray *objArr,NSArray *locationNameArr);

@interface ToolMannger : NSObject

@property (nonatomic, copy) LocationBlock loctationBlock;

@property (nonatomic,copy)NSString *userAgent;

/**
 初始化
 
 @return shareInstance
 */
+(ToolMannger *)shareInstance;


/**
 判断是否是汉字

 @param obj 字符串
 @return 返回BOOl
 */
- (BOOL)isChinese:(NSString *)obj;

/**
 展示进度
 */
-(void)showProgressView;


/**
 隐藏进度
 */
-(void)dissmissProgressView;


-(void)startLocation;

@end
