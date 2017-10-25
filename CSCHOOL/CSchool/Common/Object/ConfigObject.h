//
//  ConfigObject.h
//  CSchool
//
//  Created by 左俊鑫 on 16/2/1.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigObject : NSObject

+(ConfigObject *)shareConfig;

@property (nonatomic, strong) NSDictionary *oderStateDic; //订单状态码对应

@property (nonatomic, strong) NSMutableDictionary *repairStateDic; //报修状态字典

@property (nonatomic, strong) NSMutableArray *repairCancelResonArr; //报修撤销原因数组

@property (nonatomic, assign) BOOL isPayShowPhone; //缴费页面是否先绑定手机号码（点击缴费显示）

@property (nonatomic, assign) BOOL isShowChangePhone; //是否显示套餐更改手机页面（一登录就显示）

@property (nonatomic, copy) NSString *trip1; //缴费验证手机页面提示文字

@property (nonatomic, copy) NSString *trip2; //次月验证显示手机号

@property (nonatomic, strong) NSDictionary *payInfoDic; //套餐配置信息字典

@property (nonatomic, assign) BOOL isGetInfo; //是否已经拿到内容，防止重复获取

@property (nonatomic, copy) NSString *phoneNum; //验证过的手机号

@property (nonatomic, assign) NSInteger msgCodeNum; //发送验证码次数

- (void)setPayInfo:(NSDictionary *)dic;

- (void)clean;
@end
