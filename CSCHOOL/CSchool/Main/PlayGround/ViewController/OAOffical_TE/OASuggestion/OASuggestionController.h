//
//  OASuggestionController.h
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface OASuggestionController : BaseViewController
@property (nonatomic,copy)NSString *oi_id;//工单id
@property (nonatomic,copy)NSString *fi_id;
@property (nonatomic,copy)NSString *listState;//工单状态 是否审批

@end
