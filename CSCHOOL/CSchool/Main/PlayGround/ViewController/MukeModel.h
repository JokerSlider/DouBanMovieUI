//
//  MukeModel.h
//  CSchool
//
//  Created by mac on 16/11/5.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
/**
 ctEndTime = 1486740600000;
 ctId = 1001795014;
 ctImgUrl = "http://img2.ph.126.net/Pi-k3AX09Y8XVBePjsJJEQ==/6597828429681640478.jpg";
 ctLectorAdo =                 (
 {
 name = "战德臣";
 openUid = 3fdac18cb73229c8db09da0a0f8b84bd1507001;
 type = 0;
 */

@interface MukeModel : NSObject
@property (nonatomic,copy)NSString *ctImgUrl;//图片地址
@property (nonatomic,copy)NSString *name;//课程名
@property (nonatomic,copy)NSString *enrollCount;//已有多少人参加
@property (nonatomic,copy)NSString *ctStartTime;//开始时间
@property (nonatomic,copy)NSString *ctEndTime;
@property (nonatomic,copy)NSString *ctUrl;
@end
