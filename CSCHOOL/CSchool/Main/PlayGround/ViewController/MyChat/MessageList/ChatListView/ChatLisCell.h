//
//  ChatLisCell.h
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModel;
@class ChatLisCell;
@protocol ResetCellMessageNumDeleagate
-(void)MessgaeCell:(ChatLisCell *)cell;
@end;


@interface ChatLisCell : UITableViewCell
@property (nonatomic,strong) HomeModel *model;
@property (nonatomic,strong) UILabel *userNickName;//昵称或者群组名

@property (nonatomic,strong)id <ResetCellMessageNumDeleagate> delegate;
@end
