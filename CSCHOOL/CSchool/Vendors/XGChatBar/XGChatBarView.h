//
//  XGChatBarView.h
//  XGChatBar
//
//  Created by mac on 15/11/24.
//  Copyright (c) 2015年 xin. All rights reserved.
//

#define kMaxHeight 120.0f
#define kMinHeight 45.0f
#define kFunctionViewHeight 210.0f

#import <UIKit/UIKit.h>

@class XGChatBarView;

@protocol XGChatBarViewDelegate <NSObject>

/**
 *  发送消息代理
 *
 *  @param chatBar self
 *  @param message 发送的内容
 */
- (void)chatBar:(XGChatBarView *)chatBar sendMessage:(NSString *)message;

/**
 *  chatBarFrame改变回调
 *
 *  @param chatBar
 */
- (void)chatBarFrameDidChange:(XGChatBarView *)chatBar frame:(CGRect)frame;


@end


@interface XGChatBarView : UIView

@property (weak, nonatomic) id<XGChatBarViewDelegate> delegate;

- (void)addAtNameMessage:(NSString *)nameString;

@end
