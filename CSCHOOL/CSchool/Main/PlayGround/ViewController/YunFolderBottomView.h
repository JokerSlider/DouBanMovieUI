//
//  YunFolderBottomView.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/6/2.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^LeftClickBlock)(void);
typedef void(^RightClickBlock)(void);

@interface YunFolderBottomView : UIView

@property (nonatomic, copy) LeftClickBlock leftClickBlock;

@property (nonatomic, copy) RightClickBlock rightClickBlock;


- (void)setLeftButtonTitle:(NSString *)title;

- (void)setRightButtonTitle:(NSString *)title;

@end
