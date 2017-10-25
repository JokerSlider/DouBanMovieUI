//
//  UITabBar+MyTabbar.h
//  CSchool
//
//  Created by mac on 17/2/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (MyTabbar)
- (void)showBadgeOnItemIndex:(NSInteger)index;   ///<显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index;  ///<隐藏小红点
@end
