//
//  UserModel.h
//  CSchool
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
-(instancetype)initWithDic:(NSDictionary *)dic;
@property(nonatomic,retain)NSDictionary *map;
/*
 
 userId	string	否	用户名。不能以空格开头或结尾，可以包含任意中英文，字符和数字，但<, >, %, \, @, ", '等特殊字符除外!长度不能超过32个字节
 userName	string	是	用户姓名，可以包含任意中英文，字符和数字，但 <, >, \, ', " 这五个特殊字符除外。长度不能超过64个字节
 userGroupName	string	否	用户组名，中英文字符集校验方式，长度不超过64个字节
 atName	string	否	模板名
 packageName	string	否	用户套餐
 sex	int	是	性别，只能为0—未选择1—男2—女
 freeAuthen	int	否	免接入控制校验 ,1—表示需要校验，2—免校验
 certType	int	是	证件类型。只能为0—未选择(其他)1—身份证2—学生证3—军官证4—护照
 certNo	string	是	证件号码
 edu	string	是	文化程度，只能为0—未选择(其他)1—小学2—初中3—高中4—专科5—本科6—硕士7—博士8—博士后
 address	string	是	用户地址，中文字符集校验方式。长度不能超过64个字节
 postCode	string	是	用户邮编，英文字符集校验方式。长度不能超过16个字节
 tel	string	是	电话号码，英文字符集校验方式。长度不能超过32个字节
 mobile	string	是	手机号码，英文字符集校验方式。长度不能超过32个字节
 email	string	是	邮箱地址
 userIp	string	是	用户ip地址。此字段不返回，若要返回此字段请使用接口findUserBindInfoByUserId(查询用户绑定信息)
 authorIp	string	是	下传ipv4
 authorIpV6	string	是	下传ipv6
 filterId	string	是	VPN服务器ACL名，字符校验为匹配ASCII码中除<,>,\这三个字符以外所有字符
 loginInfo	string	是	登录信息，上线信息不超过247个字节
 userPrivilege	string	是	用户权限，值为0-2147483647之间
 userVlan	string	是	用户vlan，值为0-4094之间
 vlanName	string	是	用户所属VLAN名称(MX专用)，字符校验为匹配ASCII码中除了<,>,\这三个字符以外所有字符，不能全部为数字，长度不超过16个字节
 baclName	string	是	bacl名，只能包含英文, 数字, 中文, 以及"_", "-", "@", "."这四个特殊符号, 且不能以"_"开头，长度不超过32个字节
 selfServPrem	string	否	自助权限，只能包含英文, 数字, 中文, 以及"_", "-", "@", "."这四个特殊符号, 且不能以"_"开头，长度不超过64个字节
 autologicDestroyTime	dateTime	是	自动预销户时间
 stateFlag	int	是	用户状态 1—暂停 2—正常
 periodLimitTime	dateTime	是	周期最大限制时间
 nextBillingTime	dateTime	是	用户周期计费规则的下次记帐时间
 policyId	string	是	计费策略名
 suspendTime	dateTime	是	暂停时间
 latestSelfSuspendTime	dateTime	否	最近自助暂停时间
 latelyLogoutTime	dateTime	是	最近下线时间
 expireTime	dateTime	是	本周期截止时间
 accountId	string	是	账户名
 canOverDraft	boolean	是	是否可以透支
 overDraftFee	decimal	是	信用额度(元)
 overDraftFeeLeft	decimal	是	可用额度(元)
 accountState	int	是	账户状态。1—正常 2—透支 3—欠费 100—余额不足
 accountFee	decimal	是	账户余额
 preAccountFee	decimal	是	待扣款余额
 suVersion	string	是	su版本
 onlineState	int	是	在线状态。0—不在线 1—在线
 field1~field20	string	是	自定义字段1~20
 
 operatorsName	string	是	运营商名，长度不能超过32个字节
 operatorsUserId	string	是	运营商账户。不能以空格开头或结尾， 可以包含任意中英文，字符和数字， 但<, >, %, \, @, ", '等特殊字符除外!长度不能超过32个字节
 createTime	dateTime	否	开户时间
 periodStartTime	dateTime	否	周期计费开始时间
 */
//用户姓名
@property(nonatomic,copy)NSString *userName;
//套餐
@property(nonatomic,copy)NSString *packageName;
//余额
@property(nonatomic,copy)NSString *accountFee;
















@end
