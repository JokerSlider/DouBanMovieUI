//
//  MyPublishViewController.h
//  CSchool
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^Block)(NSString *relType);

@interface MyPublishViewController : BaseViewController
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong)NSArray *infoButtonTitleArr;
@property (nonatomic,copy)NSString *funcType;

@property (nonatomic, copy) Block block;
@end
