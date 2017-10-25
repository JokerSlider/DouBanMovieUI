//
//  FellowRequestCell.h
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatModel;
@class FellowRequestCell;
@protocol FellowRequestDeleagate
//移除加好友提醒
-(void)FellowRequestCell:(FellowRequestCell *)cell;

@end

@interface FellowRequestCell : UITableViewCell
@property (nonatomic,strong)ChatModel  *model;

@property (nonatomic,strong)id <FellowRequestDeleagate> delegate;

@end
