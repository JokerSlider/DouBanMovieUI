//
//  EditMymessageController.m
//  CSchool
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "EditMymessageController.h"
#import "UIView+SDAutoLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyInfoMessageCell.h"
#import "MyInfoModel.h"
#import "MyMessageInfoHeadView.h"
#import "EditInfoViewController.h"
#import "MOFSPickerManager.h"
#import "MySignTxtViewController.h"
@interface EditMymessageController ()<UITableViewDelegate,UITableViewDataSource,XGAlertViewDelegate>
{
    NSString *lastPhotoUrl;//未修改头像之前的url
}
@property (nonatomic,retain)UITableView *mainTableview;
@property (nonatomic,retain)NSMutableArray *titleArr;
@property (nonatomic,retain)NSMutableArray *secTtitleArr;
@property (nonatomic,retain)MyMessageInfoHeadView *headView ;
@property (nonatomic,strong)NSMutableArray *finfoTitleArr;//tableview  section==0的textLabel的值
@property (nonatomic,strong)NSMutableArray *sinfoTitleArr;//tableView  section==1的textLabel的值

@property (nonatomic,strong)NSMutableArray *indexPathArr;//存放section == 0 时indexPath.row
@property (nonatomic,strong)NSMutableArray *secIndexPathArr;//存放section == 1时indePath.row
@property (nonatomic,strong)NSMutableArray *thirdfPlachodelArr;//tableView  section==1的textLabel的值

@property (nonatomic,copy)NSString *homeAddress;
@property (nonatomic,copy)NSString *jobAddress;
@end

