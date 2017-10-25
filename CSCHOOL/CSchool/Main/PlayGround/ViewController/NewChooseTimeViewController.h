//
//  NewChooseTimeViewController.h
//  CSchool
//
//  Created by mac on 16/9/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
@protocol TimeChooseDelegate
//必须实现的代理方法
/**
 *  代理方法
 *
 *  @param vc 要push的viewcontroller的根控制器  或是要pop的viewcontroller的子控制器
 */
-(void)pushOrPopMethod:(UIViewController *)vc withStartTime:(NSDictionary *)TimeDic;
@end
@interface NewChooseTimeViewController : BaseViewController
@property (nonatomic,copy)NSString *bookid;//订单号
@property (nonatomic,copy)NSString *totaltime;
@property (nonatomic,copy)NSString *standardInfo;
@property (retain,nonatomic) id <TimeChooseDelegate> delegate;

@end
