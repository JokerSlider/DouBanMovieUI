//
//  WorldNewsFirstSelectViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 17/1/19.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CloseVCBlock)(NSArray *selectArray);
@interface WorldNewsFirstSelectViewController : BaseViewController

@property (nonatomic, copy) CloseVCBlock closeVCBliock;

@end
