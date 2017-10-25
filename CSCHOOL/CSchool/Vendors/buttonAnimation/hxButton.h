//
//  hxButton.h
//  zongjie
//
//  Created by 黄鑫 on 16/4/14.
//  Copyright © 2016年 hx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseView.h"

@interface hxButton : UIButton

/** 是否在加载*/
@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, retain)baseView *hxView;
@property(nonatomic, retain)UIColor *contentColor;
@property(nonatomic, retain)UIColor *progressColor;
@property(nonatomic,retain)UIColor *backgroundColor;
@property(nonatomic,assign)BOOL  isEnabeld;

@property(nonatomic, retain)UIButton *forDisplayButton;
-(void)startLoading;
-(void)stopLoading;
@end
