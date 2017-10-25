//
//  NRArealocationView.h
//  eLongRoom
//
//  Created by mac on 16/7/3.
//  Copyright © 2016年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@protocol ArealocationViewDelegate;

@interface RTArealocationView : UIView
//头视图的labe数据
@property (nonatomic, weak) id<ArealocationViewDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *otherTableviewArr;
@property(nonatomic,strong)NSMutableArray *firstTableviewArr;
/**
 *  表头文字
 */
@property(nonatomic,strong)NSArray *totalTiltle;
/**
 *  显示 arealocationView
 *
 *  @param view    显示在哪个view上
 *  @param hasData 是否有展示数据
 */
- (void)showArealocationInView:(UIView *)view;

/**
 *  隐藏 arealocationView
 */
- (void)dismissArealocationView;

/**
 *  选择每个tableView上的cell
 *
 *  @param selectIndex 所有选中的索引数组(-1为不选中)
 */
- (void)selectRowWithSelectedIndex:(NSInteger *)selectIndex;

-(void)reloadRTData;
@end
@protocol ArealocationViewDelegate <NSObject>
/**
 *  每一级要展示的数量
 *
 *  @param arealocationView arealocationView
 *  @param level            层级
 *  @param index            cell索引
 *  @param selectedIndex    所有选中的索引数组
 *
 *  @return 展示的数量
 */
- (NSInteger)arealocationView:(RTArealocationView *)arealocationView countForClassAtLevel:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex;

/**
 *  cell的标题
 *
 *  @param arealocationView arealocationView
 *  @param level            层级
 *  @param index            cell索引
 *  @param selectedIndex    所有选中的索引数组
 *
 *  @return cell的标题
 */
- (NSString *)arealocationView:(RTArealocationView *)arealocationView titleForClass:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex;

/**
 *  选取完毕执行的方法
 *
 *  @param arealocationView arealocationView
 *  @param selectedIndex           每一层选取结果的数组
 */
- (void)arealocationView:(RTArealocationView *)arealocationView finishChooseLocationAtIndexs:(NSInteger *)selectedIndex;

@end


