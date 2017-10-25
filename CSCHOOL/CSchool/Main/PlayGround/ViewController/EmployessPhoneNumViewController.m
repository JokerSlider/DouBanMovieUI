//
//  EmployessPhoneNumViewController.m
//  CSchool
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "EmployessPhoneNumViewController.h"
#import "NSString+PinYin.h"
#import "EmployyessCell.h"
#import "ClassPhoneNumViewController.h"
#include "SearchBaseViewController.h"
#import "OfficePersonInfoViewController.h"
#import "LPActionSheet.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "XGAddPhoneNumber.h"
#import "WSDropMenuView.h"
#import "TePopList.h"

#define Name  @"name"
#define Phone @"phonenum"
#define Bumen @"departments"
@interface EmployessPhoneNumViewController ()<UITableViewDelegate,UITableViewDataSource,SearchBaseViewControllerDelegate,WSDropMenuViewDataSource,WSDropMenuViewDelegate,XGAlertViewDelegate,ABNewPersonViewControllerDelegate,CNContactViewControllerDelegate>
{
    NSMutableArray *_originNameData;
    NSMutableArray *_originPhoneData;
    
    NSMutableDictionary *_SJHDic;//手机电话
    NSMutableDictionary *_GZDHDic;//工作电话
    NSString *_GZName;//用于弹窗的姓名展示

    NSMutableDictionary *_IDDic;
    NSMutableDictionary *_DAMDic;//职位
    
    NSMutableDictionary *deparDic;
    NSArray *_originData;
    
    UIButton *rihghtButton;//导航栏右侧按钮
    NSString *cellPhoneNum;//点击单元格电话按钮号码;
    NSArray *_telPhoneArr;

    NSArray *_searchSourArr;//搜索检索数据源
    LPActionSheet *_lpActionSheet;
    
}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataNameArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,strong)SearchBaseViewController  *searchVc;

@end

@implementation EmployessPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadBaseData];
    [self loadData];
    [self setUpView];
}
//懒加载
- (NSArray *)dataNameArray
{
    if (_dataNameArray == nil) {
        _dataNameArray = [NSArray array];
    }
    return _dataNameArray;
}

-(void)loadBaseData
{
    /*@获取全部教师数据***/
    _originNameData = [NSMutableArray array];
    _originPhoneData = [NSMutableArray array];
    _SJHDic = [NSMutableDictionary dictionary];
    _IDDic = [NSMutableDictionary dictionary];
    _DAMDic=[NSMutableDictionary dictionary];
    _GZDHDic = [NSMutableDictionary dictionary];
}
-(void)setUpView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-104) style:UITableViewStylePlain];
    self.tableView.delegate  =self;
    self.tableView.dataSource  =self;
    self.tableView.sectionIndexColor = Base_Orange;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    rihghtButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rihghtButton setImage:[UIImage imageNamed:@"employSearch"] forState:UIControlStateNormal];
    [rihghtButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:rihghtButton];
    self.navigationItem.rightBarButtonItem = leftItem;
    
}
-(void)searchAction
{
    _searchVc = [[SearchBaseViewController alloc] init];
    _searchVc.originalArray = [NSMutableArray arrayWithArray:self.dataNameArray];
    _searchVc.placeholder = @"姓名/手机号搜索";
    _searchVc.seacrKeyArr = @[Name,Phone];
    _searchVc.delegate = self;
    [self.navigationController pushViewController:_searchVc animated:YES];

}
#pragma mark 初始化数据

