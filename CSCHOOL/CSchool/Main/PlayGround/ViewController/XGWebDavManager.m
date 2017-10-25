//
//  XGWebDavManager.m
//  CSchool
//
//  Created by 左俊鑫 on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XGWebDavManager.h"

@implementation XGWebDavManager

static XGWebDavManager * manager;
+ (XGWebDavManager *)sharWebDavmManager{
    static dispatch_once_t oneTime;
    dispatch_once(&oneTime, ^{
        manager = [[XGWebDavManager alloc] init];
    });
    return manager;
}


@end
