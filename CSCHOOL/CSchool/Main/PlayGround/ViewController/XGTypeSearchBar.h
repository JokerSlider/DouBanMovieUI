//
//  XGTypeSearchBar.h
//  CSchool
//
//  Created by 左俊鑫 on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchClickBlock)(NSString *searchString, NSDictionary *typeDic);
typedef void(^SearchCancelBlock)(void);

//可以选择类型的搜索框searchBar
@interface XGTypeSearchBar : UIView

@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, copy) SearchClickBlock searchClick;
@property (nonatomic, copy) SearchCancelBlock searchCancel;

//数组存放类型
-(instancetype)initWithTypeArray:(NSArray *)typeArray;

- (void)setTypeButtonTitleWithType:(NSString *)type;

@end
