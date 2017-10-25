//
//  OfficePersonInfoViewController.m
//  CSchool
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "OfficePersonInfoViewController.h"
#import "UIView+SDAutoLayout.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "XGAddPhoneNumber.h"
#import "TePopList.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface OfficePersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,XGAlertViewDelegate,CNContactViewControllerDelegate,ABNewPersonViewControllerDelegate>
{
    NSArray *_titleArr;
    UITableView *_tableView;
    NSArray *_infoArr;
    //表视图尾部控件c7
    UILabel *_phoneLabel;
    UIButton *_callLBtn;
    UIButton *_messageBtn;
    UIButton *_copyBtn;
    UIButton *_saveBtn;
    NSMutableArray  *_telPhoneArr;//存放电话数据
    NSString *_phoneNum;

    UILabel *_mainLabel;
    UILabel *_subLabel;
    
    UIButton *_bacButton;
}
@property (nonatomic, strong) NSString *TelSelStr; //选择的层层

@end

@implementation OfficePersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    self.navigationItem.title = @"详情";
    _titleArr = @[@"部门:",@"办公地点:",@"手机:",@"手机小号:",@"固话:",@"邮箱:",@"QQ:",@"微信:"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

/**
 *  
 "CSRQ": "1963-07-21",
 "XBM": "1",
 "DZZWM": "11",
 "XM": "傅传 国",
 "GZDH": "86361005",
 "DZXX": "",
 "SJ": "13706400632",
 "ZGH": "20001",
 "DNAME": " 副校长6"
 */
#pragma mark 初始化数据
-(void)loadData
{
    [ProgressHUD show:@"正在加载..."];
    _telPhoneArr = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"zgh":_nameID,@"rid":@"showTeacherInfoByzgh"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSArray *arr = responseObject[@"data"];
        if (arr.count==0) {
            [self showErrorViewLoadAgain:@"获取详情失败"];
            [self.view bringSubviewToFront:_bacButton];
        }else{
            NSDictionary *dic= responseObject[@"data"];
            NSString *QQ=[NSString stringWithFormat:@"%@",dic[@"QQ"]];
            NSString *weChat=[NSString stringWithFormat:@"%@",dic[@"WXH"]];
            NSString *bumen = dic[@"DEPARTMENTNAME"]?dic[@"DEPARTMENTNAME"]:@"无";
            NSString *DZXX = dic[@"DZXX"]?dic[@"DZXX"]:@"无";
            NSString *SJH = dic[@"SJ"]?dic[@"SJ"]:@"无";
            NSString *GZDH = dic[@"GZDH"]?dic[@"GZDH"]:@"无";
            NSString *SJXH = dic[@"SJXH"]?dic[@"SJXH"]:@"无";
            NSString *BGDD = dic[@"BGDD"]?dic[@"BGDD"]:@"无";
            if ([QQ isEqualToString:@"0"]) {
                QQ = @"无";
            }
            if ([weChat isEqualToString:@""]) {
                weChat  =@"无";
            }
            //    _titleArr = @[@"部门:",@"办公地址",@"手机:",@"手机小号",@"固话:",@"邮箱:",@"QQ:",@"微信:"];

            _infoArr = @[bumen,BGDD,SJH,SJXH,GZDH,DZXX,QQ,weChat];
            _phoneLabel.text = [NSString stringWithFormat:@"电话:%@",SJH];
            _personInfoDic = dic;
            _telPhoneArr = [NSMutableArray arrayWithArray:@[SJH,GZDH]];
            _mainLabel.text = _personInfoDic[@"XM"];
            _subLabel.text = _personInfoDic[@"DNAME"];
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
    
}
#pragma mark 初始化视图
-(void)createView{
    self.view.backgroundColor = [UIColor whiteColor];
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
        UITableView *view = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];;
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = RGB(245, 245, 245);
        view.tableFooterView = [UIView new];
        view;
    });
    [self.view addSubview:_tableView];
    _tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    _bacButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bacButton setImage:[UIImage imageNamed:@"officeCall_ios_back"] forState:UIControlStateNormal];
    [_bacButton setTitle:@"   " forState:UIControlStateNormal];
    [_bacButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bacButton];
    
    _bacButton.sd_layout
    .leftSpaceToView(self.view,14)
    .topSpaceToView(self.view,37)
    .widthIs(30)
    .heightIs(20);
    
    [self createTableHeaderView];

}

