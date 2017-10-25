//
//  FinderBottomView.h
//  CPopView
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BottomClickDelegate <NSObject>
@optional
/**
 底部按钮的选中事件
 
 @param selectFInderindex 选中的文件夹
 @param index 选中的文件夹中按钮的下标
 */
-(void)itemDidSelectedIconSlectIndex:(UIButton *)btn;


@end

@interface FinderBottomView : UIView
@property (nonatomic, assign) id<BottomClickDelegate> delegate;
//-(instancetype)initWithFrame:(CGRect)frame withIconArr:(NSArray *)iconArr andTitleArr:(NSArray *)titleArr andBigtitleArr:(NSArray *)bigtitleArr andIdArr:(NSMutableArray *)idArr;
//是否展开当前文件夹
@property (nonatomic,assign)  BOOL  isOpen;//
-(instancetype)initWithFrame:(CGRect)frame withIconArr:(NSArray *)dataArr;

/**
  * 打开已经打开的文件夹
  */
-(void)openFinderViewSelected;
@end
