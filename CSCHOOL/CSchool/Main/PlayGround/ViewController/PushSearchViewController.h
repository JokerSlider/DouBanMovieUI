//
//  PushSearchViewController.h
//  CSchool
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@class FindLoseModel;
@interface PushSearchViewController : BaseViewController
//数据源
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,strong)NSArray *buttonTitleImageArr;
@property (nonatomic,copy)NSString *funcType;
@property (nonatomic,copy)NSString *searChName;
@end
