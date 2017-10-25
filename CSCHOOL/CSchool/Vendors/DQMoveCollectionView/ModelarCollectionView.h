//
//  ModelarCollectionView.h
//  Init
//
//  Created by mc on 16/6/4.
//  Copyright © 2016年 zhaoshijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelarCollectionView;
@protocol RTDragCellTableViewDataSource <UICollectionViewDataSource>

@required
/**将外部数据源数组传入，以便在移动cell数据发生改变时进行修改重排*/
- (NSArray *)originalArrayDataForTableView:(ModelarCollectionView *)tableView;

@end

@protocol RTDragCellTableViewDelegate <UICollectionViewDelegate>

@required
/**将修改重排后的数组传入，以便外部更新数据源*/
- (void)tableView:(ModelarCollectionView *)tableView newArrayDataForDataSource:(NSArray *)newArray;
@optional
/**选中的cell准备好可以移动的时候*/
- (void)tableView:(ModelarCollectionView *)tableView cellReadyToMoveAtIndexPath:(NSIndexPath *)indexPath;
/**选中的cell正在移动，变换位置，手势尚未松开*/
- (void)cellIsMovingInTableView:(ModelarCollectionView *)tableView;
/**选中的cell完成移动，手势已松开*/
- (void)cellDidEndMovingInTableView:(ModelarCollectionView *)tableView;

@end

@interface ModelarCollectionView : UICollectionView

@property (nonatomic, assign) id<RTDragCellTableViewDataSource> adataSource;
@property (nonatomic, assign) id<RTDragCellTableViewDelegate> adelegate;

@end
