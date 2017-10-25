//
//  YunListCell.h
//  CSchool
//
//  Created by 左俊鑫 on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LEOWebDAVItem.h"

typedef void(^ShowButtonClick)(LEOWebDAVItem *model);

@interface YunListCell : UITableViewCell

@property (nonatomic, retain) LEOWebDAVItem *model;

@property (nonatomic, copy) ShowButtonClick showButtonClick;

- (void)viewSelected;

@end
