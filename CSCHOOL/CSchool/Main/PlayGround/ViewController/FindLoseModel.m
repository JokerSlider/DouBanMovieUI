//
//  FindLoseModel.m
//  CSchool
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FindLoseModel.h"
#import <YYModel.h>
@implementation FindLoseModel
//@property (nonatomic, copy) NSString *title;//标题  AUITITLE
//@property (nonatomic, strong) NSArray *thumblicArray;//缩略图  IRIURL
//@property (nonatomic, copy)  NSString *addressArr;//地址  AUIADDRESS
//@property (nonatomic, strong) NSArray  *tagArr;//标签
//@property (nonatomic, strong) NSString *type;//类型  区分不同的功能  （二手市场，失物招领，兼职招聘）
//@property (nonatomic,copy)NSString *releaseTime;//发布时间 AUIRELEASETIME
//@property (nonatomic,copy)NSString *txtInfo;//描述信息  AUICONTENT
//@property (nonatomic,copy)NSString *name;//发布人姓名 DPCNAME
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"title" : @"AUITITLE",
             @"addressName" : @"AUIADDRESS",
             @"releaseTime" : @"AUIRELEASETIME",
             @"txtInfo" : @"AUICONTENT",
             @"name" : @"AUICONTACTNAME",
             @"price":@"AUIPRICE",
             @"tagName":@"CINAME",
             @"ID":@"AUIID",
             @"type":@"AUICATEGORY",
             @"state":@"AUISTATUS",
             @"thumblicArray":@"IRIURL",
             @"infoType":@"AUITYPE",
             @"thumb":@"thumb",
             @"tagID":@"CIID",
             @"AUIPHONE":@"AUIPHONE",
             @"AUIWEIXIN":@"AUIWEIXIN",
             @"AUIQQ":@"AUIQQ",
             @"priceType":@"UINAME",
             @"priceTypeId":@"UIID",
             @"nickName":@"NC",
             @"photoImageUrl":@"TXDZ"
             };
}
@end
