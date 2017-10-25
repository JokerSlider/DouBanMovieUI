//
//  BusListCell.h
//  CSchool
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolBusView.h"
@interface BusListCell : UITableViewCell
@property (nonatomic,strong)SchooBusModel *model;
@property (nonatomic,strong)SchooBusModel *locationModel;

@end
