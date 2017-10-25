//
//  NewIndexViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 2017/10/10.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface NewIndexViewController : BaseViewController

- (void)logSuccess;
//处理全功能
-(void)handleFuncMessage:(NSNotification*)note;

-(void)removeAllFunction:(NSNotification*)note;
@end
