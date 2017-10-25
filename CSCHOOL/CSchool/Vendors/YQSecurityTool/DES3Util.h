//
//  DES3Util.h
//  YQSecurityTool
//
//  Created by mac on 16/1/25.
//  Copyright © 2016年 mobilenow. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface DES3Util : NSObject

+ (NSString*) AES128Encrypt:(NSString *)plainText withgKey:(NSString *)key andgiv:(NSString *)giv;

+ (NSString*) AES128Decrypt:(NSString *)encryptText withgKey:(NSString *)key andgiv:(NSString *)giv;

@end
