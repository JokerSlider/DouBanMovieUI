//
//  OAToolView.h
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  OAFilterDelegate <NSObject>
-(void)filterDataByName;//通过名称筛选

-(void)filerDataByState;//通过状态筛选

@end
@interface OAToolView : UIView
@property (nonatomic, weak) id <OAFilterDelegate>delegate;

@end
