//
//  XGTempNoticeView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/6/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "XGTempNoticeView.h"

@implementation XGTempNoticeView
{
    NSInteger _seconds;
    NSString *_text;
}

- (instancetype)initWithFrame:(CGRect)frame WithText:(NSString *)text WithFlashTime:(NSInteger)seconds
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.alpha = 0.8;
        _seconds = seconds;
        _text = text;
        [self createView];
        [self performSelector:@selector(noticeMiss) withObject:nil afterDelay:seconds];
    }
    return self;
}

- (void)createView{
    
    UILabel *textLabel = [UILabel new];
    textLabel.text = _text;
    textLabel.font = Title_Font;
    textLabel.textColor = Color_Black;
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:textLabel];
    
}

- (void)noticeMiss{
    self.clipsToBounds = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    }];
    if (_noticeBlock) {
//        _noticeBlock();
    }
}

@end
