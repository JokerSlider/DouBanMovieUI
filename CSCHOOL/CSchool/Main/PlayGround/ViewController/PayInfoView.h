//
//  PayInfoView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/8/23.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PayBtnClickBlock)(NSDictionary *dataDic);
typedef void(^PayInfoHiddenBlock)(void);

@interface PayInfoView : UIView
//到这去按钮点击回调
@property (nonatomic, strong) PayBtnClickBlock payBtnClickBlock;
//点击隐藏回调
@property (nonatomic, strong) PayInfoHiddenBlock payInfoHiddenBlock;

@property (nonatomic, assign) BOOL isHidden;
@end
