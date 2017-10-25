//
//  SportListCell.h
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsMainCell.h"
@class SportModel;
@interface SportListCell : UITableViewCell
@property (nonatomic,strong)SportModel *model;
@end
