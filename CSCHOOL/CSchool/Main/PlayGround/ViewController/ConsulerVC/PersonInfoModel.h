//
//  PersonInfoModel.h
//  CSchool
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 NJDM 年级
 YXDM 院系
 JTDZ 家庭地址
 ZYDM 专业
 ZZMMDM 政治面貌
 ZZMM 政治面貌
 JTDH 家庭电话
 XH 学号
 SJH 手机号
 LXDH 联系电话
 XM 姓名
 YXMC 院系名称
 ZYMC 专业名称
 
 
 **/
@interface PersonInfoModel : NSObject
@property (nonatomic,copy)NSString *NJDM;//年级
@property (nonatomic,copy)NSString *YXDM;//院系
@property (nonatomic,copy)NSString *JTDZ;//家庭地址
@property (nonatomic,copy)NSString *ZYDM;//专业
@property (nonatomic,copy)NSString *ZZMMDM;//政治面貌代码
@property (nonatomic,copy)NSString *ZZMM;//政治面貌
@property (nonatomic,copy)NSString *XH;//学号
@property (nonatomic,copy)NSString *SJH;//手机号
@property (nonatomic,copy)NSString *LXDH;//联系电话
@property (nonatomic,copy)NSString *XM;//姓名
@property (nonatomic,copy)NSString *YXMC;//院系名称
@property (nonatomic,copy)NSString *ZYMC;//专业名称


@end
