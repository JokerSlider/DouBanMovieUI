//
//  WifiClassView.h
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIFICellModel.h"
@interface WifiClassView : UIView
@property (nonatomic,strong)WIFICellModel *model;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,assign)BOOL  isEdit;
@end
