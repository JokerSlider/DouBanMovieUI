//
//  BaseListButton.h
//  CSchool
//
//  Created by 左俊鑫 on 16/9/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseListButton : UIButton

/**
 *  存放该按钮所拥有的数据源。
 */
@property (nonatomic, retain) NSArray *dataArray;

@end
