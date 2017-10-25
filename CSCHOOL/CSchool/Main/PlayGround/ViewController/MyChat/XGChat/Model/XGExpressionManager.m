//
//  XGExpressionManager.m
//  CSchool
//
//  Created by 左俊鑫 on 17/2/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XGExpressionManager.h"
#import "YYImage.h"

@implementation XGExpressionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nomarImageMapper = [self getExpressionDic];
    }
    return self;
}

- (NSDictionary *)getExpressionDic{
    NSString *plistPath = [self filePath:@"QQIcon.plist"];
    NSArray *qqEmotions = [NSArray arrayWithContentsOfFile:plistPath];
    //    NSArray *qqEmotions =  [NSArray arrayWithContentsOfFile:[self.qqBundle pathForResource:@"info" ofType:@"plist"]];
    NSMutableDictionary *mapper = [NSMutableDictionary dictionary];
//    NSMutableDictionary *gifMapper = [NSMutableDictionary dictionary];
//    __weak typeof(*&self) wSelf = self;
    [qqEmotions enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        __strong typeof(*&wSelf) self = wSelf;
        mapper[obj.allKeys[0]] = [YYImage imageNamed:[NSString stringWithFormat:@"%@.gif",obj.allValues[0]]];
        /** 添加如果GIF表情不存在 使用PNG表情 */
        //        gifMapper[obj.allKeys[0]] = [YYImage imageWithContentsOfFile:[self.qqBundle pathForResource:[obj.allValues[0] stringByAppendingString:@"@2x"] ofType:@"gif"]] ? : mapper[obj.allKeys[0]];
    }];
    
    return  [mapper copy];
}


- (NSString *)filePath:(NSString *)fileName {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:@"QQIcon" ofType:@"bundle"],fileName];
    return path;
}

+ (instancetype)sharedManager {
    
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

@end
