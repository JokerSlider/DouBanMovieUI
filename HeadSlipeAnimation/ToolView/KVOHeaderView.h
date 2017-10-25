//
//  KVOHeaderView.h
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/23.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NavBtnDelegate
-(void)leftBtnAction:(UIButton *)sender;

-(void)rightBtnAction:(UIButton *)sendr;
@end
@interface KVOHeaderView : UIView
@property (nonatomic, weak) UITableView *tableView;

@property(nonatomic,copy)NSArray *tableViews;
@property (nonatomic,copy)NSString *titleString;
@property (retain,nonatomic) id <NavBtnDelegate> delegate;

@end
