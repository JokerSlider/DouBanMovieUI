//
//  PayDetailViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/12.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseViewController.h"

//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end

@interface PayDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *timeStr; //时长
@property (nonatomic, copy) NSString *priceStr; //价格
@property (nonatomic, copy) NSString *bitStr; //带宽
@property (nonatomic, copy) NSString *orderIdStr; //订单编号
@property (nonatomic, copy) NSString *orderStr; //订单名称
@property (nonatomic, copy) NSString *waitPayString; //待支付的支付宝串


@property (nonatomic, copy) NSString *orderOutDateTime; //订单结束时间
@end
