//
//  SportsMainCell.h
//  CSchool
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SportModel;
@interface SportsMainCell : UITableViewCell
@property (nonatomic,strong)SportModel *model;
@end

@interface SportModel : NSObject

//UMISTEPNUMBER 步数
//UMBIMGURL 背景图URL
//UMBPOINTSSUM 获赞总数
@property (nonatomic,copy)NSString *UMISTEPNUMBER;//步数
@property (nonatomic,copy)NSString *UMBTROPHYSUM;//UMBTROPHYSUM// integer 奖牌数
@property (nonatomic,copy)NSString *UMBIMGURL;//背景图
@property (nonatomic,copy)NSString *UMBPOINTSSUM;//获赞总数
@property (nonatomic,copy)NSString *UMIDATE;// 日期
@property (nonatomic,copy)NSString *NC;// 昵称
@property (nonatomic,copy)NSString *UMICAL;// 卡路里
@property (nonatomic,copy)NSArray *OUT_NAME;  //点赞人数组
@property (nonatomic,copy)NSString *PM;// 排名
@property (nonatomic,copy)NSString *TXDZ; //头像地址

@property (nonatomic,copy)NSString *XM ; //-姓名
@property (nonatomic,copy)NSString *SDSNAME;  //-学校名称
@property (nonatomic,copy)NSString *GROUPNAME;// 群组名称
@property (nonatomic,copy)NSString *DESCRIPTION;// 描述
@property (nonatomic,copy)NSString *SCODE;//学校code
@property (nonatomic,copy)NSString *ROOMJID; //: 123,
@property (nonatomic,copy)NSString *ROOMID;// : 69,

//弹幕
@property (nonatomic,copy)NSString *SMITIME;// 时间
@property (nonatomic,copy)NSString *SMICONTENT;// 内容

@property (nonatomic,copy)NSString *xm;
@property (nonatomic,copy)NSString *txdz;// 头像地址
@property (nonatomic,copy)NSString *nc;// 昵称
@property (nonatomic,copy)NSString *umi_stepnumber;// 步数
@property (nonatomic,copy)NSString *count;// 被赞次数
@property (nonatomic,copy)NSString *yhbh;// 用户ID
@property (nonatomic,copy)NSString *sds_code;// 学校编码
@property (nonatomic,copy)NSString *pm;// 排名
@property (nonatomic,copy)NSString *umb_imgurl;// 背景地址
@property (nonatomic,copy)NSString *state;// 是否被自己点赞
@property (nonatomic,copy)NSArray *children;// 子节点，好友信息
@property (nonatomic,copy)NSString *umi_id;//信息ID


@end
