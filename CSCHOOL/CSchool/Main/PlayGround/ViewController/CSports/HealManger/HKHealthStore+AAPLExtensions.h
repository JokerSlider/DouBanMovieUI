//
//  HKHealthStore+AAPLExtensions.h
//  CSchool
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <HealthKit/HealthKit.h>

@interface HKHealthStore (AAPLExtensions)
- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion;

@end
