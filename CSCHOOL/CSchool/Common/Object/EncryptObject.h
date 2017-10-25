//
//  EncryptObject.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/6/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptObject : NSObject

+(EncryptObject *)shareEncrypt;

//白名单数组，服务器返回
@property (nonatomic, strong) NSArray *whiteListArray;

//白名单字典
@property (nonatomic, strong) NSMutableDictionary *whiteListDic;

//把字符串加密成32位小写md5字符串
+ (NSString*)md532BitLower:(NSString *)inPutText;

//把字符串加密成32位大写md5字符串
+ (NSString*)md532BitUpper:(NSString*)inPutText;

@end