@implementation EditMymessageController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    self.mainTableview = ({
        UITableView *view = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        view.delegate = self;
        view.dataSource = self;
        view;
    });
    [self.view addSubview:self.mainTableview];
    self.mainTableview.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).widthIs(kScreenWidth).heightIs(kScreenHeight-64);
    [self createTableHeaderView];
    [self loadData];

}
//设置头部视图
- (void)createTableHeaderView{
    _headView = [[MyMessageInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [_mainTableview setTableHeaderView:_headView];
}

/**
 *  加载数据
 */
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    NSInteger age;
    NSString *ageString;
    NSString *xingzuo;
    //从网络加载基本数据
    AppUserIndex *user = [AppUserIndex GetInstance];
    //计算年龄
    if ([user.birthDay isEqualToString:@""]) {
            ageString = @"";
            xingzuo = @"";
    }else{
        age = [self ageWithDateOfBirth:[self valuateDateFromString:user.birthDay]];
        ageString = [NSString stringWithFormat:@"%ld",(long)age];
        NSArray *dateArr =[user.birthDay componentsSeparatedByString:@"-"];
        if (dateArr.count==3) {
            NSInteger month = [[NSString stringWithFormat:@"%@",dateArr[1]] integerValue];
            NSInteger day = [[NSString stringWithFormat:@"%@",dateArr[2]] integerValue];
            xingzuo =[self calculateConstellationWithMonth:month day:day];
        }else{
            xingzuo = @"";
        }
    }
    //性别
    NSString *sexName;
    if (![user.sex isEqualToString:@""]) {
        sexName = [user.sex intValue]==1?@"男":@"女";
    }else{
        sexName = @"";
    }
    NSString *seniorName = [user.role_type isEqualToString:@"1"]?user.seniorName:user.majorName;

    _finfoTitleArr = [NSMutableArray arrayWithArray:@[user.nickName,sexName,ageString,xingzuo]];
    self.homeAddress=@"";
    self.jobAddress = @"";
    self.sinfoTitleArr = [NSMutableArray arrayWithArray:@[user.phoneNum,seniorName,user.birthDay,self.homeAddress,self.jobAddress]];
    _thirdfPlachodelArr = [NSMutableArray arrayWithArray:@[user.personnote]];
    
    MyInfoModel *model = [[MyInfoModel alloc]init];
    //存放未修改之前的头像地址
    lastPhotoUrl = user.headImageUrl;
    if (user.headImageUrl.length!=0) {
        NSString *urlStr = [user.headImageUrl stringByReplacingOccurrencesOfString:@"thumb/"withString:@""];
        model.headimageUrl = urlStr;
    }else{
        model.headimageUrl = user.headImageUrl;
    }
    //部门  ---  专业
    
    _headView.model = model;
    _indexPathArr = [NSMutableArray array];
    _secIndexPathArr = [NSMutableArray array];
    _titleArr = [NSMutableArray arrayWithArray:@[@"昵称",@"性别",@"年龄",@"星座"]];
    
    NSString *zCName = [user.role_type isEqualToString:@"1"]?@"部门":@"专业";
    _secTtitleArr = [NSMutableArray arrayWithArray:@[@"手机号",@"手机号2",zCName,@"生日",@"故乡",@"所在地"]];
    if ([user.role_type isEqualToString:@"1"]) {
        _secTtitleArr = [NSMutableArray arrayWithArray:@[@"手机号",@"手机号2",zCName,@"生日",@"办公地点",@"故乡",@"所在地"]];
    }
    WEAKSELF;
    [[MOFSPickerManager shareManger]searchAddressByZipcode:user.address block:^(NSString *address) {
        weakSelf.homeAddress = address;
        weakSelf.sinfoTitleArr = [NSMutableArray arrayWithArray:@[user.phoneNum,user.SJXH,seniorName,user.birthDay,self.homeAddress,self.jobAddress]];
        if ([user.role_type isEqualToString:@"1"]) {
            weakSelf.sinfoTitleArr = [NSMutableArray arrayWithArray:@[user.phoneNum,user.SJXH,seniorName,user.birthDay,user.BGDD,self.homeAddress,self.jobAddress]];
        }
        [weakSelf.mainTableview reloadData];
    }];
    [[MOFSPickerManager shareManger]searchAddressByZipcode:user.jobAddress block:^(NSString *address) {
        weakSelf.jobAddress = address;
        weakSelf.sinfoTitleArr = [NSMutableArray arrayWithArray:@[user.phoneNum,user.SJXH,seniorName,user.birthDay,self.homeAddress,self.jobAddress]];
        if ([user.role_type isEqualToString:@"1"]) {
            weakSelf.sinfoTitleArr = [NSMutableArray arrayWithArray:@[user.phoneNum,user.SJXH,seniorName,user.birthDay,user.BGDD,self.homeAddress,self.jobAddress]];
        }
        [weakSelf.mainTableview reloadData];

    }];
    [ProgressHUD dismiss];
}

#pragma mark  TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _titleArr.count;
    }else if (section==1){
    return  _secTtitleArr.count;
    }
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"MyMessageInfo";
    MyInfoMessageCell *cell = [[MyInfoMessageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    if ((indexPath.row==3||indexPath.row==2)&&indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ((indexPath.section==0&&indexPath.row==1)&&[AppUserIndex GetInstance].sex.length!=0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //生日选择
    if ((indexPath.section==1)&(indexPath.row==3)) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ((indexPath.section==1&&indexPath.row==2)&&[AppUserIndex GetInstance].birthDay.length!=0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
 
    
    if (indexPath.section==0) {
        cell.titleLabel.text = _titleArr[indexPath.row];
        cell.txtField.text = _finfoTitleArr[indexPath.row];
        NSIndexPath *index=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        if (_indexPathArr.count<4) {
            [_indexPathArr addObject:index];
        }
    }else if(indexPath.section==1){
        
        cell.titleLabel.text = _secTtitleArr[indexPath.row];
        cell.txtField.text = _sinfoTitleArr[indexPath.row];
        NSIndexPath *index=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        if (_secIndexPathArr.count<5) {
            [_secIndexPathArr addObject:index];
        }
    }else{
        cell.titleLabel.text = @"个人说明";
        cell.txtField.text = _thirdfPlachodelArr[indexPath.row];
    }
    //占位字符
    if (indexPath.section==0) {
        cell.txtField.text = _finfoTitleArr[indexPath.row];
        
    }else if(indexPath.section==1)
    {
        cell.txtField.text = _sinfoTitleArr[indexPath.row];
    }else{
        
    }
  
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppUserIndex *user = [AppUserIndex GetInstance];
    MyInfoMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.view endEditing:YES];
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
            {

                EditInfoViewController *vc = [[EditInfoViewController alloc]init];
                vc.title = @"手机号";
                vc.placdeTxt = user.phoneNum;
                vc.editSucessBlock = ^(NSString *text){
                    if (text.length!=0) {
                        cell.txtField.text = text;
                    }else{
                        cell.txtField.text = @"未填写";
                    }
                    self.sinfoTitleArr[0]=cell.txtField.text;

                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 1:
            {
                
                EditInfoViewController *vc = [[EditInfoViewController alloc]init];
                vc.title = @"手机号2";
                vc.placdeTxt = user.SJXH;
                vc.editSucessBlock = ^(NSString *text){
                    if (text.length!=0) {
                        cell.txtField.text = text;
                    }else{
                        cell.txtField.text = @"未填写";
                    }
                    self.sinfoTitleArr[0]=cell.txtField.text;
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 2:
            {
                //生日p------不能选生日  如果生日字段存在的话 就不能选  如果不存的话就可以直接选了
                if ([user.birthDay isEqualToString:@""]) {
                    [self selectDateNum];
                }
                
            }
                break;
                case 3:
            {
                
            }
                break;
                case 4:
            {
                if ([[AppUserIndex GetInstance].role_type isEqualToString:@"1"]) {
                    //姓名输入   跳转到新页面
                    EditInfoViewController *vc = [[EditInfoViewController alloc]init];
                    AppUserIndex *user = [AppUserIndex GetInstance];
                    vc.title = @"办公地点";
                    vc.placdeTxt = user.BGDD;
                    vc.editSucessBlock = ^(NSString *text){
                        if (text.length!=0) {
                            cell.txtField.text = text;
                        }else{
                            cell.txtField.text = @"未填写";
                        }
                        _finfoTitleArr[0] = cell.txtField.text;
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self selectHomeAddress];
                }
                
            }
                break;
                case 5:
            {
                if ([[AppUserIndex GetInstance].role_type isEqualToString:@"1"]) {
                    [self selectHomeAddress];

                }else{
                    [self selectWorkAddress];
                }
            }
                break;
                case 6:
            {
                // 所在地
                [self selectWorkAddress];
            }
                break;
                       default:
                break;
        }
    }else if (indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
            {
                
                //姓名输入   跳转到新页面
                EditInfoViewController *vc = [[EditInfoViewController alloc]init];
                AppUserIndex *user = [AppUserIndex GetInstance];
                vc.title = @"昵称";
                vc.placdeTxt = user.nickName;
                vc.editSucessBlock = ^(NSString *text){
                    if (text.length!=0) {
                        cell.txtField.text = text;
                    }else{
                        cell.txtField.text = @"未填写";
                    }
                    _finfoTitleArr[0] = cell.txtField.text;
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 1:
            {
                //性别选择
                if ([user.sex isEqualToString:@""]) {
                    [self setupPickerView];
                }
            }
                break;
                case 2:
            {
                //年龄  自己计算
            }
                break;
            default:
                break;
        }
    }else
    {
        //姓名输入   跳转到新页面
        MySignTxtViewController *vc = [[MySignTxtViewController alloc]init];
        AppUserIndex *user = [AppUserIndex GetInstance];
        vc.title = @"个人说明";
        vc.placdeTxt = user.personnote;
        vc.editSucessBlock = ^(NSString *text){
            if (text.length!=0) {
                cell.txtField.text = text;
            }else{
                cell.txtField.text = @"未填写";
            }
            _thirdfPlachodelArr[0] = cell.txtField.text;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//选择生日
-(void)selectDateNum
{
    AppUserIndex *user = [AppUserIndex GetInstance];

    //隐藏其他无关的控件
    __weak typeof (self) weakSelf = self;
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"yyyy-MM-dd";
    [[MOFSPickerManager shareManger] showDatePickerWithTag:1 commitBlock:^(NSDate *date) {
        NSString *chooseDate = [df stringFromDate:date];
        NSDictionary *param = @{
                                @"username":user.role_id,
                                @"birthday":chooseDate,
                                @"rid":@"updateUserInfoByInput"
                                };

        [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [ProgressHUD dismiss];
            MyInfoModel *model = [[MyInfoModel alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                [model yy_modelSetWithDictionary:dic];
            }
            user.birthDay = [NSString stringWithFormat:@"%@",model.birthday];
            [user saveToFile];
            //计算年龄
            NSInteger age = [weakSelf ageWithDateOfBirth:[weakSelf valuateDateFromString:chooseDate]];
            NSString *ageString = [NSString stringWithFormat:@"%ld",(long)age];
            weakSelf.finfoTitleArr[3] = ageString;
            NSIndexPath *indexPath = weakSelf.indexPathArr[3];
            if (indexPath.section==0) {
                [weakSelf.mainTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:weakSelf.indexPathArr[3]] withRowAnimation:UITableViewRowAnimationNone];
            }
            //choseDate;//选择的生日
            weakSelf.sinfoTitleArr [3] = chooseDate;
            [weakSelf.mainTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:weakSelf.secIndexPathArr[3]] withRowAnimation:UITableViewRowAnimationNone];
            //restDate;//计算出剩余的天数
            //计算星座
            NSArray *dateArr =[chooseDate componentsSeparatedByString:@"-"];
            NSInteger month = [[NSString stringWithFormat:@"%@",dateArr[1]] integerValue];
            NSInteger day = [[NSString stringWithFormat:@"%@",dateArr[2]] integerValue];
            NSString *xingzuo =[weakSelf calculateConstellationWithMonth:month day:day];
            weakSelf.finfoTitleArr[3] = xingzuo;
            if (indexPath.section==0) {
                [weakSelf.mainTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:weakSelf.indexPathArr[3]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [weakSelf.view endEditing:YES];
            [weakSelf.mainTableview reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            
        }];
            } cancelBlock:^{
        [weakSelf.view endEditing:YES];

    }];

}

//选择故乡
-(void)selectHomeAddress
{
    __weak typeof(self) weakSelf = self;
    AppUserIndex *user = [AppUserIndex GetInstance];
    MOFSPickerManager *manager = [MOFSPickerManager shareManger];
    manager.addressPicker.address = user.address;
    [manager showMOFSAddressPickerWithTitle:@"请选择故乡" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *address, NSString *zipcode) {

        [ProgressHUD show:@"正在上传..."];
        NSDictionary *param = @{
                                @"username":user.role_id,
                                @"hometown":zipcode,
                                @"rid":@"updateUserInfoByInput"
                                };
        [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [ProgressHUD dismiss];
            MyInfoModel *model = [[MyInfoModel alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                [model yy_modelSetWithDictionary:dic];
            }
            user.address = [NSString stringWithFormat:@"%@",model.hometown];
            [user saveToFile];
            if ([user.role_type isEqualToString:@"1"]) {
                weakSelf.sinfoTitleArr [5] = address;
            }else{
                weakSelf.sinfoTitleArr [4] = address;
            }
//            [weakSelf.mainTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:weakSelf.secIndexPathArr[3]] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.mainTableview reloadData];
            [weakSelf.view endEditing:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            
            [ProgressHUD showError:error[@"msg"]];
        }];
    } cancelBlock:^{
        [weakSelf.view endEditing:YES];
    }];
}
//选择所在地
-(void)selectWorkAddress
{
    __weak typeof(self) weakSelf = self;
    AppUserIndex *user = [AppUserIndex GetInstance];
    MOFSPickerManager *manager = [MOFSPickerManager shareManger];
    manager.addressPicker.address = user.jobAddress;
    [manager showMOFSAddressPickerWithTitle:@"请选择所在地" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *address, NSString *zipcode) {
        [ProgressHUD show:@"正在上传..."];
        NSDictionary *param = @{
                                @"username":user.role_id,
                                @"xzz":zipcode,
                                @"rid":@"updateUserInfoByInput"
                                };
        [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [ProgressHUD dismiss];
            MyInfoModel *model = [[MyInfoModel alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                [model yy_modelSetWithDictionary:dic];
            }
            user.jobAddress = [NSString stringWithFormat:@"%@",model.jobAddress];
            [user saveToFile];
            if ([user.role_type isEqualToString:@"1"]) {
                weakSelf.sinfoTitleArr [6] = address;

            }else{
                weakSelf.sinfoTitleArr [5] = address;
            }
//            [weakSelf.mainTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:weakSelf.secIndexPathArr[4]] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.mainTableview reloadData];
            [weakSelf.view endEditing:YES];//使键盘消失
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [weakSelf.view endEditing:YES];
            [ProgressHUD dismiss];
        }];       
    } cancelBlock:^{
        [weakSelf.view endEditing:YES];
        
    }];
}

#pragma mark  pickerviewdelegate
//选择男女 @"性别"
-(void)setupPickerView
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    __weak typeof(self) weakSelf = self;
    [[MOFSPickerManager shareManger] showPickerViewWithDataArray:@[@"男",@"女"] tag:1 title:nil cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *string) {
        NSString *sexName = string;
        if ([sexName isEqualToString:@"男"]) {
            string = @"1";
        }else if([sexName isEqualToString:@"女"])
        {
            string =@"2";
        }
        NSDictionary *param = @{
                                @"username":user.role_id,
                                @"sex":string,
                                @"rid":@"updateUserInfoByInput"
                                };
        [ProgressHUD show:@"正在上传..."];
        [NetworkCore requestPOST:user.API_URL parameters:param success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [ProgressHUD dismiss];
            MyInfoModel *model = [[MyInfoModel alloc]init];
            for (NSDictionary *dic in responseObject[@"data"]) {
                [model yy_modelSetWithDictionary:dic];
            }
            user.sex = [NSString stringWithFormat:@"%@",model.sex];
            [user saveToFile];
            NSIndexPath *indexPath = _indexPathArr[1];
            _finfoTitleArr[1] = sexName;
            if (indexPath.section==0) {
                [self.mainTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:_indexPathArr[1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            [weakSelf.view endEditing:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
            [weakSelf.view endEditing:YES];
            [ProgressHUD dismiss];
        }];
    } cancelBlock:^{
        [weakSelf.view endEditing:YES];

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 私有方法
/**
 *  根据生日计算星座
 *
 *  @param month 月份
 *  @param day   日期
 *
 *  @return 星座名称
 */
-(NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (month<1 || month>12 || day<1 || day>31){
        return @"日期格式错误!";
    }
    
    if(month==2 && day>29)
    {
        return @"日期格式错误!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}
//计算年龄需要将字符串转NSDate
-(NSDate *)valuateDateFromString:(NSString *)dateString
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:dateString];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
    NSDate *localeDate = [inputDate dateByAddingTimeInterval: interval];
    return localeDate;
}
//计算年龄
- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    return iAge;
}
#pragma mark  XGAlertViewDelegate
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    
}
-(void)alertView:(XGAlertView *)view didClickCancel:(NSString *)title
{
    AppUserIndex *user = [AppUserIndex GetInstance];
    user.headImageUrl = lastPhotoUrl;
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
