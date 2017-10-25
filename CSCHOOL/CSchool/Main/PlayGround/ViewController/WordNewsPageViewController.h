//
//  WordNewsPageViewController.h
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@protocol ZJPageViewControllerDelegate <NSObject>

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;

@end
@interface WordNewsPageViewController : UIViewController
// 代理
@property(weak, nonatomic)id<ZJPageViewControllerDelegate> delegate;

@property (strong, nonatomic) UIScrollView *scrollView;

@end
