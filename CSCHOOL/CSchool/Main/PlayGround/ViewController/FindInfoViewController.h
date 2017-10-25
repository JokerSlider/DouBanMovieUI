//
//  FindInfoViewController.h
//  CSchool
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@class FindLoseModel;

@interface FindInfoViewController : BaseViewController
@property (nonatomic,strong)FindLoseModel *model;
@property (nonatomic,strong)NSArray  *imageArr;//高清图数组
@property (nonatomic,copy)NSString *reiId;//信息id

@end
