//
//  XGChatExpressionView.m
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/13.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import "XGChatExpressionView.h"
#import "XGChatBar.h"

@implementation XGChatExpressionView
{
    DDEmotionScrollView *_expressionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews{
    _expressionView = [[DDEmotionScrollView alloc] initWithDDEmotionSelectBlock:^(NSString *emotionName) {
        if ([emotionName isEqualToString:@"/删除"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:XGExpressionNotification object:@{@"type":@(XGExpDelete)}];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:XGExpressionNotification object:@{@"type":@(XGExpQQNormal),@"expKey":emotionName}];
        }
    }];
    
    CGRect frame = _expressionView.frame;
    frame.origin.y = 0;
    _expressionView.frame = frame;
    [self addSubview:_expressionView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 35)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setBackgroundColor:[UIColor redColor]];
    sendButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-65, 0, 65, 35);
    [sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendButton];
}

- (void)sendButtonAction:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:XGExpressionNotification object:@{@"type":@(XGExpSend)}];
}

@end
