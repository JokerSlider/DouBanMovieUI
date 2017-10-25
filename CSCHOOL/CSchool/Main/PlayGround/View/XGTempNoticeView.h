//
//  XGTempNoticeView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/6/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XGNoticeViewBlock)(void);

@interface XGTempNoticeView : UIView


@property (nonatomic, strong) XGTempNoticeView *noticeBlock;

/**
 *  初始化 显示存留时间
 *
 *  @param seconds 存留时间
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame WithText:(NSString *)text WithFlashTime:(NSInteger)seconds;

@end
