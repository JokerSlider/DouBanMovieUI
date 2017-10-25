//
//  PushprocedureController.h
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@class OAModel;
typedef void(^OAEditBlock)(NSArray  *modelArr);
@interface PushprocedureController : BaseViewController
@property (nonatomic,copy)NSString *fid;
@property (nonatomic,assign)BOOL  isEdit;
@property (nonatomic, copy) OAEditBlock oaEditBlock;
@property (nonatomic,copy)NSArray *listMArr;
@end
