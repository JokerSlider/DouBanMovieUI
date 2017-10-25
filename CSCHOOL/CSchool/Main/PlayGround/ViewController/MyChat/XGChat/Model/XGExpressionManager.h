//
//  XGExpressionManager.h
//  CSchool
//
//  Created by 左俊鑫 on 17/2/24.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGExpressionManager : NSObject

@property (nonatomic, retain) NSDictionary *nomarImageMapper;

+ (instancetype)sharedManager;

@end
