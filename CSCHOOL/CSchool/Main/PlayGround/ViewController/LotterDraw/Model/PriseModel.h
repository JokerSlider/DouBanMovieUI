//
//  PriseModel.h
//  CSchool
//
//  Created by mac on 17/5/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface PriseModel : NSObject
/*
 d 奖品ID
 name 奖品名称
 content 奖品内容
 count 奖品总数量
 des 描述信息（角度使用20，30；60，80格式）
 pic 奖品图片
 
 awardName 奖品名称
 redeemCode 兑换码
 
 awardId 奖品ID
 
 stuNo 学号
 schoolCode 学校识别码
 wintime 中奖时间
 redeemCode 兑换码
 isReceive 是否领取
 receiveUsr 领取人
 receivePhone 领取人联系电话
 receiveTime 领取时间
 activityName 活动名称
 awardName 奖品名称

 */
@property (nonatomic,copy)NSString *priseID;
@property (nonatomic,copy)NSString *priseName;
@property (nonatomic,copy)NSString *priseContent;//
@property (nonatomic,copy)NSString *prisecount;
@property (nonatomic,copy)NSString *destription;
@property (nonatomic,copy)NSString *picUrl;//奖品地址
@property (nonatomic,copy)NSString *awardName;
@property (nonatomic,copy)NSString *redeemCode;//兑奖码
@property (nonatomic,copy)NSString *awardId;//奖品ID
@property (nonatomic,copy)NSString *awardPic;
@property (nonatomic,copy)NSString *restcount;

@property (nonatomic,copy)NSString *stuNo;// 学号
@property (nonatomic,copy)NSString *schoolCode;// 学校识别码
@property (nonatomic,copy)NSString *wintime;// 中奖时间
@property (nonatomic,copy)NSString *isReceive;// 是否领取
@property (nonatomic,copy)NSString *receiveUsr;// 领取人
@property (nonatomic,copy)NSString *receivePhone ;//领取人联系电话
@property (nonatomic,copy)NSString *receiveTime ;//领取时间
@property (nonatomic,copy)NSString *activityName;// 活动名称
@property (nonatomic,copy)NSString *prizeName;//奖品名称

@end
