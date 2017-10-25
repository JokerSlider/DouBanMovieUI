//
//  NewBusChoseCell.h
//  CSchool
//
//  Created by mac on 17/8/29.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusChoseModel.h"
typedef void(^SelctBusEndBlock)(NSString *text,NSString *ID,NSInteger index);
@interface NewBusChoseCell : UITableViewCell
@property (nonatomic,strong)UITextField *inputText;
@property (nonatomic,strong) BusChoseModel *model;
@property (nonatomic, copy) SelctBusEndBlock selectEndBlock;
@end
