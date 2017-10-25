//
//  EmPloyPhoneModel.m
//  CSchool
//
//  Created by mac on 16/12/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "EmPloyPhoneModel.h"
#import <YYModel.h>
@implementation EmPloyPhoneModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"title" : @"name",
             @"num" : @"num",
             @"phonenum" : @"phonenum",
             @"sex" : @"sex",
             @"role" : @"role",
             @"address":@"address",
             @"departments":@"departments",
             @"gzdh":@"gzdh"
             };
}
@end
