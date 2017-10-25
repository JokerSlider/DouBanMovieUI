//
//  BaseGMT.m
//  CSchool
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseGMT.h"
#import "GTMBase64.h"

@implementation BaseGMT

+(NSString *)TextCode:(NSString *)schoolInfo{
    static NSString *beforeStr = @"WkTf89tYs";
    static NSString *afterStr = @"OqN9Ts73u";
    
    /*
     NSString *str=@"Hello world";
     NSData *Data=[str dataUsingEncoding:NSUTF8StringEncoding];
     //进行编码
     Data =[GTMBase64 encodeData:Data];
     NSString *codestr=[[[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding] autorelease];
     self.lbMessage.text=codestr;
     */
    //字符串拼接
    NSData *Data=[schoolInfo dataUsingEncoding:NSUTF8StringEncoding];
    //进行编码
    Data =[GTMBase64 encodeData:Data];
    
    NSString *codestr=[[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
    //拼接
    schoolInfo = [NSString stringWithFormat:@"%@%@%@",beforeStr,codestr,afterStr];
    Data = [schoolInfo dataUsingEncoding:NSUTF8StringEncoding];
    schoolInfo = [[NSString alloc]initWithData:[GTMBase64 encodeData:Data] encoding:NSUTF8StringEncoding];
    NSLog(@"输出%@",schoolInfo);
    
    return schoolInfo;
}


@end
