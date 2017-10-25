//
//  OAProdureInfoController.h
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@interface OAProdureInfoController : BaseViewController
@property (nonatomic,assign)BOOL   isExamine;
@property (nonatomic,copy)NSString *oi_id;
@property (nonatomic,copy)NSString *fi_id;
@property (nonatomic,assign)BOOL listState;;//是否可用  审批按钮

@end
