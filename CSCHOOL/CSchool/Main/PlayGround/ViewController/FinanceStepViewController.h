//
//  FinanceStepViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/8/2.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceStepViewController : UIViewController

@property (nonatomic, strong) NSDictionary *typeDic;

@property (nonatomic, assign) BOOL isDetail; //是否只是查看，不进行下一步操作。
@end
