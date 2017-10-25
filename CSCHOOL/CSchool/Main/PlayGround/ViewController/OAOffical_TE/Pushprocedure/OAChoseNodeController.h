//
//  OAChoseNodeController.h
//  CSchool
//
//  Created by mac on 17/7/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface OAChoseNodeController : BaseViewController
@property (nonatomic,copy)NSString *oi_id;
@property (nonatomic,copy)NSString *fi_id;
@property (nonatomic,copy)NSString *strs;//参数拼起来的字符串
@property (nonatomic,copy)NSString *state;//审批状态
@property (nonatomic,copy)NSString *in_ho_de;//审核描述
@end
