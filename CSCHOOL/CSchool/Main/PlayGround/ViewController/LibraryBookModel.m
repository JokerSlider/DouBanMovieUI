//
//  LibraryBookModel.m
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LibraryBookModel.h"
#import <YYModel.h>
@implementation LibraryBookModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"bookName" : @"M_TITLE",
             @"author" : @"M_AUTHOR",
             @"publicName" : @"M_PUBLISHER",
             @"tiaomaNum" : @"BAR_CODE",
             @"haveNum":@"SUMNUM",
             @"canrentNum":@"OKNUM",
             @"suoshuNum":@"CALL_NO",
             @"docType":@"DOC_TYPE_NAME",
             @"publicYear":@"M_PUB_YEAR"
             };
}

@end
