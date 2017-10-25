//
//  DetailTableCell.m
//  DetailTableView
//
//  Created by joker on 7/12/16.
//  Copyright © 2016 joker. All rights reserved.
//

#import "DetailTableCell.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "XGAddPhoneNumber.h"
#import "UIView+UIViewController.h"
#import "PersonInfoViewController.h"
#import "UIView+SDAutoLayout.h"
@interface DetailTableCell()<XGAlertViewDelegate,CNContactViewControllerDelegate,ABNewPersonViewControllerDelegate>
@end
@implementation DetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _backView.backgroundColor = Base_Color2;
    _messageBtn.sd_layout.leftSpaceToView(_backView,20).topSpaceToView(_backView,15).widthIs(50).heightIs(25);
    _saveBtn.sd_layout.rightSpaceToView(_backView,20).topSpaceToView(_backView,15).widthIs(50).heightIs(25);
    _cpyBtn.sd_layout.widthIs(50).heightIs(25).topSpaceToView(_backView,15).leftSpaceToView(_messageBtn,LayoutWidthCGFloat((kScreenWidth-LayoutWidthCGFloat(150)-LayoutWidthCGFloat(40))/2));
    
    [_messageBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_messageBtn setTitle:@"短信" forState:UIControlStateNormal];
    [_messageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [_cpyBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    _cpyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_cpyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_cpyBtn setImage:[UIImage imageNamed:@"CounselorCopy"] forState:UIControlStateNormal];
    [_saveBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setImage:[UIImage imageNamed:@"cun"] forState:UIControlStateNormal];
    _numLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14.0];
    //判断角色-老师偶or学生
    AppUserIndex *user = [AppUserIndex GetInstance];
    
    //是老师
    if ([user.role_type isEqualToString:@"1"]) {
        _studentInfoBtn.hidden=NO;
    }else{
        _studentInfoBtn.hidden = YES;
    }
}
-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;

}
-(void)setModel:(PersonInfoModel *)model
{
    _model = model;
}
//保存到本地
- (IBAction)saveToPhoneAction:(id)sender {
    NSString *phoneNum;
    if (_dic[@"SJH"]) {
        phoneNum = [NSString stringWithFormat:@"%@",_dic[@"SJH"]];
        switch ([XGAddPhoneNumber existPhone:phoneNum]) {
            case ABHelperCanNotConncetToAddressBook:
            {
                [ProgressHUD showError:@"连接通讯录失败"];
            }
                break;
            case ABHelperExistSpecificContact:
            {
                [ProgressHUD showError:@"号码已存在"];
            }
                break;
            case ABHelperNotExistSpecificContact:
            {
                //9.0以上的方法
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
                    [self addNewContactPerson:phoneNum];
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
        [ProgressHUD showError:@"手机号为空"];
    }

}
//复制
- (IBAction)copyAction:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *phoneNum;
    if (_dic[@"SJH"]) {
        phoneNum = [NSString stringWithFormat:@"%@",_dic[@"SJH"]];
        [pab setString:phoneNum];
        if (pab == nil) {
            [ProgressHUD showError:@"复制失败"];
        }else{
            [ProgressHUD showSuccess:@"复制成功"];
        }
        
    }else
    {
        [ProgressHUD showError:@"手机号为空"];
    }

}
- (IBAction)studentInfoAction:(id)sender {
    PersonInfoViewController *personVC = [[PersonInfoViewController alloc]init];
    personVC.personInfoDic =_dic;
    personVC.personSeniorArr = _studentInfoArr;
    personVC.title = [_dic  objectForKey:@"XM"];
    [self.viewController.navigationController pushViewController:personVC animated:YES];

}
- (IBAction)callPhoneNum:(id)sender {
    NSString *phoneNum;
    if (_dic[@"SJH"]) {
        phoneNum = [NSString stringWithFormat:@"%@",_dic[@"SJH"]];
        NSString *name = [NSString stringWithFormat:@"%@",_dic[@"XM"]];
        XGAlertView *tellAlert=[[XGAlertView alloc]initWithTarget:self withTitle:[NSString stringWithFormat:@"拨打'%@'电话?",name] withContent:[NSString stringWithFormat:@"电话:%@",phoneNum] WithCancelButtonTitle:@"拨打" withOtherButton:@"取消"];
        tellAlert.delegate = self;
        [tellAlert show];
    }else{
        
        [ProgressHUD showError:@"手机号为空"];
    }

}
- (IBAction)messageAction:(id)sender {
    if (_dic[@"SJH"]) {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_dic[@"SJH"]]]];
    }else{
        [ProgressHUD showError:@"手机号为空"];
    }
}
#pragma mark XGAlertViewController
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_dic[@"SJH"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}
///保存到新的联系人
- (void)addNewContactPerson:(NSString *)phoneNumer{
    ///创建一个联系人的各个数值对象
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    ///设置手机号
    CNLabeledValue * phoneNumbers = [CNLabeledValue labeledValueWithLabel:@"手机"
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:phoneNumer]];
    
    contact.phoneNumbers = @[phoneNumbers];
    //用户头像
//    contact.imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://d.youth.cn/shrgch/201607/W020160715546162315241.jpg"]];
    contact.familyName = _dic[@"XM"];
    contact.departmentName = [NSString stringWithFormat:@"学号:%@",_dic[@"XH"]];
    CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
    address.street = _dic[@"JTDZ"];
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

    CNContactViewController * addContactVc = [CNContactViewController viewControllerForNewContact:contact];
    addContactVc.delegate = self;
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:addContactVc];
    [self.viewController presentViewController:navi animated:YES completion:^{
        
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
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)_dic[@"XM"], &error);
    ABRecordSetValue(record, kABPersonDepartmentProperty, (__bridge CFStringRef)_dic[@"SJH"], &error);  
    
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)phoneNum, (__bridge CFTypeRef)_dic[@"SJH"], NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    newPersonViewController.displayedPerson = record;
    UINavigationController * navigationViewController = [[UINavigationController alloc]initWithRootViewController:newPersonViewController];
    
    //present..
    [self.viewController presentViewController:navigationViewController animated:true completion:^{
        
    }];
    
    //    //释放资源
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
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark   CNContactPickerDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    //取消
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    //select
    [picker dismissViewControllerAnimated:YES completion:^{
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
        [self.viewController presentViewController:navi animated:YES completion:^{
            
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
