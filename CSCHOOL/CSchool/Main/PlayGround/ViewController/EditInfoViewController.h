//
//  EditInfoViewController.h
//  CSchool
//
//  Created by mac on 16/11/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^EditSucessBlock)(NSString *text);

@interface EditInfoViewController : BaseViewController
@property (nonatomic,copy)NSString *placdeTxt;
@property (nonatomic, copy) EditSucessBlock editSucessBlock;

@property (nonatomic,copy)NSDictionary *params;
@end
