//
//  OAChoseViewController.h
//  CSchool
//
//  Created by mac on 17/6/21.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^OAChooseListBlock)(NSArray *objArr);

@interface OAChoseViewController : BaseViewController
@property (nonatomic,copy)NSArray   *objArr;
@property (nonatomic,copy)NSArray   *defaultArr;//默认选中
@property (nonatomic, copy) OAChooseListBlock OAChooseListBlock;

@property (nonatomic,assign)BOOL  isMoreSelct;//是否可以多选
@end