- (void)backButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置头部视图
- (void)createTableHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, LayoutWidthCGFloat(324))];
    
    view.backgroundColor = RGB(245, 245, 245);
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[AppUserIndex GetInstance].schoolLogo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    _mainLabel = [[UILabel alloc] init];
    _mainLabel.textAlignment = NSTextAlignmentCenter;
    _mainLabel.textColor = Color_Black;
    _mainLabel.font = [UIFont systemFontOfSize:17];
    
    _subLabel = [[UILabel alloc] init];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.textColor = Color_Gray;
    _subLabel.font = [UIFont systemFontOfSize:15];

    _callLBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 0;
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setImage:[UIImage imageNamed:@"officeCall_call"] forState:UIControlStateNormal];
        
        view;
    });
    _messageBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 1;
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setImage:[UIImage imageNamed:@"officeCall_msg"] forState:UIControlStateNormal];
        view;
    });
    
    _copyBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 2;
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setImage:[UIImage imageNamed:@"officeCall_copy"] forState:UIControlStateNormal];
        view;
    });
    _saveBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.tag = 3;
        [view addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
        [view setImage:[UIImage imageNamed:@"officeCall_save"] forState:UIControlStateNormal];
        view;
    });
    
    [view sd_addSubviews:@[_callLBtn,_copyBtn,_messageBtn,_saveBtn]];
    
    [view sd_addSubviews:@[logoImageView, _mainLabel, _subLabel]];
    
    logoImageView.sd_layout
    .topSpaceToView(view,LayoutWidthCGFloat(62))
    .centerXEqualToView(view)
    .widthIs(LayoutWidthCGFloat(78))
    .heightIs(LayoutWidthCGFloat(78));
    
    _mainLabel.sd_layout
    .leftSpaceToView(view,10)
    .rightSpaceToView(view,10)
    .topSpaceToView(logoImageView,LayoutWidthCGFloat(16))
    .heightIs(LayoutHeightCGFloat(17));
    
    _subLabel.sd_layout
    .leftSpaceToView(view,10)
    .rightSpaceToView(view,10)
    .topSpaceToView(_mainLabel,LayoutWidthCGFloat(10))
    .heightIs(LayoutHeightCGFloat(17));
    
    _callLBtn.sd_layout
    .leftSpaceToView(view, LayoutWidthCGFloat(44))
    .topSpaceToView(_subLabel,LayoutWidthCGFloat(28))
    .widthIs(LayoutWidthCGFloat(35))
    .heightIs(LayoutWidthCGFloat(35));
    
    _messageBtn.sd_layout
    .leftSpaceToView(_callLBtn, LayoutWidthCGFloat(50))
    .topSpaceToView(_subLabel,LayoutWidthCGFloat(28))
    .widthIs(LayoutWidthCGFloat(35))
    .heightIs(LayoutWidthCGFloat(35));

    _copyBtn.sd_layout
    .leftSpaceToView(_messageBtn, LayoutWidthCGFloat(50))
    .topSpaceToView(_subLabel,LayoutWidthCGFloat(28))
    .widthIs(LayoutWidthCGFloat(35))
    .heightIs(LayoutWidthCGFloat(35));
    
    _saveBtn.sd_layout
    .leftSpaceToView(_copyBtn, LayoutWidthCGFloat(50))
    .topSpaceToView(_subLabel,LayoutWidthCGFloat(28))
    .widthIs(LayoutWidthCGFloat(35))
    .heightIs(LayoutWidthCGFloat(35));
    
    
    NSArray *titleArr = @[@"电话",@"短信",@"复制",@"保存"];
    NSArray *topArr = @[_callLBtn, _messageBtn, _copyBtn, _saveBtn];
    for (UIButton *sender in topArr) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:12];
        label.text = titleArr[sender.tag];
        label.textColor = Base_Orange;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        label.sd_layout
        .leftEqualToView(sender)
        .rightEqualToView(sender)
        .heightIs(11)
        .topSpaceToView(sender, LayoutWidthCGFloat(11));
        
    }
    
    _tableView.tableHeaderView = view;
}

