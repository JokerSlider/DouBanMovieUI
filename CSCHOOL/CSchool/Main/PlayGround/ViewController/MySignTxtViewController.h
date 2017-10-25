//
//  MySignTxtViewController.h
//  CSchool
//
//  Created by mac on 16/11/17.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^EditSucessBlock)(NSString *text);

@interface MySignTxtViewController : BaseViewController
@property (nonatomic,copy)NSString *placdeTxt;
@property (nonatomic, copy) EditSucessBlock editSucessBlock;

@end
