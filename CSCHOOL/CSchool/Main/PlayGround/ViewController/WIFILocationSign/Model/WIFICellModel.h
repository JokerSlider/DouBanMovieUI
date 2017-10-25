//
//  WIFICellModel.h
//  CSchool
//
//  Created by mac on 17/6/28.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIFICellModel : NSObject

@property (nonatomic,copy)NSString *funcID;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSArray  *titleArr;
@property (nonatomic,copy)NSString *state;//签到状态
@property (nonatomic,copy)NSString *duePeoNum;//应到人数
@property (nonatomic,copy)NSString *actualPeoNum;//实到人数
@property (nonatomic,copy)NSString *leavePeoNum;//请假人数
@property (nonatomic,copy)NSString *ratePeoNum;//缺勤人数
@property (nonatomic,copy)NSString *stuNum_wifi;//学号
@property (nonatomic,copy)NSString *stuName;//学生姓名
@property (nonatomic,copy)NSString *courseName;//课程名，
@property (nonatomic,copy)NSString *meetState;//签到状态
@property (nonatomic,copy)NSString *apState;//AP定位状态
@property (nonatomic,copy)NSString *className;//AP定位状态
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *result;



 @property (nonatomic,copy)NSString *aci_id; //用户签到ID
 @property (nonatomic,copy)NSString *xm; // 姓名
 @property (nonatomic,copy)NSString *aci_creattime;//  用户签到创建时间
@property (nonatomic,copy)NSString *teacher;
 @property (nonatomic,copy)NSString *kcmc; //课程名称
 @property (nonatomic,copy)NSString *aci_state;// 签到状态 1、未签到 2、已签到、3、学生补签、4、教师代签 5、补签待处理 6.补签不通过
 @property (nonatomic,copy)NSString *aci_state_ad; // AP的位置验证状态 1 未验证 2 位置验证成功 3 位置验证失败 4 mac不存在无法验证
 @property (nonatomic,copy)NSString*yh_mac_state ;//用户MAC状态 1 正常 2 异常

@property (nonatomic,copy)NSString *tls_id;//发起签到ID
@property (nonatomic,copy)NSString *yhbh;//用户编号
@property (nonatomic,copy)NSString *sds_code;//学校识别码
@property (nonatomic,copy)NSString *tls_class;//班级代码
@property (nonatomic,copy)NSString *bjm;//班级名称
@property (nonatomic,copy)NSString *tls_creattime;//发起签到时间
@property (nonatomic,copy)NSString *tls_kch;//课程号
@property (nonatomic,copy)NSString *tls_kcmc;//课程名称
@property (nonatomic,copy)NSString *tls_name;//发起签到名称描述
@property (nonatomic,copy)NSString *yd_count;//应到人数
@property (nonatomic,copy)NSString *wd_count;//未到人数
@property (nonatomic,copy)NSString *sd_count;//实到人数
@property (nonatomic,copy)NSString *tls_state;//tls_state

@property (nonatomic,copy)NSString *count;//应到人数
@property (nonatomic,copy)NSString *kch;//TM040040  课程号
@property (nonatomic,copy)NSString *bjdm;//班级代码
@property (nonatomic,copy)NSString *zymm;//专业名称
@property (nonatomic,copy)NSString *zydm;//专业代码
@property (nonatomic,copy)NSString *qj_count;//请假人数

 @property (nonatomic,copy)NSString *ok_count;//正常签到
 @property (nonatomic,copy)NSString * bq_count;//补签次数
 @property (nonatomic,copy)NSString *no_count;//未签到次数
@property (nonatomic,copy)NSString *aci_remark;//申请理由
@end
