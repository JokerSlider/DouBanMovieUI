//
//  IdCodeView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdCodeView;
@protocol IdCodeViewDelegate <NSObject>

- (void)idCodeView:(IdCodeView *)view didInputSuccessCode:(NSString *)idCode;

- (void)idCodeView:(IdCodeView *)view didChangeCode:(NSString *)idCode;

@end

@interface IdCodeView : UIView

@property (nonatomic, weak) id<IdCodeViewDelegate>delegate;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL notAuto; //是否不自动升高。默认为NO（自动升高）
@end
