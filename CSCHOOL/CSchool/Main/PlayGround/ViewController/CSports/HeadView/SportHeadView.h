//
//  SportHeadView.h
//  CSchool
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsMainCell.h"
@interface SportHeadView : UIView
@property (nonatomic,strong)SportModel *model;
-(instancetype)initWithFrame:(CGRect)frame andUserID:(NSString *)userID;
@end
