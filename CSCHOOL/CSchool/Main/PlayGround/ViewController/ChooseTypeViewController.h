//
//  ChooseTypeViewController.h
//  CSchool
//
//  Created by mac on 16/8/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
typedef enum{
    TimeType=0,
    InvoiceYype=1,
    SalaryType=2,//查询工资
}ChooseType;

@protocol ChooseDelegate
//必须实现的代理方法
/**
 *  代理方法
 *
 *  @param vc 要push的viewcontroller的根控制器  或是要pop的viewcontroller的子控制器
 */
-(void)pushOrPopMethod:(UIViewController *)vc withDataDictionary:(NSDictionary *)dic;
@end

@interface ChooseTypeViewController : BaseViewController
 //将各个类型的数组  按顺序逐一添加到综合数组
@property (retain,nonatomic) id <ChooseDelegate> ChooseDelegate;
@property (nonatomic,strong)NSMutableArray *totalArr;
@property (nonatomic,assign)CGSize *height;
@property (nonatomic,copy)NSString *bookid;

//区分传入参数的类型
@property (nonatomic, assign) ChooseType chooseType; // 类型


@end
