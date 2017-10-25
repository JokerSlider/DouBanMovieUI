//
//  AppUserIndex.m
//  CSchool
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "AppUserIndex.h"

@implementation AppUserIndex

// 单例对象
static  AppUserIndex *instance;

// 单例
+ (AppUserIndex *) GetInstance {
    @synchronized([AppUserIndex class]) {
        if (instance == nil) {
            instance = [[AppUserIndex alloc] init];
        }
    }
    return instance;
}

//与服务器字段一一映射
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userName":@"data.samUserInfo.userName",
             @"packageName":@"data.samUserInfo.packageName",
             @"accountFee":@"data.samUserInfo.accountFee",
             @"atName":@"data.samUserInfo.atName",
             @"accountId":@"data.samUserInfo.accountId",
             @"nextBillingTime":@"data.samUserInfo.nextBillingTime",
             @"termBillingTime":@"data.samUserInfo.termBillingTime",
             @"policyId":@"data.samUserInfo.policyId",
             @"currentTime":@"data.serverCurrentTime",
             @"periodStartTime":@"data.samUserInfo.periodStartTime",
             
             @"schoolLogo":@"schoolInfo.SDS_LOGO",
             @"schoolLogonBackgroundImage":@"schoolInfo.SDS_BGIMAGE",
             @"canPayNetFee":@"data.canPayNetFee",
             @"canModifyPassword":@"data.canModifyPassword",
             @"uploadUrl":@"uploadUrl",
             @"userId":@"data.samUserInfo.userId",
             @"appListArray":@"appInfo",
             @"isUseChat":@"isTalk"
             };
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {

    //roleInfo格式不能直接转换，进行手工处理
    BOOL isSetValue = NO;
    if ([dic objectForKey:@"roleInfo"]) {
        NSArray *roleInfo = [dic objectForKey:@"roleInfo"];
        if ([roleInfo isKindOfClass:[NSArray class]]){
            if ([roleInfo count] > 0) {
                NSDictionary *infoDic = roleInfo[0];
                infoDic[@"XB"]?(self.sex = infoDic[@"XB"]):(self.sex = @"");
                infoDic[@"CSRQ"]?(self.birthDay = infoDic[@"CSRQ"]):(self.birthDay = @"");
                infoDic[@"SJH"]?(self.phoneNum = infoDic[@"SJH"]):(self.phoneNum = @"");
                infoDic[@"CSDM"]?(self.address = infoDic[@"CSDM"]):(self.address = @"");
                infoDic[@"DEPARTNAME"]?(self.departName = infoDic[@"DEPARTNAME"]):(self.departName = @"");
                infoDic[@"SENIORNAME"]?(self.seniorName = infoDic[@"SENIORNAME"]):(self.seniorName = @"");
                infoDic[@"SBICONSECUTIVEDAYS"]?(self.continueSignDays = [NSString stringWithFormat:@"%@",infoDic[@"SBICONSECUTIVEDAYS"]]):(self.continueSignDays = @"0");
                infoDic[@"SBIFLOWERSNUMBER"]?(self.flowerNum = [NSString stringWithFormat:@"%@",infoDic[@"SBIFLOWERSNUMBER"]]):(self.flowerNum = @"0");
                infoDic[@"NICKNAME"]?(self.nickName = infoDic[@"NICKNAME"]):(self.nickName = @"");
                infoDic[@"HEADIMAGE"]?(self.headImageUrl = [infoDic[@"HEADIMAGE"] stringByReplacingOccurrencesOfString:@"/thumb" withString:@""]):(self.headImageUrl = @"");
                infoDic[@"STATUS"]?(self.signStatus = [infoDic[@"STATUS"] boolValue]):(self.signStatus = NO);
                infoDic[@"ZYMC"]?(self.majorName = infoDic[@"ZYMC"]):(self.majorName = @"");
                infoDic[@"ROLE_ID"]?(self.role_id = [NSString stringWithFormat:@"%@",infoDic[@"ROLE_ID"]]):(self.role_id = @"");
                infoDic[@"ROLE_TYPE"]?(self.role_type = [NSString stringWithFormat:@"%@",infoDic[@"ROLE_TYPE"]]):nil;
                infoDic[@"ROLE_USERNAME"]?(self.role_username = infoDic[@"ROLE_USERNAME"]):(self.role_username = @"");
                infoDic[@"ZYJSZWM"]?(self.ZYJSZWM = infoDic[@"ZYJSZWM"]):(self.ZYJSZWM = @"");
                infoDic[@"GRSM"]?(self.personnote=infoDic[@"GRSM"]):(self.personnote=@"");
                infoDic[@"XZZ"]?self.jobAddress=infoDic[@"XZZ"]:(self.jobAddress=@"");
                infoDic[@"SJXH"]?self.SJXH=infoDic[@"SJXH"]:(self.SJXH=@"");
                infoDic[@"BGDD"]?self.BGDD=infoDic[@"BGDD"]:(self.BGDD=@"");
                infoDic[@"YZSJ"]?(self.yanzhengPhoneArray = [infoDic[@"YZSJ"] componentsSeparatedByString:@","]):(self.yanzhengPhoneArray=@[]);
                infoDic[@"XYMC"]?(self.XYMC = infoDic[@"XYMC"]):(self.XYMC = @"");
                infoDic[@"BJMC"]?(self.BJMC = infoDic[@"BJMC"]):(self.BJMC = @"");
                infoDic[@"SSLH"]?(self.SSLH = infoDic[@"SSLH"]):(self.SSLH = @"");
                infoDic[@"SSMC"]?(self.SSMC = infoDic[@"SSMC"]):(self.SSMC = @"");
                infoDic[@"XSJF"]?(self.XSJF = [infoDic[@"XSJF"] boolValue]):(self.XSJF = NO);
                isSetValue = YES;
            }
        }
    }
    if (!isSetValue) {
        self.continueSignDays = @"0";
        self.flowerNum = @"0";
        self.sex = @"";
        self.birthDay = @"";
        self.phoneNum = @"";
        self.address = @"";
        self.departName = @"";
        self.seniorName = @"";
        self.nickName = @"";
        self.headImageUrl = @"";
        self.signStatus = NO;
        self.majorName = @"";
        self.role_id = @"";
        self.role_username = @"";
        self.ZYJSZWM = @"";
        self.personnote = @"";
        self.jobAddress = @"";
        self.SJXH = @"";
        self.BGDD = @"";
    }
    
    if (self.isNewEntry) { //新生取新手功能字段
        self.appListArray = dic[@"newEntry"];
        self.aNewEntryId = self.accountId;
        self.accountId = self.role_id;
    }
    
    if (self.yanzhengPhoneArray.count == 1) {
        if ([self.yanzhengPhoneArray[0] isEqualToString:@""]) {
            self.yanzhengPhoneArray = @[];
        }
    }else if (self.yanzhengPhoneArray.count == 2){
        NSString *tel = self.yanzhengPhoneArray[0];
        if ([self.yanzhengPhoneArray[1] isEqualToString:@""]) {
            self.yanzhengPhoneArray = @[tel];
        }
    }else if (self.yanzhengPhoneArray.count == 3){
        NSString *tel1 = self.yanzhengPhoneArray[0];
        NSString *tel2 = self.yanzhengPhoneArray[0];
        if ([self.yanzhengPhoneArray[2] isEqualToString:@""]) {
            self.yanzhengPhoneArray = @[tel1, tel2];
        }
    }
    
    
    
    self.isLogin = YES;
    [self saveToFile];
    
    
    
    return YES;
}

