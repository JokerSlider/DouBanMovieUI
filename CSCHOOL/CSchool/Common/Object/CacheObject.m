//
//  CacheObject.m
//  CSchool
//
//  Created by 左俊鑫 on 16/4/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "CacheObject.h"

@implementation CacheObject

static  CacheObject* _shareCache;

+ (CacheObject *)shareCache{
    @synchronized ([CacheObject class]) {
        if (_shareCache == nil) {
            _shareCache = [[CacheObject alloc] init];
        }
    }
    return _shareCache;
}
@end
