//
//  MarketTypeCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/10/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarketTypeCell;

typedef void(^TypeSelectBlock)(MarketTypeCell *cell,NSInteger index);

@interface MarketTypeCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *typeBtn;

@property (nonatomic, retain) NSArray *typeArray;

@property (nonatomic, copy) TypeSelectBlock typeBlock;

@end
