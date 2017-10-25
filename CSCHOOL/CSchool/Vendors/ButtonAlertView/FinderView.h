//
//  FinderView.h
//  CPopView
//
//  Created by mac on 17/1/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinderView : UIView
-(instancetype)initWithFrame:(CGRect)frame andImageArr:(NSArray *)images;
//-(instancetype)initWithFrame:(CGRect)frame andImageDic:(NSDictionary *)Dic;
-(void)handleFuncMessage:(NSNotification*)note;

@end
