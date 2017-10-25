//
//  BaseViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMengAnalytics/UMMobClick/MobClick.h>
#import "UIViewController+KSNoNetController.h"

@interface BaseViewController : UIViewController

/**
 *  设置无数据的tableview显示文字
 *
 *  @param tableView
 *  @param emptyStr  显示的文字
 */
- (void)setEmptyView:(UITableView *)tableView withString:(NSString *)emptyStr withImageName:(NSString *)imageName;

/**
 *  友盟点击次数统计
 *
 */
- (void)UMengEvent:(NSString *)event;

@end
