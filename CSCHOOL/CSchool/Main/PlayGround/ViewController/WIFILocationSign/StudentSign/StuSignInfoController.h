//
//  StuSignInfoController.h
//  CSchool
//
//  Created by mac on 17/6/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SignSucessBlock)(NSString *state);

@interface StuSignInfoController : BaseViewController
@property (nonatomic,copy)NSString *aci_ID;
@property (nonatomic, copy) SignSucessBlock signSucessBlock;

@end
