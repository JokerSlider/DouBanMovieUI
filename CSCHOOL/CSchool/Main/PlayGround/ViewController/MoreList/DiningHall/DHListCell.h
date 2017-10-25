//
//  DHListCell.h
//  CSchool
//
//  Created by mac on 17/9/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYModel.h>

@interface DHListModel : NSObject
/*
 wid 窗口ID
 wname 窗口名称
 avgsum 窗口平均一天消费
 datesum 当前日期窗口的消费
 count 数量
 */
@property (nonatomic,copy)NSString *wid;
@property (nonatomic,copy)NSString *wname;//窗口名称
@property (nonatomic,copy)NSString *avgsum;//日消费
@property (nonatomic,copy)NSString *datesum;//当前日期消费
@property (nonatomic,copy)NSString *count;//总人数
@property (nonatomic,copy)NSString *lisNum;

@property (nonatomic,copy)NSArray *xArray;//x轴数组
@property (nonatomic,copy)NSArray *yArray;//y轴数组

@end

@interface DHListCell : UITableViewCell
@property(nonatomic,strong)DHListModel *model;
@end
