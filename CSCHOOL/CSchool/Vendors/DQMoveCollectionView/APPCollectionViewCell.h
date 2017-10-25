//
//  CollectionViewCell.h
//  DQMoveCollectionView
//
//  Created by 邓琪 dengqi on 2016/12/16.
//  Copyright © 2016年 邓琪 dengqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DQModel;
@interface APPCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  UILabel *title;
@property (nonatomic,copy)NSString *ai_id;
- (void)SetDataFromModel:(DQModel *)model;

@end
