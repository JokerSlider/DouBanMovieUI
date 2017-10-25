//
//  SchoolBusView.h
//  CSchool
//
//  Created by mac on 16/12/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFUIbutton.h"
#import <YYModel.h>
@interface SchooBusModel : NSObject
/*
 "name": "管院南线历城校区往返长青校区",
 "isStatic": false,
 "lastModificationTime": null,
 "lastModifierUserId": null,
 "creationTime": "2016/12/15 11:59:12",
 "creatorUserId": 955,
 "id": 1012
 
 name 线路名称
 isStatic 是否静止（不使用）
 lastModificationTime 最后修改时间
 lastModifierUserId 最后修改人ID
 creationTime 创建时间
 creatorUserId 创建人ID
 id  ID
 
 d    ID
 groupId 线路ID
 name  站点名称
 longitude 经度
 latitude  纬度
 disEndLength 距离终点长度
 sortNum 排序字段
 isStart  是否起点
 isEnd  是否终点
 stationAway  距离上站距离
 
 
 deviceNum  设备号
 disendlength 距离终点长度
 nextStationName 下站名称
 disnextlength 距离下站长度
 disendtim 距离终点时间（单位：分）
 disnexttim 距离下站时间（单位：分）
 trip 提示
 */
@property (nonatomic,copy)NSString *busName;//路线名
@property (nonatomic,copy)NSString *busLodId;//路线ID
@property (nonatomic,copy)NSString *num;//站点序号
@property (nonatomic,copy)NSString *siteName;//站点名

@property (nonatomic,copy)NSString *busTagName;//备注
@property (nonatomic,copy)NSString *info;//
@property (nonatomic,copy)NSString *busStartTime;//班车发车时间
@property (nonatomic,copy)NSString *busEndTime;//收车时间
@property (nonatomic,copy)NSString *isComing;//是否即将来车

@property (nonatomic,copy)NSString *isStart;//是否是起点
@property (nonatomic,copy)NSString *isEnd;//是否是起点
@property (nonatomic,copy)NSString *stationAway;//距离上站距离
@property (nonatomic,copy)NSString *longitude;//经度
@property (nonatomic,copy)NSString *latitude;//纬度
@property (nonatomic,copy)NSString *disEndLength;//距离终点长度

@property (nonatomic,copy)NSString *deviceNum;//车牌号
@property (nonatomic,copy)NSString *disendlength;//距离终点长度
@property (nonatomic,copy)NSString *nextStationName;//下站名称
@property (nonatomic,copy)NSString *disnextlength;//距离下站长度
@property (nonatomic,copy)NSString *disendtim;//距离终点时间
@property (nonatomic,copy)NSString *disnexttim;//距离下站的时间
@property (nonatomic,copy)NSString *trip;//提示

@property (nonatomic,copy)NSString *isShow;//是否展示时间


@end


@interface SchoolBusView : UIView

@property (nonatomic,strong)LFUIbutton *chooseBusBtn;//选择班车按钮就
@property (nonatomic,strong)SchooBusModel *model;
@property (nonatomic,strong)UILabel *startTime;//发车时间
@property (nonatomic,strong)UILabel *endTime;//收车时间
@property (nonatomic,strong)UILabel  *busNameL;//去的路
@end
