//
//  XGChatBar.h
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/7.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"


/**表情相关通知，输入删除表情，选择表情时 */
#define XGExpressionNotification @"XGExpressionNotification"

//聊天条按钮
typedef enum : NSUInteger {
    XGChatBarExpression, //表情
    XGChatBarPhoto,   //照片
    XGChatBarCamera   //相机
} XGChatBarButtonType;

//表情键盘事件
typedef enum : NSUInteger {
    XGExpQQNormal,  //普通表情
    XGExpDelete,    //删除
    XGExpSend       //发送
} XGExpressionType;

typedef void(^ChatBarButtonClick)(XGChatBarButtonType chatBarButtonType);

@interface XGChatBar : UIView


@property (nonatomic, retain) YYTextView *textView;

@property (nonatomic, assign, readonly) CGFloat normalHeight;

@property (nonatomic, copy) ChatBarButtonClick chatBarButtonClick;

@end