-(void)loadData{
    _originData = [NSArray array];
    [ProgressHUD show:@"正在加载..."];
        [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getDepartInfo" } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        _originData = [responseObject objectForKey:@"data"];
        if (_originData.count==0) {
            [ProgressHUD dismiss];
            [self showErrorViewLoadAgain:@"获取通讯录信息失败"];
        }
        else{
            WSDropMenuView *dropMenu = [[WSDropMenuView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40)];
            dropMenu.dataSource = self;
            dropMenu.delegate  =self;
            [self.view addSubview:dropMenu];
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL parameters:@{@"rid":@"getAllTeacherInfo"} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        _dataNameArray = responseObject[@"data"];
        NSString *name;
        NSString *phoneNum;
        NSString *GZDH;//工作电话
        for (NSDictionary *dic in _dataNameArray) {
            name = dic[@"name"]?dic[@"name"]:@"无";
            phoneNum = dic[@"phonenum"]?dic[@"phonenum"]:@"无";
            GZDH = dic[@"gzdh"]?dic[@"gzdh"]:@"无";
            [_SJHDic setObject:phoneNum forKey:name];
            [_IDDic setObject:dic[@"num"] forKey:name];
            [_DAMDic setObject:dic[@"departments"] forKey:name];
            [_GZDHDic setObject:GZDH forKey:name];
            [_originNameData  addObject:name];
        }
        self.dataArray = [[_originNameData arrayWithPinYinFirstLetterFormat]mutableCopy];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];

}
#pragma  mark SearchViewControllerDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath withDataSourceArr:(NSMutableArray *)dataArr withSearchText:(NSString *)text
{
    static NSString *cellIdentifier = @"EmPloyCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([EmployyessCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    EmployyessCell *cell = (EmployyessCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    NSDictionary *dict = dataArr[indexPath.row];
    _searchSourArr = dataArr;
    cell.emName.text = dict[@"name"];
    cell.emPhoneNum.text = [NSString stringWithFormat:@"%@/%@", dict[@"phonenum"],dict[@"gzdh"]] ;
    [cell.callAction addTarget:self action:@selector(searchCallPhone:) forControlEvents:UIControlEventTouchDown];
    return cell;
}
/**@"搜索框 打电话"**/

-(void)searchCallPhone:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    EmployyessCell* myCell = (EmployyessCell *)[[btn superview]superview]; //表示Button添加在了Cell中。
    NSIndexPath * indexPath = [_searchVc.mainTableView indexPathForCell:myCell];
    NSDictionary *dict = _searchSourArr[indexPath.row];

    _GZName = dict[@"name"];
    _telPhoneArr = @[dict[@"phonenum"],dict[@"gzdh"]];
    [self callPhone];
}
-(void)tableView:(UITableView *)tableView didSelectSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = _searchSourArr[indexPath.row];
    NSString *name = dict[@"name"];
    NSString *nameID = dict[@"num"];
    NSString *damName= dict[@"departments"];
    _telPhoneArr = @[_SJHDic[_searchSourArr[indexPath.row][@"name"]],_GZDHDic[_searchSourArr[indexPath.row][@"name"]]];
    _GZName = name;
    NSString *phoneNum =[NSString stringWithFormat:@"%@",dict[@"phonenum"]];
    NSString *GZDH =[NSString stringWithFormat:@"%@",dict[@"gzdh"]];
    [self.searchVc.searchBar resignFirstResponder];
    [LPActionSheet showActionSheetWithTitle:@"请对此联系人进行操作"
                          cancelButtonTitle:@"取消"
                     destructiveButtonTitle:@""
                          otherButtonTitles:@[@"保存到联系人",@"发送短信",@"复制",@"拨打电话",@"查看详情"]
                                    handler:^(LPActionSheet *actionSheet, NSInteger index) {
                                        switch (index) {
                                            case 0:
                                            {
                                                DLog(@"取消操作....");
                                            }
                                                break;
                                            case 1:
                                            {
                                                [self savePhoneNum:phoneNum personName:name phoneNum2:GZDH withNickName:damName];
                                                
                                            }
                                                break;
                                            case 2:
                                            {
                                                [self sendMessage:phoneNum];
                                            }
                                                break;
                                            case 3:
                                            {
                                                [self copyPhoneNum:[NSString stringWithFormat:@"%@,%@",phoneNum,GZDH]];
                                            }
                                                break;
                                            case 4:
                                            {
                                                [self callPhone];
                                            }
                                                break;
                                            case 5:
                                            {
                                                [self lookInfo:nameID];
                                            }
                                                break;
                                            default:
                                                break;
                                        }
                                        
                                    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
    
}
//监听输入框的文本输入
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

}
#pragma  mark  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArray[section];
    NSMutableArray *array = dict[@"content"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EmPloyCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([EmployyessCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    EmployyessCell *cell = (EmployyessCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    NSDictionary *dict = self.dataArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    cell.emName.text = array[indexPath.row];
    cell.emPhoneNum.text = [NSString stringWithFormat:@"%@/%@", _SJHDic[array[indexPath.row]],_GZDHDic[array[indexPath.row]]] ;
    cell.callAction.tag = indexPath.row;
    [cell.callAction addTarget:self action:@selector(btnOnClickTouched:) forControlEvents:UIControlEventTouchDown];
    return cell;
}
/**@"点击cell拨打电话"**/
- (void)btnOnClickTouched:(UIButton *)aButton
{
    UIButton *btn = (UIButton *)aButton;
    
//    NSLog(@" [btn superview] =  %@ ",[[btn superview]class]);
//    NSLog(@" [[[btn superview]superview]superview]class] = %@",[[[btn superview]superview] class]);
    EmployyessCell* myCell = (EmployyessCell *)[[btn superview]superview]; //表示Button添加在了Cell中。
    NSIndexPath * indexPath = [self.tableView indexPathForCell:myCell];
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    _GZName = array[indexPath.row];
    _telPhoneArr = @[_SJHDic[array[indexPath.row]],_GZDHDic[array[indexPath.row]]];
    [self callPhone];
}

-(void)callPhone
{

    for (NSString *obj in _telPhoneArr) {
        if ([obj isEqualToString:@"无"]) {
            [ProgressHUD showError:@"手机号为空!"];
            return;
        }
    }
    TePopList *pop = [[TePopList alloc] initWithListDataSource:_telPhoneArr withTitle:@"选择电话" withSelectedBlock:^(NSInteger select) {
        cellPhoneNum = _telPhoneArr[select];
        if ([cellPhoneNum isEqualToString:@"无"]) {
            [ProgressHUD showError:@"手机号为空"];
            return ;
        }
        XGAlertView *tellAlert=[[XGAlertView alloc]initWithTarget:self withTitle:[NSString stringWithFormat:@"拨打'%@'电话?",_GZName] withContent:[NSString stringWithFormat:@"电话:%@",cellPhoneNum] WithCancelButtonTitle:@"拨打" withOtherButton:@"取消"];
        tellAlert.delegate = self;
        tellAlert.tag = 1000;
        [tellAlert show];
        
    }];
    [pop selectIndex:-1];
    pop.isAllowBackClick = YES;
    [pop show];

}
-(void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    if (view.tag==1000) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",cellPhoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
#pragma mark tableViewDelegate/DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.dataArray[section];
    NSString *title = dict[@"firstLetter"];
    return title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in self.dataArray) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理    
        if (index == 0) {
            return 0;
        }
    return index;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    NSString *name = array[indexPath.row];
    NSString *nameID = _IDDic[name];
    NSString *damName= _DAMDic[name];
    _telPhoneArr = @[_SJHDic[array[indexPath.row]],_GZDHDic[array[indexPath.row]]];
    _GZName = name;
    NSString *phoneNum =[NSString stringWithFormat:@"%@",_SJHDic[array[indexPath.row]]];
    NSString *GZDH =[NSString stringWithFormat:@"%@",_GZDHDic[array[indexPath.row]]];

    [LPActionSheet showActionSheetWithTitle:@"请对此联系人进行操作"
                          cancelButtonTitle:@"取消"
                     destructiveButtonTitle:@""
                          otherButtonTitles:@[@"保存到联系人",@"发送短信",@"复制",@"拨打电话",@"查看详情"]
                                    handler:^(LPActionSheet *actionSheet, NSInteger index) {
                                        switch (index) {
                                            case 0:
                                            {
                                            }
                                                break;
                                            case 1:
                                            {
                                                [self savePhoneNum:phoneNum personName:name phoneNum2:GZDH withNickName:damName];
                                                
                                            }
                                                break;
                                            case 2:
                                            {
                                                [self sendMessage:phoneNum];
                                            }
                                                break;
                                            case 3:
                                            {
                                                [self copyPhoneNum:[NSString stringWithFormat:@"%@,%@",phoneNum,GZDH]];
                                            }
                                                break;
                                            case 4:
                                            {
                                                [self callPhone];
                                            }
                                                break;
                                            case 5:
                                            {
                                                [self lookInfo:nameID];
                                            }
                                                break;
                                            default:
                                                break;
                                        }
                                        
                                    }];
}

//查看详情
-(void)lookInfo:(NSString *)nameID
{
    OfficePersonInfoViewController *classPhoneVC = [[OfficePersonInfoViewController alloc]init];
    classPhoneVC.title = @"详情";
    classPhoneVC.nameID = nameID;
    [self.navigationController pushViewController:classPhoneVC animated:YES];
}
/**@打电话**/
-(void)callPhoneNum:(NSString *)phoneNum
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
/**@发短信**/
-(void)sendMessage:(NSString *)phoneNum
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNum]]];

}
/**@复制**/
-(void)copyPhoneNum:(NSString *)phoneNum
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.persistent = NO;
    [pab setString:phoneNum];
    if (pab == nil) {
        [ProgressHUD showError:@"复制失败"];
    }else{
        [ProgressHUD showSuccess:@"复制成功"];
    }

}
/**@保存**/
-(void)savePhoneNum:(NSString *)phoneNum personName:(NSString *)name phoneNum2:(NSString *)phoneNum2 withNickName:(NSString *)nickName
{
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
                [self addNewContactPerson:phoneNum phoneNum:phoneNum2 personName:name nickName:nickName];
            }else{
                //9.0弃用的方法
                [self pushToNewPersonViewController:phoneNum personName:name];
            }
        }
            break;
        default:
            break;
    }
 
}
#pragma mark  保存用户电话代理事件
///保存到新的联系人
- (void)addNewContactPerson:(NSString *)phoneNumer phoneNum:(NSString *)phoneNum2 personName:(NSString *)name nickName:(NSString *)nickName{
    ///创建一个联系人的各个数值对象
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    
    ///设置手机号
    CNLabeledValue * phoneNumbers = [CNLabeledValue labeledValueWithLabel:@"手机"
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:phoneNumer]];
    CNLabeledValue * phoneNumber2 = [CNLabeledValue labeledValueWithLabel:@"工作电话"
                                                                    value:[CNPhoneNumber phoneNumberWithStringValue:phoneNum2]];
    contact.phoneNumbers = @[phoneNumbers,phoneNumber2];
    //用户头像
