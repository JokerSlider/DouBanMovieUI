//
//  WIFISignInfoNormalCell.h
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIFICellModel.h"
@protocol WIFICourseEditDelegate <NSObject>
-(void)openChooseCourseVC;

@end
//代理事件

@interface WIFISignInfoNormalCell : UITableViewCell
@property (nonatomic,strong)UIButton *editBtn;

@property (nonatomic,strong)WIFICellModel *model;

@property (nonatomic,assign)BOOL  isEdit;

@property (nonatomic, assign) id<WIFICourseEditDelegate> delegate;

@end
