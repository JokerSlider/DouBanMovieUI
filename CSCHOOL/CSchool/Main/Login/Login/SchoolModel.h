//
//  SchoolModel.h
//  CSchool
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolModel : NSObject
-(instancetype)initWithDic:(NSDictionary *)dic;
@property(nonatomic,retain)NSDictionary *map;



@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *schoolName;

@property(nonatomic,copy)NSString *wifiName;
@property(nonatomic,copy)NSString *serverIpAddress;

@property(nonatomic,copy)NSString *schoolCode;
@property (nonatomic,copy)NSString *isShowPhone;
@property (nonatomic,copy)NSString *eportalVer;
@property (nonatomic, copy) NSString *ltServerIpAddress; //联通地址
@end
