//
//  AppUserIndex.h
//  CSchool
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUserIndex : NSObject

@property (assign,nonatomic) BOOL isLogin; //是否登录

@property (assign,nonatomic) BOOL singleValue; //是否可以上网
@property (copy,nonatomic) NSString * API_URL;
@property(copy,nonatomic)NSString *LogoutURL;

@property(nonatomic,copy)NSString *BaseUrl;//新的一键上网基础版本
//一一键上网标示
@property(copy,nonatomic)NSString *userIndex;
//新版本一键上网的userAgent
@property (nonatomic,copy)NSString *userAgent;
@property (nonatomic,copy)NSString *userIp;//一键上网的ip地址

@property(nonatomic,copy)NSString *  tokenTime;
@property (nonatomic, copy) NSString *token;
//学校姓名
@property(nonatomic,copy)NSString *schoolName;

//用户ID
@property(nonatomic,copy)NSString *userId;
//用户姓名
@property(nonatomic,copy)NSString *userName;

//用户密码
@property (nonatomic,copy) NSString *passWord;//密码

//用户套餐
@property(nonatomic,copy)NSString *packageName;
//余额
@property(nonatomic,copy)NSString *accountFee;
//模板名
@property(nonatomic,copy)NSString *atName;
//schoolID
@property(nonatomic,copy)NSString *schoolId;

//用户ID
@property (nonatomic, copy) NSString *accountId;

//用户密码
//@property (nonatomic,copy) NSString *passWord;//密码
//loginID用户唯一标示
@property(nonatomic,copy)NSString *loginId;

@property (nonatomic,copy)NSString *SJXH;//手机小号

@property (nonatomic,copy)NSString *BGDD;//办公地点
//到期时间
@property (nonatomic, copy) NSString *nextBillingTime;

//包学期
@property(nonatomic,copy)NSString *termBillingTime;
//本科生包月
@property(nonatomic,copy)NSString *policyId;
//系统时间
@property(nonatomic,copy)NSString * currentTime;
@property(nonatomic,copy)NSString *wifiName;
@property(nonatomic,copy)NSString *serverIpAddress;

@property (nonatomic, copy) NSString *periodStartTime;

@property (nonatomic, copy) NSString *epurl;

@property (nonatomic, assign) BOOL isUpdate;

//学校编码（用于传给服务器）
@property (nonatomic, copy) NSString *schoolCode;

//学校logo
@property (nonatomic, copy) NSString *schoolLogo;
//学校logo背景
@property (nonatomic,copy)NSString *schoolLogonBackgroundImage;
//账户是否可以缴费
@property (nonatomic, assign) BOOL canPayNetFee;
//账户是否可以修改密码
@property (nonatomic, assign) BOOL canModifyPassword;
//课程表存储数据
@property(nonatomic,strong)NSMutableArray *widArr;
@property(nonatomic,strong)NSMutableDictionary  *kssjDic;
@property(nonatomic,strong)NSMutableDictionary  *jssjDic;
@property(nonatomic,strong)NSMutableArray *schoolCalenderArr;

//课程表数据
@property(nonatomic,strong)NSArray *courseArr;

//空教室课程表数据
@property(nonatomic,strong)NSArray *emptyClassCourseArr;

//报修联系人姓名
@property (nonatomic, strong) NSString *repairName;

//报修联系电话
@property (nonatomic, strong) NSString *repairPhoneNum;

//用户角色类型  1:老师 2：学生
@property (nonatomic,copy)NSString *role_type;
//角色id
@property (nonatomic,copy)NSString *role_id;
//角色名
@property (nonatomic,copy)NSString *role_username;

//是否为新生
@property (nonatomic, assign) BOOL isNewEntry;

@property (nonatomic, copy) NSString *aNewEntryId; //新生考号

@property (nonatomic, assign) BOOL isBundPhone; //是否显示绑定手机号页面

//工资、公积金用户名（只有老师角色）
@property (nonatomic,copy)NSString *salaryUserName;
//工资、公积金密码（只有老师角色）
@property (nonatomic,copy)NSString *salaryPWD;
@property (nonatomic,strong)NSArray *salaryUserInfoArr;

//存放app中所有功能的数组，根据此数组来布局首页功能（queryUserInfo获取）
@property (nonatomic, strong) NSArray *appListArray; //⚠️已经启用 2017.01.12

@property (nonatomic, retain) NSArray *hotListArray; //热门推荐的数组列表，布局首页 17.01.12新增

@property (nonatomic, retain) NSArray *fileListArray;//文件夹样式存放数组，布局首页 17.01.12新增

@property (nonatomic,retain) NSArray   *iconIDArray;//首页图标ID

//accountId 用户id，用于提交给服务器查询课程表等数据用（测试账号test1此值一直未写死学号）
@property (nonatomic, strong) NSString *subAccountId;


//存放用户手机会议日历提醒
@property (nonatomic, strong) NSMutableDictionary *meetingNoticDic;

@property (nonatomic, copy) NSString *uploadUrl; //二手市场图片上传url

@property (nonatomic, copy) NSString *personUrl; //头像上传路径

@property (nonatomic, copy) NSString *photowallUrl; //头像上传路径

@property (nonatomic, copy) NSString *sex; //性别

@property (nonatomic, copy) NSString *birthDay; //生日

@property (nonatomic, copy) NSString *phoneNum; //手机号

@property (nonatomic, copy) NSString *address; //住址

@property (nonatomic, copy) NSString *ZYJSZWM; //技术职称（部分老师存在）

@property (nonatomic, copy) NSString *departName; //职位名

@property (nonatomic, copy) NSString *seniorName; //工作部门

@property (nonatomic, copy) NSString *continueSignDays; //连续签到天数

@property (nonatomic, copy) NSString *flowerNum; //鲜花数量

@property (nonatomic, copy) NSString *nickName; //昵称

@property (nonatomic, copy) NSString *headImageUrl; //头像地址

@property (nonatomic, assign) BOOL signStatus; //签到状态

@property (nonatomic, copy) NSString *majorName; //专业名称

@property (nonatomic,copy)NSString *personnote;//个人说明

@property (nonatomic,copy)NSString *jobAddress; //现住址

@property (nonatomic, assign) BOOL isUseChat; //是否启用聊天

@property (nonatomic,copy)NSString *userInputPhonenum;//用户输入的手机号
@property (nonatomic,assign)BOOL isShowPhone;//是否填手机号
@property (nonatomic,assign)BOOL eportalVer;//是否使用新的一键上网

@property (nonatomic, strong) NSArray *yanzhengPhoneArray; //存放已经验证手机的手机号

@property (nonatomic, assign) BOOL isUp; //是否弹出绑定页面（新生才有）

@property (nonatomic, copy) NSString *XYMC; //学院名称

@property (nonatomic, copy) NSString *BJMC; //班级名称

@property (nonatomic, copy) NSString *SSLH; //宿舍楼号

@property (nonatomic, copy) NSString *SSMC; //宿舍名称

@property (nonatomic, assign) BOOL XSJF; //新生是否缴费

@property (nonatomic, copy) NSDictionary *pushUserInfo; //推送内容

@property (nonatomic, copy) NSArray *funcMsgArr; //系统消息内容

//实现单例方法
+ (AppUserIndex *) GetInstance;

-(void)cleanAllProperty;
-(void)copyAllProperty:(AppUserIndex *)firUser;
-(void)readFromFile;
-(void)saveToFile;

-(void)cleanAndSave;
@end
