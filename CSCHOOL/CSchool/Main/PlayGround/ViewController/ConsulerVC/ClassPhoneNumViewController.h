//
//  ClassPhoneNumViewController.h
//  CSchool
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassPhoneNumViewController : BaseViewController
@property (nonatomic , copy)NSString *classID;//班级id
//存放班级  年级   学院的 字典
@property (nonatomic,strong)NSArray *seniorArr;;
@end
