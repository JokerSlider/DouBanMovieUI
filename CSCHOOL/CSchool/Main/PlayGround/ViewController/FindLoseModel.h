//
//  FindLoseModel.h
//  CSchool
//
//  Created by mac on 16/10/9.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
@interface FindLoseModel : NSObject
/*
 AUIPHONE 电话
 DPCNAME 发布人
 AUITYPE 类型信息
 AUIADDRESS 地址
 AUIPRICE 价格
 AUIID  编号
 AUISTATUS 消息状态
 AUIRELEASETIME 发布时间
 AUIQQ  QQ
 SDSCODE 学校识别码
 IRIURL 图片信息
 ID 图片ID
 URL 图片地址
 AUITITLE 标题
 AUICONTENT 内容
 AUIWEIXIN 微信
 AUICONTACTNAME 联系人
 CIID 类别编号
 */
@property (nonatomic, copy) NSString *title;//标题  AUITITLE
@property (nonatomic, strong) NSArray *thumblicArray;//缩略图  IRIURL
@property (nonatomic, copy)  NSString *addressName;//地址  AUIADDRESS
@property (nonatomic, strong) NSString  *tagName;//标签
@property (nonatomic, strong) NSString *type;//类型  区分不同的功能  （二手市场，失物招领，兼职招聘）
@property (nonatomic,copy)NSString *releaseTime;//发布时间 AUIRELEASETIME
@property (nonatomic,copy)NSString *txtInfo;//描述信息  AUICONTENT
@property (nonatomic,copy)NSString *price;//价格  AUIPRICE 
@property (nonatomic,copy)NSString *name;//发布人姓名 DPCNAME
@property (nonatomic,copy)NSString *ID;//信息 id
@property (nonatomic,copy)NSString *state;//消息状态
@property (nonatomic,copy)NSString *infoType;//发布类型  求购 or  卖出
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,copy)NSString *tagID;//标签的iD
@property (nonatomic,copy)NSString *AUIQQ;//qq联系方式
@property (nonatomic,copy)NSString * AUIWEIXIN;//微信
@property (nonatomic,copy)NSString *AUIPHONE;//电话
@property (nonatomic,copy)NSString *infoContactName;//联系人
@property (nonatomic,copy)NSString *isSearch;//是否是从搜索界面进来的
@property (nonatomic,copy)NSString *sellType;//买 或者 卖
@property (nonatomic, copy) NSString *priceType; //价格类型（元/周；面议 等）
@property (nonatomic, copy) NSString *priceTypeId; //价格类型ID
@property (nonatomic,copy)NSString *nickName;//昵称
@property (nonatomic,copy)NSString *photoImageUrl;//头像
@end
