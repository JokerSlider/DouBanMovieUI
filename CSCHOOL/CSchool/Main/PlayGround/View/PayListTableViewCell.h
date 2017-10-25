//
//  PayListTableViewCell.h
//  CSchool
//
//  Created by 左俊鑫 on 16/1/13.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYModel.h"

typedef enum : NSUInteger {
    PaySucess, //已支付
    PayWaiting, //待支付
    PayCancel, //已取消
} PayStatus;

@interface PayListModel : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderFee;
@property (nonatomic, strong) NSString *payBit;
@property (nonatomic, strong) NSString *payTime;
@property (nonatomic, assign) PayStatus payStatus;
@property (nonatomic, strong) NSString *orderOutdateTime;

@property (nonatomic, copy) NSString *orderPackageName;
@property (nonatomic, copy) NSString *orderPayString;
@property (nonatomic, copy) NSString *orderState;
@property (nonatomic, copy) NSString *orderCreateTime;
@property (nonatomic, copy) NSString *orderClientPackagePeriod; //时长

@property(nonatomic,copy)NSString   *orderFunction;


@end

@interface PayListTableViewCell : UITableViewCell

@property (nonatomic, strong) PayListModel *model;

@end
