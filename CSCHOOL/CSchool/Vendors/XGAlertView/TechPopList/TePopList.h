//
//  TePopList.h
//  DSActionSheetDemo
//
//  Created by Techistoner on 15/8/27.
//  Copyright (c) 2015年 LS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PopListSelectedBlock)(NSInteger select);

@interface TePopList : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , copy)PopListSelectedBlock selecteblock;

@property (nonatomic, assign) BOOL isAllowBackClick; //阴影部分是否允许点击消失。

- (instancetype)initWithListDataSource:(NSArray *)source withTitle:(NSString *)title withSelectedBlock:(PopListSelectedBlock)selecteblock;

/**
 *  设置当前选中
 *
 *  @param index 选中第几个
 */
- (void)selectIndex:(NSInteger )index;

/**
 *  设置显示
 */
- (void)show;


@end
