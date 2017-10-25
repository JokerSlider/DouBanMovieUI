//
//  OAInfoViewController.h
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface OAInfoViewController : BaseViewController
@property (nonatomic,assign)BOOL  isExamine;  //是否显示审批
@property (nonatomic,copy)NSString *oi_id;
@property (nonatomic,copy)NSString *fi_id;
@property (nonatomic,assign)BOOL listState; //审批是否可用

@end
