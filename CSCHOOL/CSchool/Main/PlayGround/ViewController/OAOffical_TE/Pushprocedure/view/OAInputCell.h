//
//  OAInputCell.h
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAModel.h"
#import <YYTextView.h>
@class OAInputCell;
typedef void(^SelctEndBlock)(NSString *text,NSString *ID,NSInteger index);

@interface OAInputCell : UITableViewCell

@property (nonatomic,strong)OAModel *model;

@property (nonatomic,strong)UITextField *inputText;

@property (nonatomic, copy) SelctEndBlock selectEndBlock;


@end
