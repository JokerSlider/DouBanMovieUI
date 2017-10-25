//
//  PayInfoViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseViewController.h"

@interface PayInfoViewController : BaseViewController

//@[@"订单编号",@"下单时间",@"金额",@"带宽",@"时长",@"支付方式"]

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderStartTime;
@property (nonatomic, copy) NSString *orderFee;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *orderPayStyle;
@property (nonatomic, copy) NSString *orderBit;
@property (nonatomic, assign) BOOL isSuccess; //是否交易成功
@end
