//
//  CustomerNav.h
//  HeadSlipeAnimation
//
//  Created by mac on 17/8/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavDelegate
-(void)leftBtnAction:(UIButton *)sender;

-(void)rightBtnAction:(UIButton *)sendr;
@end
@interface CustomerNav : UIView

@property (nonatomic,strong)UIColor *titleColor;

@property (nonatomic,copy)NSString *leftImage;

@property (nonatomic,copy)NSString *rightImage;

@property (nonatomic,copy)NSString *title;

@property (retain,nonatomic) id <NavDelegate> delegate;
@end
