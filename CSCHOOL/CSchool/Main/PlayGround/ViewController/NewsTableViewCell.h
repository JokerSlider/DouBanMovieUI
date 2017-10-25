//
//  NewsTableViewCell.h
//  CSchool
//
//  Created by mac on 16/6/24.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (nonatomic,copy) UILabel *title;
@property (nonatomic,copy) UILabel *time;
@property (nonatomic,copy) UILabel *views;
@property (nonatomic,strong)UILabel *newsLabel;
@property (nonatomic,strong)UILabel *depatalLabel;//发布部门

@end
