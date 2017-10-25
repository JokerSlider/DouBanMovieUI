//
//  CacheObject.h
//  CSchool
//
//  Created by 左俊鑫 on 16/4/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheObject : NSObject

//课表缓存号
@property (nonatomic, copy)NSString *courseCacheVer;

//空教室缓存号
@property (nonatomic, copy) NSString *freeRoomCacheVer;


+ (CacheObject *)shareCache;

@end
