//
//  XGMessageModel.h
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/7.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYText.h"
@class XMPPJID;
typedef enum : NSUInteger {
    XGMsgTypeImage,
    XGMsgTypeText
} XGMsgType;

@interface XGMessageModel : NSObject

@property (nonatomic, assign) XGMsgType messageType;

@property (nonatomic, strong) XMPPJID *jid;

@property (nonatomic,assign) XMPPJID  *friendJid;

@property (nonatomic, assign) BOOL isMySend; //是不是自己发出的 YES：是

@property (nonatomic, copy) NSString *text;

@property (nonatomic, retain) UIImage *headerImage;

@property (nonatomic, copy) NSString *imageBody;

@property (nonatomic, copy) NSString *name;

@property (nonatomic,copy)  NSString *groupName;

@property (nonatomic,assign)BOOL   isGrouoChat;

@property (nonatomic,copy)NSDate *chatTime;
@end
