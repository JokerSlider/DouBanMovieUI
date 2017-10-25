//
//  SingleSelectView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SingleSelectView;
@protocol SingSelectViewDelegate <NSObject>

@optional
- (void)selectView:(SingleSelectView *)view didSelectAtIndex:(NSInteger)index;

@end

@interface SingleSelectView : UIView

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, weak) id<SingSelectViewDelegate>delegate;
/**
 *  获取选中按钮的index
 *
 *  @return 若值为-1，则未选择任何按钮。
 */
- (NSInteger)getSelectIndex;

/**
 *  根据标题文字设置选中的按钮
 *
 *  @param title 标题
 */
- (void)btnSelectWithTitle:(NSString *)title;

/**
 *  根据位置index设置选中按钮
 *
 *  @param index tag
 */
- (void)btnSelectAtIndex:(NSInteger)index;

@end
