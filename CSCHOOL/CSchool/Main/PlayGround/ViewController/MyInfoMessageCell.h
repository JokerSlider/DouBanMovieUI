//
//  MyInfoMessageCell.h
//  CSchool
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyInfoModel;
@interface MyInfoMessageCell : UITableViewCell
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *txtField;
@property (nonatomic,strong) MyInfoModel *model;
@end
