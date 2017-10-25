//
//  ZYPinYinSearch.m
//  ZYPinYinSearch
//
//  Created by soufun on 15/7/27.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#import "ZYPinYinSearch.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "objc/runtime.h"
#import <UIKit/UIKit.h>
@implementation ZYPinYinSearch
+(NSArray *)searchWithOriginalArray:(NSArray *)originalArray andSearchText:(NSString *)searchText andSearchByPropertyName:(NSString *)propertyName{
    NSMutableArray * dataSourceArray = [[NSMutableArray alloc]init];
    NSString * type;
    if(originalArray.count <= 0){
        XGAlertView * alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"未能加载学校数据，请检查网络是否通畅" WithCancelButtonTitle:@"好的" withOtherButton:nil];
        [alert show];
        
        return originalArray;
    }
    else{
        id object = originalArray[0];
        if ([object isKindOfClass:[NSString class]]) {
            type = @"string";
        }
        else if([object isKindOfClass:[NSDictionary class]]){
            type = @"dict";
            NSDictionary * dict = originalArray[0];
            NSLog(@"字典keys：%@",[dict allKeys]);
            BOOL isExit = NO;
            for (NSString * key in dict.allKeys) {
                if([key isEqualToString:propertyName]){
                    isExit = YES;
                    break;
                }
            }
            if (!isExit) {
                XGAlertView * alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:[NSString stringWithFormat:@"数据源中的字典没有你指定的key:%@",propertyName] WithCancelButtonTitle:@"好的" withOtherButton:nil];
                [alert show];
                return originalArray;
            }
        }
        else{
            type = @"model";
            NSMutableArray *props = [NSMutableArray array];
            unsigned int outCount, i;
            objc_property_t *properties = class_copyPropertyList([object class], &outCount);
            for (i = 0; i<outCount; i++)
            {
                objc_property_t property = properties[i];
                const char* char_f = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:char_f];
                [props addObject:propertyName];
            }
            NSLog(@"Model属性列表：%@",props);
            free(properties);
            BOOL isExit = NO;
            for (NSString * property in props) {
                if([property isEqualToString:propertyName]){
                    isExit = YES;
                    break;
                }
            }
            if (!isExit) {
                XGAlertView * alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:[NSString stringWithFormat:@"数据源中的Model没有你指定的属性:%@",propertyName]  WithCancelButtonTitle:@"好的" withOtherButton:nil];
                [alert show];
                return originalArray;
            }

        }
    }
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<originalArray.count; i++) {
            NSString * tempString;
            if ([type isEqualToString:@"string"]) {
                tempString = originalArray[i];
            }
            else{
                tempString = [originalArray[i]valueForKey:propertyName];
            }
            if ([ChineseInclude isIncludeChineseInString:tempString]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:tempString];
                NSLog(@"%@",tempPinYinStr);
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:tempString];
                NSLog(@"%@",tempPinYinHeadStr);
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
            }
            else {
                NSRange titleResult=[tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (id object in originalArray) {
            NSString * tempString;
            if ([type isEqualToString:@"string"]) {
                tempString = object;
            }
            else{
                tempString = [object valueForKey:propertyName];
            }
            NSRange titleResult=[tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [dataSourceArray addObject:object];
            }
        }
    }
    return dataSourceArray;
}



+(NSArray *)searchWithOriginalArray:(NSArray *)originalArray andSearchText:(NSString *)searchText andSearchByPropertyNames:(NSArray *)propertyNamesArray{
    NSMutableArray * dataSourceArray = [[NSMutableArray alloc]init];
    NSString * type;
    if(originalArray.count <= 0){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数据源不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return originalArray;
    }
    else{
        id object = originalArray[0];
        if([object isKindOfClass:[NSDictionary class]]){
            type = @"dict";
            NSDictionary * dict = originalArray[0];
            NSLog(@"字典keys：%@",[dict allKeys]);
            BOOL isExit = NO;
            for (NSString * key in dict.allKeys) {
                for (NSString *str in propertyNamesArray) {
                    if([key isEqualToString:str]){
                        isExit = YES;
                        break;
                    }
                }
            }
            if (!isExit) {
                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"数据源中的字典没有你指定的key:%@",propertyName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                //                [alert show];
                return originalArray;
            }
        }
        else{
            type = @"model";
            NSMutableArray *props = [NSMutableArray array];
            unsigned int outCount, i;
            objc_property_t *properties = class_copyPropertyList([object class], &outCount);
            for (i = 0; i<outCount; i++)
            {
                objc_property_t property = properties[i];
                const char* char_f = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:char_f];
                [props addObject:propertyName];
            }
            NSLog(@"Model属性列表：%@",props);
            free(properties);
            BOOL isExit = NO;
            for (NSString * property in props) {
                for (NSString *str in propertyNamesArray) {
                    if([property isEqualToString:str]){
                        isExit = YES;
                        break;
                    }
                }
            }
            if (!isExit) {
                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"数据源中的Model没有你指定的属性:%@",propertyName] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                //                [alert show];
                return originalArray;
            }
            
        }
    }
    if (searchText.length>0&&![ChineseInclude isIncludeChineseInString:searchText]) {
        for (int i=0; i<originalArray.count; i++) {
            NSMutableString * tempString = [NSMutableString string];
            if ([type isEqualToString:@"string"]) {
                tempString = originalArray[i];
            }
            else{
                for (NSString *str in propertyNamesArray) {
                    if ([originalArray[i]valueForKey:str]) {
                        [tempString appendString:[originalArray[i]valueForKey:str]];
                        [tempString appendString:@";"];
                    }
                    
                }
//                tempString = [originalArray[i]valueForKey:propertyName];
            }
            if ([ChineseInclude isIncludeChineseInString:tempString]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:tempString];
                NSLog(@"%@",tempPinYinStr);
                NSRange titleResult=[tempPinYinStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:tempString];
                NSLog(@"%@",tempPinYinHeadStr);
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
            }
            else {
                NSRange titleResult=[tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [dataSourceArray addObject:originalArray[i]];
                    continue;
                }
            }
        }
    } else if (searchText.length>0&&[ChineseInclude isIncludeChineseInString:searchText]) {
        for (id object in originalArray) {
            NSMutableString * tempString = [NSMutableString string];
            if ([type isEqualToString:@"string"]) {
                tempString = object;
            }
            else{
                for (NSString *str in propertyNamesArray) {
                    if ([object valueForKey:str]) {
                        [tempString appendString:[object valueForKey:str]];
                        [tempString appendString:@";"];
                    }
                    
//                    tempString = [object valueForKey:propertyName];
                }
            }
            NSRange titleResult=[tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [dataSourceArray addObject:object];
            }
        }
    }
    return dataSourceArray;

}

@end
