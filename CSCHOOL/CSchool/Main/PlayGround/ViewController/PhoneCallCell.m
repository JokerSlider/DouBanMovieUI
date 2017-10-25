//
//  PhoneCallCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/7/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhoneCallCell.h"
#import "UIView+SDAutoLayout.h"
#import "UIButton+BackgroundColor.h"
#import "XGAddPhoneNumber.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "UIView+UIViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation PhoneCallCell
{
    UILabel *_phoneLabel;
    UIImageView *_actionView;
    UIButton *_callBtn;
    UIButton *_copyBtn;
    UIButton *_saveBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _phoneLabel = ({
        UILabel *view = [UILabel new];
        view.font = Title_Font;
        view.textColor = Color_Black;
//        view.text = @"15522223363";
        view;
    });
    
    _actionView = ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"phone_actionBac"];
        view.userInteractionEnabled = YES;
        view;
    });
    
    [self.contentView addSubview:_phoneLabel];
    [self.contentView addSubview:_actionView];
    
    _phoneLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(30)
    .topSpaceToView(self.contentView, 5);
    
    _actionView.sd_layout
    .topSpaceToView(_phoneLabel,5)
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .heightIs(44);
    
    CGFloat btnWidth = (kScreenWidth-20)/3.0;
    _callBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"phone_number"] forState:UIControlStateNormal];
        [view setTitle:@" 呼叫" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        [view setTitleColor:Color_Gray forState:UIControlStateNormal];
        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _copyBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"phone_copy"] forState:UIControlStateNormal];
        [view setTitle:@" 复制" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        [view setTitleColor:Color_Gray forState:UIControlStateNormal];
        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        [view addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    _saveBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [view setImage:[UIImage imageNamed:@"phone_save"] forState:UIControlStateNormal];
        [view setTitle:@" 保存" forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        [view setTitleColor:Color_Gray forState:UIControlStateNormal];
        [view setBackgroundColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        [view addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        view;
    });
    
    
    [_actionView addSubview:_callBtn];
    [_actionView addSubview:_copyBtn];
    [_actionView addSubview:_saveBtn];

    _callBtn.sd_layout
    .leftSpaceToView(_actionView,0)
    .topSpaceToView(_actionView,9)
    .widthIs(btnWidth)
    .heightIs(35);
    
    _copyBtn.sd_layout
    .leftSpaceToView(_callBtn,0)
    .topSpaceToView(_actionView,9)
    .widthIs(btnWidth)
    .heightIs(35);
    
    _saveBtn.sd_layout
    .leftSpaceToView(_copyBtn,0)
    .topSpaceToView(_actionView,9)
    .widthIs(btnWidth)
    .heightIs(35);
    
    NSArray *btnArr = @[_callBtn,_copyBtn,_saveBtn];
    for (UIButton *sender in btnArr) {
        if (sender == _saveBtn) {
            break;
        }
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_actionView addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(sender,0)
        .widthIs(1)
        .heightIs(21)
        .topSpaceToView(_actionView,16);
    }
}

- (void)setPhoneNumer:(NSString *)phoneNumer{
    _phoneNumer = phoneNumer;
    _phoneLabel.text = phoneNumer;
}

- (void)callAction:(UIButton *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneNumer];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)copyAction:(UIButton *)sender{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    
    NSString *string = _phoneNumer;
    
    [pab setString:string];
    
    if (pab == nil) {
        [ProgressHUD showError:@"复制失败"];
    }else{
        [ProgressHUD showSuccess:@"复制成功"];
    }
}

- (void)saveAction:(UIButton *)sender{
    switch ([XGAddPhoneNumber existPhone:_phoneNumer]) {
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
                [self addNewContactPerson];
            }else{
                //9.0弃用的方法
                [self pushToNewPersonViewController];
            }
            
        }
            break;
        default:
            break;
    }
}


#pragma mark ios>=9.0

/**
 保存新的联系人
 */
- (void)addNewContactPerson{
    ///创建一个联系人的各个数值对象
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    
    ///设置手机号
    CNLabeledValue * phoneNumbers = [CNLabeledValue labeledValueWithLabel:_dataDic[@"FATHER_NAME"]
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:_phoneNumer]];

    contact.phoneNumbers = @[phoneNumbers];
    
    ///设置名字
    contact.givenName = _dataDic[@"DD_NAME"];
    contact.departmentName = _dataDic[@"FATHER_NAME"];
    
    CNContactViewController * addContactVc = [CNContactViewController viewControllerForNewContact:contact];
    addContactVc.delegate = self;
    
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:addContactVc];
    [self.viewController presentViewController:navi animated:YES completion:^{
        
    }];
    
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
        [self.viewController presentViewController:navi animated:YES completion:^{
            
        }];
        
    }];
}

#pragma mark ios<9
//进入新建联系人控制器
- (void)pushToNewPersonViewController
{

    //初始化添加联系人的控制器
    ABNewPersonViewController * newPersonViewController = [[ABNewPersonViewController alloc]init];
    
    //设置代理
    newPersonViewController.newPersonViewDelegate = self;
    
    // 创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    // 设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)_dataDic[@"DD_NAME"], &error);
    ABRecordSetValue(record, kABPersonDepartmentProperty, (__bridge CFStringRef)_dataDic[@"FATHER_NAME"], &error);  //部门

    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)_phoneNumer, (__bridge CFTypeRef)_dataDic[@"FATHER_NAME"], NULL);
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


#pragma mark - <ABNewPersonViewControllerDelegate>

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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
