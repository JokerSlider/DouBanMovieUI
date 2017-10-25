//
//  MyPublishCell.h
//  CSchool
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBroswerView.h"
@class FindLoseModel;

@interface MyPublishCell : UITableViewCell
@property (nonatomic, strong) FindLoseModel *model;
@property (nonatomic,strong) PhotoBroswerView *picContainerView;
@property (nonatomic,strong)    UIButton *deletMenu;//删除按钮
@property (nonatomic,strong)  UIButton *dropMenu;//下架按钮 --   下架 -- 已下架
@property (nonatomic,strong) UIButton *editMenu;//编辑按钮
@property (nonatomic,strong)    UIImageView *dropNoticeView;//

@end
