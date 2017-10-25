//
//  BusForNewChoseController.h
//  CSchool
//
//  Created by mac on 17/8/30.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^BusForNewChoseBlock)(NSArray *objArr);

@interface BusForNewChoseController : BaseViewController

@property (nonatomic,copy)NSArray   *objArr;
@property (nonatomic,copy)NSArray   *defaultArr;//默认选中
@property (nonatomic, copy) BusForNewChoseBlock BusChooseListBlock;
@property (nonatomic,assign)BOOL  isMoreSelct;//是否可以多选
@end