//    contact.imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://d.youth.cn/shrgch/201607/W020160715546162315241.jpg"]];
    contact.familyName = name;
    contact.departmentName = nickName;//职称
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
//    if (_personSeniorArr.count!=0) {
//        contact.organizationName =[NSString stringWithFormat:@"%@-%@-%@",_personSeniorArr[0],_personSeniorArr[1],_personSeniorArr[2]];
//    }
    CNContactViewController * addContactVc = [CNContactViewController viewControllerForNewContact:contact];
    addContactVc.delegate = self;
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:addContactVc];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
    
}
//进入新建联系人控制器
- (void)pushToNewPersonViewController:(NSString *)phoneNum personName:(NSString *)name
{
    //初始化添加联系人的控制器
    ABNewPersonViewController * newPersonViewController = [[ABNewPersonViewController alloc]init];
    //设置代理
    newPersonViewController.newPersonViewDelegate = self;
    
    // 创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    // 设置联系人的名字
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    ABRecordSetValue(record, kABPersonDepartmentProperty, (__bridge CFStringRef)phoneNum, &error);  //部门
    
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)phoneNum, (__bridge CFTypeRef)phoneNum, NULL);
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

#pragma mark - WSDropMenuView DataSource -
- (NSInteger)dropMenuView:(WSDropMenuView *)dropMenuView numberWithIndexPath:(WSIndexPath *)indexPath{
    
    //WSIndexPath 类里面有注释
    
    if (indexPath.column == 0 && indexPath.row == WSNoFound) {
        
        return _originData.count;
    }
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item == WSNoFound) {
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        return arr.count;
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank == WSNoFound) {
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        NSDictionary *departDic = arr[indexPath.item];
        NSArray *perArr = departDic[@"personname"];
        return perArr.count;
    }
    
    return 0;
}