#pragma mark  点击事件
//判断是否是汉字
- (BOOL)isChinese:(NSString *)obj
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:obj];
}
-(void)callAction:(UIButton *)sender
{
    NSString *phoneNum;
    switch (sender.tag) {
        //打电话
        case 0:
        {

            if ([self isChinese:_telPhoneArr[0]]&&[self isChinese:_telPhoneArr[1]]) {
                [ProgressHUD showError:@"电话号码为空!"];
                return ;
            }
            TePopList *pop = [[TePopList alloc] initWithListDataSource:_telPhoneArr withTitle:@"选择电话" withSelectedBlock:^(NSInteger select) {
               _phoneNum= _telPhoneArr[select];

                if ([self isChinese:_phoneNum]) {
                    [ProgressHUD showError:@"电话号码为空!"];
                    return ;
                }
                NSString *name = [NSString stringWithFormat:@"%@",_personInfoDic[@"XM"]];
                XGAlertView *tellAlert=[[XGAlertView alloc]initWithTarget:self withTitle:[NSString stringWithFormat:@"拨打'%@'电话?",name] withContent:[NSString stringWithFormat:@"电话:%@",_phoneNum] WithCancelButtonTitle:@"拨打" withOtherButton:@"取消"];
                tellAlert.delegate = self;
                tellAlert.tag = 1003;
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
            if (_personInfoDic[@"SJ"]) {
                phoneNum = [NSString stringWithFormat:@"%@",_personInfoDic[@"SJ"]];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNum]]];
            }else
            {
                [ProgressHUD showError:@"手机号为空"];
            }
        }
            break;
        //复制
        case 2:
        {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            if (_personInfoDic[@"SJ"]&&_personInfoDic[@"GZDH"]) {
                phoneNum = [NSString stringWithFormat:@"%@,%@",_personInfoDic[@"SJ"],_personInfoDic[@"GZDH"]];
            }else
            {
                if (_personInfoDic[@"SJ"]) {
                    phoneNum = [NSString stringWithFormat:@"%@",_personInfoDic[@"SJ"]];
                }else{
                    phoneNum = [NSString stringWithFormat:@"%@",_personInfoDic[@"GZDH"]];

                }
            }
            [pab setString:phoneNum];
            if (pab == nil) {
                [ProgressHUD showError:@"复制失败"];
            }else{
                [ProgressHUD showSuccess:@"复制成功"];
            }
            

        }
            break;
        //保存
        case 3:
        {
            NSString *phoneNum2 = [NSString stringWithFormat:@"%@",_personInfoDic[@"GZDH"]?_personInfoDic[@"GZDH"]:@"无"];
            NSString *nickName = [NSString stringWithFormat:@"%@",_personInfoDic[@"DNAME"]?_personInfoDic[@"DNAME"]:@"无"];
            if (_personInfoDic[@"SJ"]) {
                phoneNum = [NSString stringWithFormat:@"%@",_personInfoDic[@"SJ"]];

//                #ifdef __IPHONE_10_0
//
//                CNContactPickerViewController * contactVc = [CNContactPickerViewController new];
//                contactVc.delegate = self;
//                [self presentViewController:contactVc animated:YES completion:^{
//                    
//                }];
//                #endif
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
                            [self addNewContactPerson:phoneNum phoneNum2:phoneNum2 withNickName:nickName];
                        }else{
                            //9.0弃用的方法
                            [self pushToNewPersonViewController:phoneNum];
                        }
                    }
    
                }
                
            }else
            {
                [ProgressHUD showError:@"手机号为空"];
            }
        }
            break;
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    //    _titleArr = @[@"部门:",@"办公地址",@"手机:",@"手机小号",@"固话:",@"邮箱:",@"QQ:",@"微信:"];

    switch (indexPath.row) {
        case 5:
        {
            if ([_infoArr[1] isEqualToString:@"无"]) {
                [ProgressHUD showError:@"邮箱为空!"];
                return ;
            }
            
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (!mailClass) {
                [ProgressHUD showError:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
                return;
            }
            if (![mailClass canSendMail]) {
                [ProgressHUD showError:@"用户没有设置邮件账户"];
                return;
            }
            
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"邮件" withContent:@"确定要发送邮件吗" WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            alert.tag = 1001;
            alert.delegate = self;
            alert.isBackClick = YES;
            [alert show];
            
        }
            break;
        case 2:
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
        case 3:
        {
            if ([self isChinese:_infoArr[indexPath.row]]) {
                [ProgressHUD showError:@"电话号码为空!"];
                return ;
            }
            
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"拨打" withContent:_infoArr[indexPath.row] WithCancelButtonTitle:@"确定" withOtherButton:@"取消"];
            alert.tag = 1006;
            alert.delegate = self;
            alert.isBackClick = YES;
            [alert show];
        }
            break;
        case 4:
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

#pragma mark XGAlertViewController
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    switch (view.tag) {
        case 1001:{
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setToRecipients:[NSArray arrayWithObjects:_infoArr[5], nil]];
            
            [self presentViewController:mc animated:YES completion:nil];
        }
            break;
        case 1003:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
          case 1004:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_personInfoDic[@"SJ"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
            case 1005:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_personInfoDic[@"GZDH"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1006:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_personInfoDic[@"SJXH"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        default:
            break;
    }
    
    
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [ProgressHUD showSuccess:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [ProgressHUD showError:msg];

            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
//    [self dismissModalViewControllerAnimated:YES];
}

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
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = Color_Black;
    cell.detailTextLabel.text =_infoArr[indexPath.row];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    cell.clipsToBounds = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_infoArr[indexPath.row] isEqualToString:@"无"]) {
        return 0;
    }
    return 50;
}

#pragma mark  保存用户电话代理事件
///保存到新的联系人
- (void)addNewContactPerson:(NSString *)phoneNumer phoneNum2:(NSString *)phoneNum2 withNickName:(NSString *)nickName{
    ///创建一个联系人的各个数值对象
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    
    ///设置手机号
    CNLabeledValue * phoneNumbers = [CNLabeledValue labeledValueWithLabel:@"手机号"
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:phoneNumer]];
    ///设置手机号
    CNLabeledValue * phoneNumber2 = [CNLabeledValue labeledValueWithLabel:@"工作电话"
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum2]];
    contact.phoneNumbers = @[phoneNumbers,phoneNumber2];
    //用户头像
    //    contact.imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://d.youth.cn/shrgch/201607/W020160715546162315241.jpg"]];
    contact.familyName = _personInfoDic[@"XM"];
    contact.departmentName = nickName;
    CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
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
    ABRecordSetValue(record, kABPersonDepartmentProperty, (__bridge CFStringRef)_personInfoDic[@"GZDH"], &error);  //部门
    
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)phoneNum, (__bridge CFTypeRef)_personInfoDic[@"SJ"], NULL);
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
