//
//  OATextViewEditController.h
//  CSchool
//
//  Created by mac on 17/6/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^OATextViewEditBlock)(NSString *text);

@interface OATextViewEditController : BaseViewController
@property (nonatomic, copy) OATextViewEditBlock OAtextViewEditBlock;
@property (nonatomic,copy)NSString *placeholderText;
@property (nonatomic,copy)NSString *contentText;

@property (nonatomic,assign) int  maxWordCount;//最大字数限制
@end
