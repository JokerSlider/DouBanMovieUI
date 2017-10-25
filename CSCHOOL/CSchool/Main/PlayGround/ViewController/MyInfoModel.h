//
//  MyInfoModel.h
//  CSchool
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
@interface MyInfoModel : NSObject
@property (nonatomic,copy)NSString *nickName;//昵称
@property (nonatomic,copy)NSString *sex;//性别
@property (nonatomic,copy)NSString *phoneNum;//手机号
@property (nonatomic,copy)NSString *senior;//专业
@property (nonatomic,copy)NSString *birthday;//生日
@property (nonatomic,copy)NSString *hometown;//家乡
@property (nonatomic,copy)NSString *headimageUrl;//头像地址
@property (nonatomic,copy)NSString *mySignTxt;//签名
@property (nonatomic,copy)NSString *jobAddress;//所在地
@property (nonatomic,copy)NSString *BGDD;
@property (nonatomic,copy)NSString *SJXH;
@end
