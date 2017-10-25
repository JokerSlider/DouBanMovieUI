//
//  WIFIChoseClassController.h
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@class WIFICellModel;
typedef void(^ChooseCourseBlock)(NSString *text,NSString * ID);//选择课程
typedef void(^ChooseClassNameBlock)(WIFICellModel *model);//选择班级

typedef enum{
    CouresType=0,
    ClassType=1
}WIFIChooseType;


@interface WIFIChoseClassController : BaseViewController
@property (nonatomic, copy) ChooseClassNameBlock classBlock;//选择班级
@property (nonatomic,copy) ChooseCourseBlock   courseBlock;//选择课程
@property (nonatomic,copy)NSString *classID;//班级ID
@property (nonatomic, assign) WIFIChooseType chooseType; // 类型
@end
