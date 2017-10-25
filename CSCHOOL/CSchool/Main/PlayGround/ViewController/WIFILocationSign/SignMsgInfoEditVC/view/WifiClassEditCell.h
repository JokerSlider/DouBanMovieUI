//
//  WifiClassEditCell.h
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIFICellModel.h"
@protocol WIFIClassEditDelegate <NSObject>
-(void)addClassAction:(UIButton *)sender;
-(void)deletAction:(UIButton *)sender;
@end

@interface WifiClassEditCell : UITableViewCell
@property (nonatomic,strong)WIFICellModel *model;
//代理事件
@property (nonatomic, assign) id<WIFIClassEditDelegate> delegate;

@end
