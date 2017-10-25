//
//  PriseAlertView.h
//  CSchool
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriseModel.h"
@interface PriseAlertView : UIView
- (id)initWithPriseViewwithPriseLevel:(int)level;
@property (nonatomic,strong)PriseModel *model;
@end
