//
//  MyInfoModel.m
//  CSchool
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MyInfoModel.h"

@implementation MyInfoModel
/*
 CSDM = 230102;
 CSRQ = "1994-12-17";
 GRSM = "梦里走了许多路，醒来还是在床上";
 NC = "JY小括号";
 SJ = 13953116101;
 TXDZ = "http://123.233.121.17:15100/personinfo/sdjzu/20161117/thumb/201611170846022194020161117084801.jpeg";
 XBM = 1;

 @property (nonatomic,copy)NSString *nickName;//昵称
 @property (nonatomic,copy)NSString *sex;//性别
 @property (nonatomic,copy)NSString *phoneNum;//手机号
 @property (nonatomic,copy)NSString *senior;//专业
 @property (nonatomic,copy)NSString *birthday;//生日
 @property (nonatomic,copy)NSString *hometown;//家乡
 @property (nonatomic,copy)NSString *headimageUrl;//头像地址
 @property (nonatomic,copy)NSString *mySignTxt;//签名
 */
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"nickName" : @"NC",
             @"sex" : @"XBM",
             @"phoneNum" : @"SJ",
             @"senior" : @"senior",
             @"hometown" : @"CSDM",
             @"headimageUrl":@"TXDZ",
             @"mySignTxt":@"GRSM",
             @"birthday":@"CSRQ",
             @"jobAddress":@"XZZ"
             };
}
@end
