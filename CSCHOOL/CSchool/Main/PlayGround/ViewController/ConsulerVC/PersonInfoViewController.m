//
//  PersonInfoViewController.m
//  CSchool
//
//  Created by mac on 16/7/7.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "XGAddPhoneNumber.h"
#import "TePopList.h"
#import <YYModel.h>
#import "PersonInfoModel.h"
@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,XGAlertViewDelegate,CNContactViewControllerDelegate,ABNewPersonViewControllerDelegate>
{
    NSArray *_titleArr;
    UITableView *_tableView;
    NSArray *_infoArr;
    //表视图尾部控件
    UILabel *_phoneLabel;
    UIButton *_callLBtn;
    UIButton *_messageBtn;
    UIButton *_copyBtn;
    UIButton *_saveBtn;
    NSMutableArray  *_telPhoneArr;//存放电话数据
    NSString *selectPhoneNum;//选中的手机号
    
    NSString *address;
    NSString *homePhone;
    NSString *YXMC;
    NSString *ZYMC;
    NSString *ZZMM;
    NSString *SJH;
    NSString *NJ;
    NSString *XM;
    NSString *XH;

}
@end

@implementation PersonInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
}
#pragma mark 初始化数据
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    _telPhoneArr = [NSMutableArray array];
    _titleArr = @[@"姓名:",@"学号:",@"所在年级:",@"所在院系:",@"所在班级:",@"政治面貌:",@"家庭住址:",@"紧急电话:",@"手机号:"];
    AppUserIndex *appUser = [AppUserIndex GetInstance];
    [NetworkCore requestPOST:appUser.API_URL parameters:@{@"stuNo":_personInfoDic[@"XH"],@"rid":@"queryStudentInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSArray *arr = responseObject[@"data"];
        if (arr.count==0) {
            [self loadBaseData];
        }else{
            NSDictionary *dic= responseObject[@"data"];

            address=dic[@"JTDZ"]?dic[@"JTDZ"]:@"无";
            homePhone = dic[@"JTDH"]?dic[@"JTDH"]:@"无";
            YXMC = dic[@"YXMC"]?dic[@"YXMC"]:@"无";
            ZYMC =dic[@"ZYMC"]?dic[@"ZYMC"]:@"无";
            ZZMM = dic[@"ZZMM"]?dic[@"ZZMM"]:@"无";
            SJH  = dic[@"SJH"]?dic[@"SJH"]:@"无";
            NJ   = dic[@"NJDM"]?[NSString stringWithFormat:@"%@级",dic[@"NJDM"]]:@"无";
            XM   =dic[@"XM"]?dic[@"XM"]:@"无";
            XH   =dic[@"XH"]?dic[@"XH"]:@"无";
          
            _telPhoneArr = [NSMutableArray arrayWithArray:@[SJH,homePhone]];
            _infoArr = @[XM,XH,NJ,YXMC,ZYMC,ZZMM, address,homePhone,SJH];

            NSArray *PhoneArr;
            NSString *seplepString;//分隔符
            
            if (homePhone.length>11) {
                PhoneArr = [homePhone componentsSeparatedByString:@"；"];
                if (PhoneArr.count!=0) {
                    _telPhoneArr = [NSMutableArray arrayWithArray:@[SJH,[PhoneArr firstObject]]];
                    _infoArr = @[XM,XH,NJ,YXMC,ZYMC,ZZMM, address,[PhoneArr firstObject],SJH];
                }
                
            }

        }

        [_tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD showError:error[@"msg"]];
    }];

}
-(void)loadBaseData{
    address=_personInfoDic[@"JTDZ"]?_personInfoDic[@"JTDZ"]:@"无";
    homePhone = _personInfoDic[@"JTDH"]?_personInfoDic[@"JTDH"]:@"无";
    YXMC = _personInfoDic[@"YXMC"]?_personInfoDic[@"YXMC"]:@"无";
    ZYMC =_personInfoDic[@"ZYMC"]?_personInfoDic[@"ZYMC"]:@"无";
    ZZMM = _personInfoDic[@"ZZMM"]?_personInfoDic[@"ZZMM"]:@"无";
    SJH  = _personInfoDic[@"SJH"]?_personInfoDic[@"SJH"]:@"无";
    NJ   = _personInfoDic[@"NJDM"]?_personInfoDic[@"NJDM"]:@"无";
    XM   =_personInfoDic[@"XM"]?_personInfoDic[@"XM"]:@"无";
    XH   =_personInfoDic[@"XH"]?_personInfoDic[@"XH"]:@"无";
    if (_personSeniorArr) {
        NJ = [NSString stringWithFormat:@"%@",_personSeniorArr[0]];
        _infoArr = @[XM,XH,NJ,_personSeniorArr[1],_personSeniorArr[2],@"无",address,homePhone,SJH];
    }else{
        _infoArr = @[XM,XH,@"无",@"无",@"无",@"无",address,homePhone,SJH];
    }
    _telPhoneArr = [NSMutableArray arrayWithArray:@[SJH,homePhone]];
    [_tableView reloadData];
}
#pragma mark 初始化视图
-(void)createView{
    self.title = @"详情";
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
    _tableView =({
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];;
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:_tableView];
    _tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).heightIs(kScreenHeight-64);


}
//解决分割线不到左边界的问题
-(void)viewDidLayoutSubviews {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark  点击事件
- (BOOL)isChinese:(NSString *)obj
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:obj];
}
-(void)callAction:(UIButton *)sender
{
    switch (sender.tag) {
        //打电话
        case 0:
        {

            if ([self isChinese:_telPhoneArr[0]]&&[self isChinese:_telPhoneArr[1]]) {
                [ProgressHUD showError:@"电话号码为空!"];
                return ;
            }
            TePopList *pop = [[TePopList alloc] initWithListDataSource:_telPhoneArr withTitle:@"选择电话" withSelectedBlock:^(NSInteger select) {
                selectPhoneNum = _telPhoneArr[select];

                if ([self isChinese:selectPhoneNum]) {
                    [ProgressHUD showError:@"电话号码为空!"];
                    return ;
                }
                NSString *name = [NSString stringWithFormat:@"%@",_personInfoDic[@"XM"]];
                XGAlertView *tellAlert=[[XGAlertView alloc]initWithTarget:self withTitle:[NSString stringWithFormat:@"拨打'%@'电话?",name] withContent:[NSString stringWithFormat:@"电话:%@",selectPhoneNum] WithCancelButtonTitle:@"拨打" withOtherButton:@"取消"];
                tellAlert.delegate = self;
                tellAlert.tag = 1001;
                [tellAlert show];
                
            }];
            [pop selectIndex:-1];
            pop.isAllowBackClick = YES;
            [pop show];
            
        }
            break;
        //发短信
        case 1:
        {
            NSString *phoneNum;
            if (_personInfoDic[@"SJH"]) {
                phoneNum = [NSString stringWithFormat:@"%@",_personInfoDic[@"SJH"]];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNum]]];
            }else
            {
                [ProgressHUD showError:@"手机号为空!"];
            }
        }
            break;
        //复制
        case 2:
        {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            NSString *phoneNum;
            if (_personInfoDic[@"SJH"]) {
                phoneNum = [NSString stringWithFormat:@"%@",_personInfoDic[@"SJH"]];
                [pab setString:phoneNum];
                if (pab == nil) {
                    [ProgressHUD showError:@"复制失败"];
                }else{
                    [ProgressHUD showSuccess:@"复制成功"];
                }

            }else
            {
                [ProgressHUD showError:@"手机号为空!"];
            }
        }
            break;
        //保存
        case 3:
        {
            
            NSString *phoneNum;
            if (_personInfoDic[@"SJH"]) {
                phoneNum = [NSString stringWithFormat:@"%@",_personInfoDic[@"SJH"]];
                NSString *phoneNum2 = [NSString stringWithFormat:@"%@",_personInfoDic[@"JTDH"]];
                switch ([XGAddPhoneNumber existPhone:phoneNum]) {
                    case ABHelperCanNotConncetToAddressBook:
                    {
                        [ProgressHUD showError:@"连接通讯录失败!"];
                    }
                        break;
                    case ABHelperExistSpecificContact:
                    {
                        [ProgressHUD showError:@"号码已存在!"];
                    }
                        break;
                    case ABHelperNotExistSpecificContact:
                    {
                        //9.0以上的方法
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
                            [self addNewContactPerson:phoneNum phoneNum:phoneNum2];
                        }else{
                            //9.0弃用的方法
                            [self pushToNewPersonViewController:phoneNum];
                        }
                    }
                        break;
                    default:
                        break;
                }

            }else
            {
                [ProgressHUD showError:@"手机号为空!"];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark XGAlertViewController
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    switch (view.tag) {
        case 1001:
        {
            NSLog(@"选择的电话号%@",selectPhoneNum);
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",selectPhoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1004:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_infoArr[7]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1005:        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_infoArr[8]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;

            
        default:
            break;
    }
   
    
}///保存到新的联系人

#pragma  mark tableviewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenfiter = @"personInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfiter ];
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:idenfiter];
    }
    //解决分割线不到边边的问题
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = Color_Black;
    cell.detailTextLabel.text =_infoArr[indexPath.row];
    cell.detailTextLabel.numberOfLines = 0 ;
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    switch (indexPath.row) {
        case 7:
        {
            if ([self isChinese:_infoArr[indexPath.row]]) {
                [ProgressHUD showError:@"电话号码为空!"];
                return ;
            }
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"拨打" withContent:_infoArr[indexPath.row] WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            alert.tag = 1004;
            alert.delegate = self;
            alert.isBackClick = YES;
            [alert show];
        }
            break;
        case 8:
        {
            if ([self isChinese:_infoArr[indexPath.row]]) {
                [ProgressHUD showError:@"电话号码为空!"];
                return ;
            }
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"拨打" withContent:_infoArr[indexPath.row] WithCancelButtonTitle:@"拨打" withOtherButton:@"取消"];
            alert.tag = 1005;
            alert.delegate = self;
            alert.isBackClick = YES;
            [alert show];
            
        }
            break;
        default:
            break;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView;
    
    //盛放按钮的视图
    UIView *buttonView;
    backView = ({
        UIView *view = [UIView new];
        view.backgroundColor = Base_Color2;
        view;
    });
    buttonView = ({
        UIView *view = [UIView new];
        view.backgroundColor = Base_Color2;
        view;
    });
    _callLBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 0;
        [view setTitle:@"电话" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:10];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        view;
    });
    _messageBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 1;
        [view setTitle:@"短信" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:10];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        view;
    });
    
    _copyBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 2;
        [view setTitle:@"复制" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:10];
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"CounselorCopy"] forState:UIControlStateNormal];
        view;
    });
    _saveBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 3;
        [view setTitle:@"保存" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:10];
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setTitleColor:Color_Black forState:UIControlStateNormal];
        [view setImage:[UIImage imageNamed:@"cun"] forState:UIControlStateNormal];
        view;
    });
    
    [backView addSubview:buttonView];
    [buttonView sd_addSubviews:@[_callLBtn,_copyBtn,_messageBtn,_saveBtn]];
    CGFloat buttonWith =(kScreenWidth-260)/3;
    
    backView.sd_layout.leftSpaceToView(_tableView,0).rightSpaceToView(_tableView,0).bottomSpaceToView(_tableView,0).heightIs(60);
    buttonView.sd_layout.leftSpaceToView(backView,0).topSpaceToView(backView,25).rightSpaceToView(backView,0).heightIs(25);
    _callLBtn.sd_layout.leftSpaceToView(buttonView,20).topSpaceToView(buttonView,0).widthIs(LayoutWidthCGFloat(60)).heightIs(25);
    _messageBtn.sd_layout.leftSpaceToView(_callLBtn,buttonWith).topEqualToView(_callLBtn).widthIs(LayoutWidthCGFloat(60)).heightIs(25);
    _copyBtn.sd_layout.leftSpaceToView(_messageBtn,buttonWith).topEqualToView(_callLBtn).widthIs(LayoutWidthCGFloat(60)).heightIs(25);
    _saveBtn.sd_layout.leftSpaceToView(_copyBtn,buttonWith).topEqualToView(_callLBtn).widthIs(LayoutWidthCGFloat(60)).heightIs(25);
    return backView;
}


