//
//  BusChoseModel.h
//  CSchool
//
//  Created by mac on 17/8/30.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
@interface BusChoseModel : NSObject
@property (nonatomic,copy)NSString *fieldType;
@property (nonatomic,copy)NSString *filedSubTitle;
@property (nonatomic,copy)NSString *fieldLable;
@property (nonatomic,copy)NSArray  *content;
@property (nonatomic,copy)NSString *filedName;
@property (nonatomic,assign)BOOL   isMust;//是否必填
@property (nonatomic,copy)NSString *value;//plaoder

/*
 cf_address 出发地址
 c_type  出行类型
 t_id  ID
 t_name 名称
 address 地址
 ta_id   ID
 ta_name 名称
 sj  手机
 */
@property (nonatomic,copy)NSString *cf_address;//出发地址
@property (nonatomic,copy)NSArray  *c_type;//出行类型
//@property (nonatomic,copy)NSString *t_id;
//@property (nonatomic,copy)NSString *t_name;
@property (nonatomic,copy)NSArray  *address;
@property (nonatomic,copy)NSString *ta_id;
@property (nonatomic,copy)NSString *ta_name;
@property (nonatomic,copy)NSArray  *sj;

@property(nonatomic,copy) NSString * travel_type ;//   出行类型 1 火车 2 汽车 3 飞机 4 自驾 5 其他  c_type
@property(nonatomic,copy)NSString *expectArrive;//  预计到达时间
@property(nonatomic,copy)NSString *beginAddr;//     出发地
@property(nonatomic,copy)NSString *endAddr ;//      目的地  address
@property(nonatomic,copy)NSString *trainNum;//      车次
@property(nonatomic,copy)NSString *peerNum;//       同行人数
@property(nonatomic,copy)NSString *telphone ;//     联系电话    sj
@property(nonatomic,copy)NSString *bz ;//           备注信息
@property (nonatomic,copy)NSString *count;
@property (nonatomic,copy)NSString *contentText;

@property(nonatomic,copy)NSString *type_id;// integer,出行类型id
@property(nonatomic,copy)NSString *end_address_id;// integer 目的地id
/*
 "yhbh": "17370102110229",
 "sds_code": "sdjzu",
 "xm": "谢东",
 "trip_name": "火车",
 "trip_end_time": "2017-08-28 11:44:54",
 "begin_address": "济南",
 "train_number": "k12",
 "zx_num": "12",
 "bz": "",
 "lxdh": "15111111111",
 "end_address_id": "济南火车站hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
 */

@end
