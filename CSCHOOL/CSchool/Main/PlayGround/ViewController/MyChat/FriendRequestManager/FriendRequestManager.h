//
//  FriendRequestManager.h
//  CSchool
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendRequestManager : NSObject

+(id)shareInstance;

/**
处理发送的消息通知  转为model并存储到fmdb中
 
 @param handler 返回成功或者失败
 */
- (void)handleRequestMessageWithDic:(NSDictionary *)dic andisSuccess:(BOOL)isSuccess;


@end
