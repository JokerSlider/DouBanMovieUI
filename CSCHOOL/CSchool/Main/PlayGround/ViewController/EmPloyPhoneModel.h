//
//  EmPloyPhoneModel.h
//  CSchool
//
//  Created by mac on 16/12/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
/*
 name 名字
 num 编号
 phonenum 联系电话
 sex 性别
 role 角色
 address 地址
 count
 state
 city
 street
 departments
 senior
 
 
 address =             {
 city = "<null>";
 count = "<null>";
 state = "<null>";
 street = "<null>";
 };
 departments = "教学科主任科员";
 gzdh = "0531-86361507";
 name = "吴亚男2022";
 num = 13297;
 phonenum = 13964127670;
 qq = "<null>";
 role = "中国共产党党员";
 senior = "教务处";
 sex = "女";
 wechat = "";

 */
@interface EmPloyPhoneModel : NSObject
@property (nonatomic,copy)NSString *name;//姓名
@property (nonatomic,copy)NSString *num;//编号
@property (nonatomic,copy)NSString *phonenum;//联系电话
@property (nonatomic,copy)NSString *sex;//性别
@property (nonatomic,copy)NSString *role;//角色名
@property (nonatomic,copy)NSString *address;//地址
@property (nonatomic,copy)NSString *departments;//职称
@property (nonatomic,copy)NSString *gzdh;//工作电话

@end
