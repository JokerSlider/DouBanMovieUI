//
//  MessageModel.h
//  微信
//
//  Created by Think_lion on 15/6/20.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy) NSString *body; //消息的内容
@property (nonatomic, copy) NSAttributedString *attributedBody;

@property (nonatomic,copy) NSString *time ;//消息的时间
@property (nonatomic,assign) BOOL isCurrentUser;  //如果是YES就是当前用户  如果是NO就是聊天的用户
@property (nonatomic,copy) NSString *from; //谁发的消息
@property (nonatomic,copy) NSString *to ;//发给谁的消息
//聊天用户的头像 
@property (nonatomic,weak) UIImage *otherPhoto;
//用户自己的头像
@property (nonatomic,strong) NSData *headImage;
//是否隐藏时间
@property (nonatomic,assign) BOOL hiddenTime;
@end
