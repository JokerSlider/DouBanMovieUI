//
//  PackageInfoViewController.h
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface PackageInfoViewController : BaseViewController

@property (nonatomic, copy) NSString *orderIdStr; //订单编号
@property (nonatomic, copy) NSString *orderStr; //订单名称
@property (nonatomic, copy) NSString *waitPayString; //待支付的支付宝串
@property (nonatomic, copy) NSString *timeStr; //时长

@end
