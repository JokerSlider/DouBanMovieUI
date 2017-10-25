//
//  MessageFrameModel.h
//  微信
//
//  Created by Think_lion on 15/6/21.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageModel;


@interface MessageFrameModel : NSObject


@property (nonatomic,strong)  MessageModel  *messageModel;  //传递模型

//时间的frame
@property (nonatomic,assign,readonly) CGRect timeF;
//头像的frame
@property (nonatomic,assign,readonly) CGRect headF;
//内容的frame
@property (nonatomic,assign,readonly) CGRect contentF;
//单元格的高度
@property (nonatomic,assign,readonly) CGFloat cellHeight;
//聊天单元的frame
@property (nonatomic,assign,readonly) CGRect  chatF;

@end
