//
//  SendImageProgressView.h
//  CSchool
//
//  Created by mac on 17/8/25.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendImageProgressView : UIView


+ (SendImageProgressView *)shared;

+(void)removeAlert:(NSString *)word;

+(void)show:(NSString *)word onView:(UIView *)superView;

+(void)showString:(NSString *)word;

@end
