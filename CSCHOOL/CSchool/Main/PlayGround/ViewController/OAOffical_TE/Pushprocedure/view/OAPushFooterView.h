//
//  OAPushFooterView.h
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OAPushDelegate <NSObject>
- (void)pushProdure:(UIButton *)sender;

@end
@interface OAPushFooterView : UIView
@property (nonatomic, weak) id <OAPushDelegate>delegate;

@end
