//
//  OANormalChoseController.h
//  CSchool
//
//  Created by mac on 17/7/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface OANormalChoseController : BaseViewController
@property (nonatomic,copy)NSString *in_node_id;//节点编号
@property (nonatomic,copy)NSString *in_fi_id;//流程编号
@property (nonatomic,copy)NSString *in_oi_id;//订单号
@property (nonatomic,copy)NSString *length;//深度
@property (nonatomic,copy)NSString *state;//审批状态
@property (nonatomic,copy)NSString *strs;//连起来的字符串
@property (nonatomic,copy)NSString *in_ho_de;//意见
@end
