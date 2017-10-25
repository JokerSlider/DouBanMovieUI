//
//  WIFISIgnToolManager.h
//  CSchool
//
//  Created by mac on 17/7/6.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIFISIgnToolManager : NSObject
+(id)shareInstance;


-(NSString *)tranlateDateString:(NSString *)soureceData withDateFormater:(NSString *)formatter andOutFormatter:(NSString *)outFormatter;
@end
