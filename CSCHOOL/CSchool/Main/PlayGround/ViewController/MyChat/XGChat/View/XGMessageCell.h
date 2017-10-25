//
//  XGMessageCell.h
//  XMPPDemo
//
//  Created by 左俊鑫 on 17/2/7.
//  Copyright © 2017年 Xin the Great. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGMessageModel;

@interface XGMessageCell : UITableViewCell

@property (nonatomic, retain) XGMessageModel *model;

@property (nonatomic,strong)  UILabel *timeLabel;//时间


@property (nonatomic, strong) UIImageView *messageImageView;

@end