#pragma mark  保存用户电话代理事件
///保存到新的联系人
- (void)addNewContactPerson:(NSString *)phoneNumer phoneNum:(NSString *)phoneNum2{
    ///创建一个联系人的各个数值对象
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    
    ///设置手机号
    CNLabeledValue * phoneNumbers = [CNLabeledValue labeledValueWithLabel:@"手机"
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:phoneNumer]];
    CNLabeledValue * phoneNumber2 = [CNLabeledValue labeledValueWithLabel:@"家庭电话"
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum2]];
    contact.phoneNumbers = @[phoneNumbers,phoneNumber2];
    //用户头像
//    contact.imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://d.youth.cn/shrgch/201607/W020160715546162315241.jpg"]];
    contact.familyName = _personInfoDic[@"XM"];
    contact.departmentName = [NSString stringWithFormat:@"学号:%@",_personInfoDic[@"XH"]];
    CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
    address.street = _personInfoDic[@"JTZH"];
    CNLabeledValue *addressLabel = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:address];
    if (!/* DISABLES CODE */ (&exit)) {
        
    }else{
        if ([contact.postalAddresses count] >0) {
            NSMutableArray *addresses = [[NSMutableArray alloc] initWithArray:contact.postalAddresses];
            [addresses addObject:addressLabel];
            contact.postalAddresses = addresses;
        }else{
            contact.postalAddresses = @[addressLabel];
        }
    }
    if (_personSeniorArr.count!=0) {
        contact.organizationName =[NSString stringWithFormat:@"%@-%@-%@",_personSeniorArr[0],_personSeniorArr[1],_personSeniorArr[2]];
    }
    CNContactViewController * addContactVc = [CNContactViewController viewControllerForNewContact:contact];
    addContactVc.delegate = self;
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:addContactVc];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
    
}
//进入新建联系人控制器
- (void)pushToNewPersonViewController:(NSString *)phoneNum
{
    
    //初始化添加联系人的控制器
    ABNewPersonViewController * newPersonViewController = [[ABNewPersonViewController alloc]init];
    
    //设置代理
    newPersonViewController.newPersonViewDelegate = self;
    
    // 创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    // 设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)_personInfoDic[@"XM"], &error);
    ABRecordSetValue(record, kABPersonDepartmentProperty, (__bridge CFStringRef)_personInfoDic[@"SJH"], &error);  //部门
    
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)phoneNum, (__bridge CFTypeRef)_personInfoDic[@"SJH"], NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    
    newPersonViewController.displayedPerson = record;
    UINavigationController * navigationViewController = [[UINavigationController alloc]initWithRootViewController:newPersonViewController];
    
    //present..
    [self presentViewController:navigationViewController animated:true completion:^{
        
    }];
    
