//
//  ChartCell.h
//  CSchool
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsMainCell.h"

@interface ChartCell : UITableViewCell
@property (nonatomic,copy)NSString *userID;

@property (nonatomic,strong)SportModel *model;

@end
