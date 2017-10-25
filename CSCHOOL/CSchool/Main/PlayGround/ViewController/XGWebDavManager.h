//
//  XGWebDavManager.h
//  CSchool
//
//  Created by 左俊鑫 on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGWebDavManager : NSObject

+ (XGWebDavManager *)sharWebDavmManager;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *kDescription;
@property (nonatomic, copy) NSString *baseUrl;

@end
