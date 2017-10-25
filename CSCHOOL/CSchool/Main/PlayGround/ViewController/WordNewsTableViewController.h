//
//  WordNewsTableViewController.h
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "WordNewsPageViewController.h"
#import "WordNewsPageViewController.h"
#import "ZJScrollPageViewDelegate.h"
@interface WordNewsTableViewController : WordNewsPageViewController<ZJScrollPageViewChildVcDelegate>
@property (nonatomic,strong)NSArray *selectIDArr;
@end
