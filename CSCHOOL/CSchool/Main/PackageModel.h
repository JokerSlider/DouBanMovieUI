//
//  PackageModel.h
//  CSchool
//
//  Created by mac on 16/8/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageModel : NSObject
/**
 "mealName": "本次包学期特惠135 ",
 "discountExplain": "1) 消费达到一定的购买标准/r/n2)使用优惠券支付的订单/r/n3)优惠券必须在有效期内使用",
 "timelength": "包学 期",
 "discountDes": "移动用户可退费100元",
 "remark": "温馨提示：由于技术本身的特点，凡办理高带宽的同学请确认自己的终 端可支持连接5.8G信道",
 "schoolCode": ""

 */
@property (nonatomic,strong)NSString *mealName;
@property (nonatomic,strong)NSString *discountExplain;
@property (nonatomic,strong)NSString *timelength;
@property (nonatomic,strong)NSString *discountDes;
@property (nonatomic,strong)NSString *remark;

@end
