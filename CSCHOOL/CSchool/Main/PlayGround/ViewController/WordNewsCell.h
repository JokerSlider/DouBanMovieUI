//
//  WordNewsCell.h
//  CSchool
//
//  Created by mac on 17/1/17.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WorldNewsModel : NSObject
/*
 TITLE 标题
 SOURCE 信息来源
 ARTICLEURL  URL地址
 PUBLISHTIME 发布时间
 CREATETIME 创建时间
 SHOWTIME 显示时间
 */
@property (nonatomic,copy)NSString *TITLE;
@property (nonatomic,copy)NSString *SOURCE;//信息来源
@property (nonatomic,copy)NSString *ARTICLEURL;//URL
@property (nonatomic,copy)NSString *PUBLISHTIME;//发布时间
@property (nonatomic,copy)NSString *CREATETIME;//创建时间
@property (nonatomic,copy)NSString *SHOWTIME;//显示时间
@property (nonatomic,copy)NSString *READCOUNT;//站内浏览次数
@property (nonatomic, strong) NSArray *PHOTOURL;//缩略图  IRIURL
@property (nonatomic, copy) NSString *GROUPNAME;//tag

//@property (nonatomic, copy) NSString *title;//标题  AUITITLE
//@property (nonatomic, copy)  NSString *addressName;//地址  AUIADDRESS
//@property (nonatomic, strong) NSString  *tagName;//标签
//@property (nonatomic, strong) NSString *type;//类型  区分不同的功能  （二手市场，失物招领，兼职招聘）
//@property (nonatomic,copy)NSString *releaseTime;//发布时间 AUIRELEASETIME
//@property (nonatomic,copy)NSString *txtInfo;//描述信息  AUICONTENT
//@property (nonatomic,copy)NSString *price;//价格  AUIPRICE
//@property (nonatomic,copy)NSString *name;//发布人姓名 DPCNAME
//@property (nonatomic,copy)NSString *ID;//信息 id
//@property (nonatomic,copy)NSString *state;//消息状态
//@property (nonatomic,copy)NSString *infoType;//发布类型  求购 or  卖出
//@property (nonatomic,copy)NSString *thumb;
//@property (nonatomic,copy)NSString *tagID;//标签的iD
//@property (nonatomic,copy)NSString *AUIQQ;//qq联系方式
//@property (nonatomic,copy)NSString * AUIWEIXIN;//微信
//@property (nonatomic,copy)NSString *AUIPHONE;//电话
//@property (nonatomic,copy)NSString *infoContactName;//联系人
//@property (nonatomic,copy)NSString *isSearch;//是否是从搜索界面进来的
//@property (nonatomic,copy)NSString *sellType;//买 或者 卖
//@property (nonatomic, copy) NSString *priceType; //价格类型（元/周；面议 等）
//@property (nonatomic, copy) NSString *priceTypeId; //价格类型ID
//@property (nonatomic,copy)NSString *nickName;//昵称
//@property (nonatomic,copy)NSString *photoImageUrl;//头像
@end


@interface WordNewsCell : UITableViewCell
@property (nonatomic,strong)WorldNewsModel *model;
@end

