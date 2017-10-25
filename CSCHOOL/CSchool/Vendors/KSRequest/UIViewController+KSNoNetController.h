//
//  UIViewController+KSNoNetController.h
//  Test
//
//  Created by KS on 15/11/25.
//  Copyright © 2015年 xianhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSNoNetView.h"
#import "FairlView.h"

@interface UIViewController (KSNoNetController)<KSNoNetViewDelegate,FairlViewDelegate>

/**
 *  为控制器扩展方法，刷新网络时候执行，建议必须实现
 */
- (void)loadData;

/**
 *  显示没有网络
 */
- (void)showNonetWork;

/**
 *  隐藏没有网络
 */
- (void)hiddenNonetWork;

/**
 *  显示没有数据
 *
 *  @param showString 显示的文字
 */
- (void)showErrorView:(NSString *)showString andImageName:(NSString*)imageName;

/**
 *  隐藏没有数据
 */
- (void)hiddenErrorView;
/**
 *  需要重新加载数据时使用这个方法
 *
 *  @param showString 要显示的文本
 */
- (void)showErrorViewLoadAgain:(NSString *)showString ;
//-(void)reloadDataSource;
@end
