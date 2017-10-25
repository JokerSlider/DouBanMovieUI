//
//  YunUploadBottomView.h
//  CSchool
//
//  Created by 左俊鑫 on 17/5/18.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UploadClickBlock)(void);
typedef void(^LocationClickBlock)(void);

@interface YunUploadBottomView : UIView

@property (nonatomic, copy) UploadClickBlock uploadClick;

@property (nonatomic, copy) LocationClickBlock locationClick;

- (void)setLocationBtnTitle:(NSString *)title;

@end
