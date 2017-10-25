//
//  OfficeReleaseTableViewCell.h
//  CSchool
//
//  Created by mac on 16/9/10.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfficeReleaseTableViewCell : UITableViewCell
@property (nonatomic,copy) UILabel *title;
@property (nonatomic,copy) UILabel *time;
@property (nonatomic,copy) UILabel *views;
@property (nonatomic,strong)UILabel *newsLabel;
@property (nonatomic,strong)UILabel *depatalLabel;//发布部门
@property (nonatomic,strong) UILabel *timeLabel;//发布时间


@end
