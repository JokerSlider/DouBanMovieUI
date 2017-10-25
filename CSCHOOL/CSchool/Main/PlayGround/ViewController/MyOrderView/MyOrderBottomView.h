//
//  MyOrderBottomView.h
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibiraryModel.h"
@interface MyOrderBottomView : UIView
@property (nonatomic,strong)LibiraryModel *model;
-(void)reloadData;
@end
