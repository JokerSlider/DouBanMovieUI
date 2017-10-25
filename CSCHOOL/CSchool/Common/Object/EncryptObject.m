//
//  EncryptObject.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/6/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "EncryptObject.h"
#import <CommonCrypto/CommonDigest.h>

@implementation EncryptObject

static EncryptObject *_shareEncrypt;

+(EncryptObject *)shareEncrypt{
    @synchronized ([EncryptObject class]) {
        if (_shareEncrypt == nil) {
            _shareEncrypt = [[EncryptObject alloc] init];
        }
    }
    return _shareEncrypt;
}
-(void)setWhiteListArray:(NSArray *)whiteListArray{
    
    _whiteListArray = whiteListArray;
    for (NSString *rid in whiteListArray) {
        [_whiteListDic setObject:@(YES) forKey:rid];
    }
}

-(NSMutableDictionary *)whiteListDic{
    if (!_whiteListDic) {
        _whiteListDic = [NSMutableDictionary dictionary];
        [_whiteListDic setObject:@(YES) forKey:@"getEncryptWhiteList"];
        [_whiteListDic setObject:@(YES) forKey:@"getSchoolInfo"];
        [_whiteListDic setObject:@(YES) forKey:@"getAppUpdateInfo"];
    }
    
    return _whiteListDic;
}

/**
 *  把字符串加密成32位小写md5字符串
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位小写md5字符串
 */
+ (NSString*)md532BitLower:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

/**
 *  把字符串加密成32位大写md5字符串
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位大写md5字符串
 */
+ (NSString*)md532BitUpper:(NSString*)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}


@end
