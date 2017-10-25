//
//  OAOwnCellView.h
//  CSchool
//
//  Created by mac on 17/6/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OAModel;
@interface OAOwnCellView : UIView
@property (nonatomic,copy)OAModel   *model;
@property (nonatomic,retain)UIColor *titleColor;
@end
