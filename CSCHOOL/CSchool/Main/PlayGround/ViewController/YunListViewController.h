//
//  YunListViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 17/4/26.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@class LEOWebDAVItem;

@interface YunListViewController : BaseViewController

-(id)initWithPath:(NSString *)path;
-(id)initWithItem:(LEOWebDAVItem *)_item;

- (void)reloadData;

@end
