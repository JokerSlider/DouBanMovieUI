//
//  StuWIFISubsignController.h
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SubSignSucessBlock)(NSString *state);

@class WIFICellModel;
@interface StuWIFISubsignController : BaseViewController
@property (nonatomic,strong)WIFICellModel *model;
@property (nonatomic, copy) SubSignSucessBlock subSignSucessBlock;

@end
