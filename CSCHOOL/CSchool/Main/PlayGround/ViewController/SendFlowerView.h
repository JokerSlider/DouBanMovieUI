//
//  SendFlowerView.h
//  CSchool
//
//  Created by 左俊鑫 on 16/11/25.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoCarModel;
@class SendFlowerView;

typedef void(^SendFlowerBlock)(SendFlowerView *view, PhotoCarModel *model);

@interface SendFlowerView : UIView

@property (nonatomic, retain) PhotoCarModel *model;

@property (nonatomic, copy) SendFlowerBlock sendFlowerBlock;

- (void)show;

@end
