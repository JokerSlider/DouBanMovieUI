//
//  ExamModel.m
//  CSchool
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ExamModel.h"

@implementation ExamModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setAttributes:dic];
    }
    return self;
}
-(void)setAttributes:(NSDictionary *)dic
{
    for (NSString *key in [dic allKeys]) {
        //取出首字母并大写
        NSString *first = [[key substringToIndex:1] uppercaseString];
        //取出其余字母
        NSString *other = [key substringFromIndex:1];
        //拼接成setter方法字符串
        NSString *methodStr = [NSString stringWithFormat:@"set%@%@:",first,other];
        //将setter方法字符串 转换成方法
        SEL method = NSSelectorFromString(methodStr);
        
        //setter方法的参数
        id value = [dic objectForKey:key];
        
        //如果响应method方法说明 model中声明了该属性
        if ([self respondsToSelector:method]) {
            //调用属性的setter方法并且传入参数
            [self performSelector:method withObject:value];
        }
    }
    for (NSString *key in self.map) {
        //将setter方法字符串 转换成方法
        SEL method = NSSelectorFromString([self.map objectForKey:key]);
        
        //setter方法的参数
        id value = [dic objectForKey:key];
        
        //如果响应method方法说明 model中声明了该属性
        if ([self respondsToSelector:method]) {
            //调用属性的setter方法并且传入参数
            [self performSelector:method withObject:value];
        }
        
    }
}

@end
