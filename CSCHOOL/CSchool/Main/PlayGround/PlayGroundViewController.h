//
//  PlayGroundViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayGroundViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *hidden;
//是否上网唯一标示
@property(nonatomic,assign)BOOL checkNet;
/**用户信息**/
//用户名
@property(nonatomic,copy)NSString *userName;
//套餐
@property(nonatomic,copy)NSString *packageName;
//余额
@property(nonatomic,copy)NSString *accountFee;
//模板名
@property(nonatomic,copy)NSString *atName;

//用户名
@property(nonatomic,copy)NSString *accountID;
//本科生 包月
@property(nonatomic,copy)NSString *policyId;
//当前系统时间
@property(nonatomic,copy)NSString *  currentTime;
//到期事件
@property(nonatomic,copy)NSString *nextBillingTime;
//周期计费开始时间
@property(nonatomic,copy)NSString *periodStartTime;
//周期最大限制时间  可能有   可能没有
@property(nonatomic,copy)NSString *periodLimitTime;

@property(nonatomic,assign)long stateFlag;



//-(void)LogoutToNet;
@end
