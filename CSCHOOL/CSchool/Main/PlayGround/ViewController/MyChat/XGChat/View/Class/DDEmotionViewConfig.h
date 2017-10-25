//
//  DDEmotionViewConfig.h
//  EmotionView
//
//  Created by lovelydd on 15/7/2.
//  Copyright (c) 2015年 xiaomutou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//[UIScreen mainScreen].bounds.size.width
#define DDScreenWidth       [UIScreen mainScreen].bounds.size.width
#define DDScreenHeight      [UIScreen mainScreen].bounds.size.height
#define DDEmotionBundlePath  [[NSBundle mainBundle] pathForResource:@"QQIcon" ofType:@"bundle"]

static CGFloat DDEmotionItemWidth   = 42.0f;
static CGFloat DDEmotionItemHeigth  = 45.0f;


static NSString *const DDEmotionPlistName = @"QQIcon.plist";

static NSInteger kDDEmotionMagnifierImageTag  = 2013;