//- (NSString *)API_URL{
//    return @"https://dc.toplion.com.cn:12200/index.php";
//}

- (void)setNextBillingTime:(NSString *)nextBillingTime{
    NSRange rangeTime = [nextBillingTime rangeOfString:@"T"];
    if (rangeTime.location != NSNotFound ) {
        _nextBillingTime = [nextBillingTime substringToIndex:rangeTime.location];
    }else{
        _nextBillingTime = nextBillingTime;
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{

    if (self = [super init]) {
        self.singleValue = [coder decodeBoolForKey:@"singleValue"];
        self.API_URL = [coder decodeObjectForKey:@"API_URL"];
        self.LogoutURL = [coder decodeObjectForKey:@"LogoutURL"];
        self.userIndex = [coder decodeObjectForKey:@"userIndex"];
        self.tokenTime = [coder decodeObjectForKey:@"tokenTime"];
        self.schoolName = [coder decodeObjectForKey:@"schoolName"];
        self.userName = [coder decodeObjectForKey:@"userName"];
        self.packageName = [coder decodeObjectForKey:@"packageName"];
        self.accountFee = [coder decodeObjectForKey:@"accountFee"];
        self.atName = [coder decodeObjectForKey:@"atName"];
        self.accountId = [coder decodeObjectForKey:@"accountId"];
        self.aNewEntryId = [coder decodeObjectForKey:@"aNewEntryId"];

        self.nextBillingTime = [coder decodeObjectForKey:@"nextBillingTime"];
        self.policyId = [coder decodeObjectForKey:@"policyId"];
        self.currentTime = [coder decodeObjectForKey:@"currentTime"];
        self.wifiName = [coder decodeObjectForKey:@"wifiName"];
        self.serverIpAddress = [coder decodeObjectForKey:@"serverIpAddress"];
        self.token = [coder decodeObjectForKey:@"token"];
        self.periodStartTime = [coder decodeObjectForKey:@"periodStartTime"];
        self.epurl = [coder decodeObjectForKey:@"epurl"];
        self.isLogin = [coder decodeBoolForKey:@"isLogin"];
        self.schoolCode = [coder decodeObjectForKey:@"schoolCode"];
        self.termBillingTime = [coder decodeObjectForKey:@"termBillingTime"];
        self.schoolId = [coder decodeObjectForKey:@"schoolId"];
        self.loginId = [coder decodeObjectForKey:@"loginId"];
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.widArr = [coder decodeObjectForKey:@"widArr"];
        self.kssjDic = [coder decodeObjectForKey:@"kssjDic"];
        self.jssjDic = [coder decodeObjectForKey:@"jssjDic"];
        self.schoolCalenderArr = [coder decodeObjectForKey:@"schoolCalenderArr"];
        self.courseArr = [coder decodeObjectForKey:@"courseArr"];
        self.role_type = [coder decodeObjectForKey:@"role_type"];
        self.role_id = [coder decodeObjectForKey:@"role_id"];
        self.role_username = [coder decodeObjectForKey:@"role_username"];
        self.salaryUserName = [coder decodeObjectForKey:@"salaryUserName"];
        self.salaryPWD = [coder decodeObjectForKey:@"salaryPWD"];
        self.salaryUserInfoArr = [coder decodeObjectForKey:@"salaryUserInfoArr"];
        self.subAccountId = [coder decodeObjectForKey:@"subAccountId"];
        self.meetingNoticDic = [coder decodeObjectForKey:@"meetingNoticDic"];
        self.uploadUrl = [coder decodeObjectForKey:@"uploadUrl"];
        self.userAgent = [coder decodeObjectForKey:@"userAgent"];
        self.userIp      = [coder decodeObjectForKey:@"userIp"];
        self.BaseUrl = [coder decodeObjectForKey:@"BaseUrl"];
        self.isShowPhone = [[coder decodeObjectForKey:@"isShowPhone"] boolValue];
        self.eportalVer = [[coder decodeObjectForKey:@"eportalVer"] boolValue];
        self.userInputPhonenum = [coder decodeObjectForKey:@"userInputPhonenum"];
        self.isNewEntry = [coder decodeBoolForKey:@"isNewEntry"];
        self.passWord = [coder decodeObjectForKey:@"passWord"];
        self.funcMsgArr = [coder decodeObjectForKey:@"funcMsgArr"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{

    [coder encodeBool:self.singleValue forKey:@"singleValue"];
    [coder encodeObject:self.API_URL forKey:@"API_URL"];
    [coder encodeObject:self.LogoutURL forKey:@"LogoutURL"];
    [coder encodeObject:self.userIndex forKey:@"userIndex"];
    [coder encodeObject:self.tokenTime forKey:@"tokenTime"];
    [coder encodeObject:self.schoolName forKey:@"schoolName"];
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.packageName forKey:@"packageName"];
    [coder encodeObject:self.accountFee forKey:@"accountFee"];
    [coder encodeObject:self.atName forKey:@"atName"];
    [coder encodeObject:self.accountId forKey:@"accountId"];
    [coder encodeObject:self.aNewEntryId forKey:@"aNewEntryId"];

    [coder encodeObject:self.nextBillingTime forKey:@"nextBillingTime"];
    [coder encodeObject:self.policyId forKey:@"policyId"];
    [coder encodeObject:self.currentTime forKey:@"currentTime"];
    [coder encodeObject:self.wifiName forKey:@"wifiName"];
    [coder encodeObject:self.serverIpAddress forKey:@"serverIpAddress"];
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.periodStartTime forKey:@"periodStartTime"];
    [coder encodeObject:self.epurl forKey:@"epurl"];
    [coder encodeBool:self.isLogin forKey:@"isLogin"];
    [coder encodeObject:self.schoolCode forKey:@"schoolCode"];
    [coder encodeObject:self.termBillingTime forKey:@"termBillingTime"];
    [coder encodeObject:self.schoolId forKey:@"schoolId"];
    [coder encodeObject:self.loginId forKey:@"loginId"];
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.widArr forKey:@"widArr"];
    [coder encodeObject:self.kssjDic forKey:@"kssjDic"];
    [coder encodeObject:self.jssjDic forKey:@"jssjDic"];
    [coder encodeObject:self.schoolCalenderArr forKey:@"schoolCalenderArr"];
    [coder encodeObject:self.courseArr forKey:@"courseArr"];
    [coder encodeObject:self.emptyClassCourseArr forKey:@"emptyClassCourseArr"];
    [coder encodeObject:self.role_type forKey:@"role_type"];
    [coder encodeObject:self.role_id forKey:@"role_id"];
    [coder encodeObject:self.role_username forKey:@"role_username"];
    [coder encodeObject:self.salaryUserName forKey:@"salaryUserName"];
    [coder encodeObject:self.salaryPWD forKey:@"salaryPWD"];
    [coder encodeObject:self.salaryUserInfoArr forKey:@"salaryUserInfoArr"];
    [coder encodeObject:self.subAccountId forKey:@"subAccountId"];
    [coder encodeObject:self.meetingNoticDic forKey:@"meetingNoticDic"];
    [coder encodeObject:self.uploadUrl forKey:@"uploadUrl"];
    [coder encodeObject:self.userIp forKey:@"userIp"];
    [coder encodeObject:self.BaseUrl forKey:@"BaseUrl"];
    [coder encodeObject:self.userAgent forKey:@"userAgent"];
    [coder encodeObject:[NSNumber numberWithBool:self.isShowPhone]  forKey:@"isShowPhone"];
    [coder encodeObject:[NSNumber numberWithBool:self.eportalVer] forKey:@"eportalVer"];
    [coder encodeObject:self.userInputPhonenum forKey:@"userInputPhonenum"];
    [coder encodeBool:self.isNewEntry forKey:@"isNewEntry"];
    [coder encodeObject:self.passWord forKey:@"passWord"];
    [coder encodeObject:self.funcMsgArr forKey:@"funcMsgArr"];
    
}

-(void)cleanAllProperty{
    [self copyAllProperty:nil];
    self.isLogin = NO;
}

-(void)cleanAndSave{
    [self cleanAllProperty];
    [self saveToFile];
    self.isLogin = NO;
}

- (void)copyAllProperty:(AppUserIndex *)firUser{
    self.singleValue = firUser.singleValue;
    self.API_URL = firUser.API_URL;
    self.LogoutURL = firUser.LogoutURL;
    self.userIndex = firUser.userIndex;
    self.tokenTime = firUser.tokenTime;
    self.schoolName = firUser.schoolName;
    self.userName = firUser.userName;
    self.packageName = firUser.packageName;
    self.accountFee = firUser.accountFee;
    self.atName = firUser.atName;
    self.accountId = firUser.accountId;
    self.aNewEntryId = firUser.aNewEntryId;
    
    self.nextBillingTime = firUser.nextBillingTime;
    self.policyId = firUser.policyId;
    self.currentTime = firUser.currentTime;
    self.wifiName = firUser.wifiName;
    self.serverIpAddress = firUser.serverIpAddress;
    self.token = firUser.token;
    self.periodStartTime = firUser.periodStartTime;
    self.epurl = firUser.epurl;
    self.isLogin = firUser.isLogin;
    self.schoolCode = firUser.schoolCode;
    self.termBillingTime = firUser.termBillingTime;
    self.schoolId=firUser.schoolId;
    self.loginId = firUser.loginId;
    self.userId = firUser.userId;
    self.widArr = firUser.widArr;
    self.kssjDic = firUser.kssjDic;
    self.jssjDic = firUser.jssjDic;
    self.schoolCalenderArr = firUser.schoolCalenderArr;
    self.courseArr = firUser.courseArr;
    self.emptyClassCourseArr = firUser.emptyClassCourseArr;
    self.role_type = firUser.role_type;
    self.role_id = firUser.role_id;
    self.role_username = firUser.role_username;
    self.salaryPWD = firUser.salaryPWD;
    self.salaryUserName = firUser.salaryUserName;
    self.salaryUserInfoArr = firUser.salaryUserInfoArr;
    self.subAccountId = firUser.subAccountId;
    self.uploadUrl = firUser.uploadUrl;
    self.sex = firUser.sex;
    self.birthDay = firUser.birthDay;
    self.phoneNum = firUser.phoneNum;
    self.address = firUser.address;
    self.ZYJSZWM = firUser.ZYJSZWM;
    self.departName = firUser.departName;
    self.seniorName = firUser.seniorName;
    self.continueSignDays = firUser.continueSignDays;
    self.flowerNum = firUser.flowerNum;
    self.nickName = firUser.nickName;
    self.headImageUrl = firUser.headImageUrl;
    self.signStatus = firUser.signStatus;
    self.majorName = firUser.majorName;
    self.personUrl = firUser.personUrl;
    self.userAgent  = firUser.userAgent;
    self.BaseUrl   = firUser.userAgent;
    self.userIp   = firUser.userIp;
    self.isShowPhone = firUser.isShowPhone;
    self.eportalVer = firUser.eportalVer;
    self.userInputPhonenum = firUser.userInputPhonenum;
    self.isNewEntry = firUser.isNewEntry;
    self.passWord = firUser.passWord;
    self.funcMsgArr = firUser.funcMsgArr ;
    //退出登录不清空的数据
    if (firUser) {
        self.meetingNoticDic = firUser.meetingNoticDic;
    }
}
#pragma mark -
#pragma mark readAndWriteWithFile
-(void)readFromFile{
    NSString *saveDataPath = [NSString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
    AppUserIndex *mainUser = (AppUserIndex *)[self unarchiverForKey:@"user" withFilePath:[NSString stringWithFormat:@"%@user.plist", saveDataPath]];
    if (mainUser) {
        [self copyAllProperty:mainUser];
    }
}
-(void)saveToFile{
    NSString *saveDataPath = [NSString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
    [self archiverAnObj:self forKey:@"user" withFilePath:[NSString stringWithFormat:@"%@user.plist", saveDataPath]];
}

#pragma mark -
#pragma mark archiver
- (void)archiverAnObj:(NSObject *)obj forKey:(NSString *)keyStr withFilePath:(NSString *)path {
    NSMutableData *dataArea = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:dataArea];
    [archiver encodeObject:obj forKey:keyStr];
    [archiver finishEncoding];
    [dataArea writeToFile:path atomically:YES];
}
- (NSObject *)unarchiverForKey:(NSString *)keyStr withFilePath:(NSString *)path {
    NSMutableData *dataArea = [NSMutableData dataWithContentsOfFile:path];
    if (!dataArea) {
        return nil;
    }
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataArea];
    NSObject *obj = [unarchiver decodeObjectForKey:keyStr];
    [unarchiver finishDecoding];
    return obj;
}
@end