//释放资源
    CFRelease(record);
    CFRelease(multi);
}
#pragma mark   CNContactViewControllerDelegate
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    if (contact) {
        [ProgressHUD showSuccess:@"保存成功"];
    }else{
        //取消
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark   CNContactPickerDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    //取消
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    //select
    NSLog(@"select");
    [picker dismissViewControllerAnimated:YES completion:^{
        //copy一份可写的Contact对象
        CNMutableContact *contactCopy = [contact mutableCopy];
        
        ///设置需要添加的手机号
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] initWithArray:contact.phoneNumbers];
        
        CNLabeledValue * phoneNumberAdd = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain
                                                                          value:[CNPhoneNumber phoneNumberWithStringValue:@"11111111111"]];
        [phoneNumbers addObject:phoneNumberAdd];
        contactCopy.phoneNumbers = phoneNumbers;
        
        CNContactViewController * addContactVc = [CNContactViewController viewControllerForNewContact:contactCopy];
        addContactVc.delegate = self;
        
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:addContactVc];
        [self presentViewController:navi animated:YES completion:^{
            
        }];
    }];
}
/**
 *  新增联系人点击Cancel或者Done之后的回调方法
 *
 *  @param newPersonView 调用该方法的ABNewPersonViewController对象
 *  @param person        传出的ABRecordRef属性
 *                       点击了Done,person就是新增的联系人属性
 *                       点击了Cancel,person就是NULL
 */
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person
{
    //表示取消了
    if (person == NULL)
    {
        //Cancle coding..
    }
    
    //表示保存成功
    else
    {
        //Cancle Done..
    }
    
    //不管成功与否，都需要跳回
    [newPersonView dismissViewControllerAnimated:true completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