- (NSString *)dropMenuView:(WSDropMenuView *)dropMenuView titleWithIndexPath:(WSIndexPath *)indexPath{
    
    //return [NSString stringWithFormat:@"%ld",indexPath.row];
    
    //左边 第一级
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item == WSNoFound) {
        
        return _originData[indexPath.row][@"seniorname"];
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank == WSNoFound) {
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        return arr[indexPath.item][@"departname"];
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank != WSNoFound) {
        
        NSDictionary *dic = _originData[indexPath.row];
        NSArray *arr = dic[@"departments"];
        NSDictionary *departDic = arr[indexPath.item];
        NSArray *perArr = departDic[@"personname"];
        
        return perArr[indexPath.rank][@"name"];
    }
    
    
    return @"";
    
}

#pragma mark - WSDropMenuView Delegate -

- (void)dropMenuView:(WSDropMenuView *)dropMenuView didSelectWithIndexPath:(WSIndexPath *)indexPath{
    
    OfficePersonInfoViewController *classPhoneVC = [[OfficePersonInfoViewController alloc]init];
    
    NSDictionary *dic = _originData[indexPath.row];
    NSArray *arr = dic[@"departments"];
    NSDictionary *departDic = arr[indexPath.item];
    NSArray *perArr = departDic[@"personname"];
    
    classPhoneVC.nameID = perArr[indexPath.rank][@"nameid"];
    
    [self.navigationController pushViewController:classPhoneVC animated:YES];
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
