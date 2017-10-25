//
//  BaseConfig.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/8.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseConfig : NSObject

/**
 *  根据字符串获取高度
 *
 *  @param string 字符串内容
 *  @param width  宽度
 *  @param font   字体大小
 *
 *  @return 高度
 */
+(float)heightForString:(NSString *)string width:(float)width withFont:(UIFont *)font;

/**
 *  转换为Json字符串
 *
 *  @param theData 要转换的对象
 *
 *  @return json字符串
 */
+ (NSString *)toJSONString:(id)theData;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
