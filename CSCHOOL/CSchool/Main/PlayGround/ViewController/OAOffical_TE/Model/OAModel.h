//
//  OAModel.h
//  CSchool
//
//  Created by mac on 17/6/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface OAModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *imgName;
//@property (nonatomic,strong)NSArray *funtionAry;//功能数组
@property (nonatomic,copy)NSString *tag;


@property (nonatomic,copy)NSString *subTitle;
@property (nonatomic,copy)NSString *cellNum;//序号
@property (nonatomic,copy)NSString *totalCount;//数组总数
@property (nonatomic,copy)NSString *segmentName;
@property (nonatomic,copy)NSString *isNotice;//是否有新通知

/*
 @"procesName":@"用印流程",
 @"procesTime":@"2017-09-01  09:09",
 @"procesPerson":@"王大伟",
 @"procesState":@"未审批",
 @"noticeWord":@"管理员对该流程进行了催办，请及时处理"
 */
@property (nonatomic,copy)NSString *procesName;
@property (nonatomic,copy)NSString *procesTime;
@property (nonatomic,copy)NSString *procesPerson;
@property (nonatomic,copy)NSString *procesState;
@property (nonatomic,copy)NSString *noticeWord;
@property (nonatomic,copy)NSString *suggestion;
@property (nonatomic,copy)NSString *nextProcePerson;
/*
 @"procesTimeArr":@[@"发起时间",@"2017-09-01  09:09"],
 @"procesPersonArr":@[@"发起人",@"王大伟"],
 @"procesStateArr":@[@"状态",@"未审批"],
 @"suggestionArr":@[@"审批意见",@"管理员对该流程进行了催办，请及时处理!"],
 @"nextProcePersonArr":@[@"下一级审批人",@"刘连成"]

 */

@property (nonatomic,copy)NSString *funcID;

/*

 fieldLable – 字段说明
 filedName – 字段名称
 defaultValue—默认
 fieldType – 字段类型
 select、textarea、datatime、data、text、number、checkbox、radio、hidden
 content 类型内容
 key
 value

 **/
@property (nonatomic,copy)NSString *fieldLable;//字段说明
@property (nonatomic,copy)NSString *filedName;//字段名称
@property (nonatomic,copy)NSString *filedSubTitle;//字段名称
@property (nonatomic,copy)NSString *fi_id;//工单id
@property (nonatomic,copy)NSArray *defaultValue;//默认
@property (nonatomic,copy)NSString *fieldType;//字段类型checkbox（多选）、radio（单选）、 select（单选 ） textarea（大文字输入）、datetime(年月日时分秒)、data（年月日）、text、number（数字）、hidden（隐藏）
@property (nonatomic,copy)NSArray *content;//组名  或者   功能名
@property (nonatomic,copy)NSString *value;//键值对
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *mi_id;
@property (nonatomic,copy)NSString *mi_name;//组名  或者   功能名
@property (nonatomic,copy)NSString *mi_state;//是否可用
@property (nonatomic,copy)NSArray *data;//是否可用
/*
 {
 out_name : 校领导,
	state : 4,
	yhbh : 000001,
	sds_code : sdjzu
"
 },
 */
@property (nonatomic,copy)NSString *out_name;//;职位名称 或者
@property (nonatomic,copy)NSString *yhbh;//用户吧编号
@property (nonatomic,copy)NSString *state;//是否可用
@property (nonatomic,copy)NSString *sds_code;//是否可用
@property (nonatomic,copy)NSString *xm;//是否可用
@property (nonatomic,copy)NSString *zgh;//是否可用

@property (nonatomic,assign)BOOL selectState;//默认选中
@property (nonatomic,copy)NSString *badgeValue;//角标
@property (nonatomic,copy)NSString *ni_id;// -- 节点编号
@property (nonatomic,copy)NSString *ni_name;// -- 节点名称
@property (nonatomic,copy)NSString *icon_xh;//图标虚序号
/*
 oi_id 工单编号
 fi_id流程编号
 fi_name流程名称
 node_id 当前节点编号
 ni_name 当前节点名称
 create_time申请时间
 oi_state 工单状态 0  暂存  1 未审批 2 审批中 3 审批完成 4 退回
 new_time 最新审批时间
 yhbh 用户编号
 xm  姓名
 spxm 审批人姓名
 sp_state 审批状态 1 待审批 2 已审批

 */

@property (nonatomic,copy)NSString *fi_name;//流程吗
@property (nonatomic,copy)NSString *create_time;// 发起时间
//@property (nonatomic,copy)NSString *new_time;// --审批时间
@property (nonatomic,copy)NSString *spxm;// -- 审批人姓名
@property (nonatomic,copy)NSString *sp_state;// 审批状态
@property (nonatomic,copy)NSString *oi_state;// -- 工单状态 0  暂存  1 未审批 2 审批中 3 审批完成 4 退回
@property (nonatomic,copy)NSString *oi_id;// -- 工单编号
@property (nonatomic,copy)NSString *node_id;// -- 节点编号
@property (nonatomic,copy)NSString *ni_xh;


/*
    ni_id  节点编号
   ci_id字段编号
   sfbj 字段是否可编辑
   sfkj字段是否可见
   sfbt 字段是否必填
    colume_name  字段名
 colume_type  字段类型
 colume_num 字段长度
 colume_description字段备注
 o_value  内容
 out_default  默认值

 **/
//@property (nonatomic,copy)NSString *ni_id;// 审批状态
@property (nonatomic,copy)NSString *ci_id;// 审批状态
@property (nonatomic,copy)NSString *sfbj;// 字段是否可编辑;
@property (nonatomic,copy)NSString *sfkj;//字段是否可见
@property (nonatomic,copy)NSString *sfbt;// 字段是否必填
@property (nonatomic,copy)NSString *colume_name;//  字段名
@property (nonatomic,copy)NSString *colume_type;// 字段类型
@property (nonatomic,copy)NSString *colume_num;// 字段长度
@property (nonatomic,copy)NSString *colume_description;// 字段备注
@property (nonatomic,copy)NSString *o_value;// -内容
@property (nonatomic,copy)NSString *out_default;//  默认值


/**
 create_time 时间日期
 data 信息数组，内容如下:
 oi_state 3, --工单状态 1 正常流转 0  暂存 2 审批中 3 审批完成 4 退回
 oh_state 操作状态 1 通过 2 不通过 3 退回
 xm审批人
 create_time审批时间
 oh_descrite审批意见
 ni_id当前节点
 ni_name节点名称
 count下一步节点数量
 users下一步审批人
 last_time处理时间

 */
@property (nonatomic,copy)NSString *oh_state;// 工单状态 1 正常流转 0  暂存 2 审批中 3 审批完成 4 退回
@property (nonatomic,copy)NSString *oh_descrite;// 审批意见;
@property (nonatomic,copy)NSString *users;//下一步审批人
@property (nonatomic,copy)NSString *last_time;// 处理时间
@property (nonatomic,copy)NSString *t_name;






@property (nonatomic,copy)NSString *   md_message;// 审批意见















@end
