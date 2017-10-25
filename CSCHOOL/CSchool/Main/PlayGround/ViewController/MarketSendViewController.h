//
//  MarketSendViewController.h
//  CSchool
//
//  Created by 左俊鑫 on 16/10/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "BaseViewController.h"
#import "FindLoseModel.h"
typedef void(^SendSucessBlock)(NSString *relType);

@interface MarketSendViewController : BaseViewController

@property (nonatomic, copy) NSString *module; //1-失物招领  2-二手市场  3-兼职招聘
@property (nonatomic, copy) NSString *reltype; //1:卖 2：买

@property (nonatomic, retain) FindLoseModel *model; //编辑，传入model

@property (nonatomic, copy) SendSucessBlock sendSucessBlock;

@end
