//
//  YunListBottomView.h
//  CSchool
//
//  Created by 左俊鑫 on 17/4/27.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BottomButtonClick)(UIButton *sender);
@interface YunListBottomView : UIView

@property (nonatomic, copy) BottomButtonClick bottomClick;

@end
