//
//  EmployessContactBookViewController.m
//  CSchool
//
//  Created by mac on 16/12/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "EmployessContactBookViewController.h"
#import "SegmentTapView.h"
#import "FlipTableView.h"
#import "EmDeparViewController.h"
#import "EmAllPersonNumViewController.h"
#include "SearchBaseViewController.h"
#import "NSString+PinYin.h"
#import "EmployyessCell.h"
#import "LPActionSheet.h"
#import "TePopList.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "XGAddPhoneNumber.h"
#import "OfficePersonInfoViewController.h"
#define Name  @"name"
#define Phone @"phonenum"
#define Bumen @"departments"
@interface EmployessContactBookViewController ()<SegmentTapViewDelegate,FlipTableViewDelegate,SearchBaseViewControllerDelegate,XGAlertViewDelegate>
{
    UIButton *rihghtButton;//导航栏右侧按钮
    NSArray *_searchSourArr;//搜索检索数据源
    NSArray *_telPhoneArr;
    NSString *_GZName;//用于弹窗的姓名展示
    NSString *cellPhoneNum;//点击单元格电话按钮号码;
    
    NSMutableDictionary *_SJHDic;//手机电话
    NSMutableDictionary *_GZDHDic;//工作电话
    UIWindow *_window;
    UIView *_leadBackView;//引导底部视图

}
@property (nonatomic,strong)SearchBaseViewController  *searchVc;
@property (nonatomic, strong)EmDeparViewController *myPushVc;//我得主页
@property (nonatomic, strong)EmAllPersonNumViewController *myFllowVc;//我得足迹
@property (nonatomic, strong)SegmentTapView *segment;
@property (nonatomic, strong)FlipTableView *flipView;

//数据
@property (nonatomic, strong) NSArray *dataNameArray;

@end

@implementation EmployessContactBookViewController

//懒加载
- (NSArray *)dataNameArray
{
    if (_dataNameArray == nil) {
        _dataNameArray = [NSArray array];
    }
    return _dataNameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSegMentView];
    [self setNavBtn];
    [self loadData];
}

//导航栏按钮
-(void)setNavBtn
{
    rihghtButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rihghtButton setImage:[UIImage imageNamed:@"employSearch"] forState:UIControlStateNormal];
    [rihghtButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:rihghtButton];
    self.navigationItem.rightBarButtonItem = leftItem;

}
-(void)loadData
{
    _SJHDic = [NSMutableDictionary dictionary];
    _GZDHDic = [NSMutableDictionary dictionary];
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
            [_GZDHDic setObject:GZDH forKey:name];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        [ProgressHUD dismiss];
        [self showErrorViewLoadAgain:error[@"msg"]];
    }];
}
-(void)createSegMentView
{
    _myPushVc  = [[EmDeparViewController alloc]init];
    _myFllowVc = [[EmAllPersonNumViewController alloc]init];
    //初始化时加载第一页的数据
    // 分段视图
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 40) withDataArray:@[@"部门筛选",@"姓名排序"] withFont:13];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    self.flipView = [[FlipTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.view.frame.size.height - 40) withArray:@[_myPushVc,_myFllowVc] withRootVC:self];
    self.flipView.delegate = self;
    [self.view addSubview:self.flipView];

}
#pragma mark 私有方法
-(void)searchAction
{
    _searchVc = [[SearchBaseViewController alloc] init];
    _searchVc.originalArray = [NSMutableArray arrayWithArray:self.dataNameArray];
    _searchVc.placeholder = @"姓名/手机号搜索";
    _searchVc.seacrKeyArr = @[Name,Phone];
    _searchVc.delegate = self;
    [self.navigationController pushViewController:_searchVc animated:YES];
    
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
//    NSString *damName= dict[@"departments"];
    _telPhoneArr = @[_SJHDic[_searchSourArr[indexPath.row][@"name"]],_GZDHDic[_searchSourArr[indexPath.row][@"name"]]];
    _GZName = name;
//    NSString *phoneNum =[NSString stringWithFormat:@"%@",dict[@"phonenum"]];
//    NSString *GZDH =[NSString stringWithFormat:@"%@",dict[@"gzdh"]];
    [self.searchVc.searchBar resignFirstResponder];
    [self lookInfo:nameID];

//    [LPActionSheet showActionSheetWithTitle:@"请对此联系人进行操作"
//                          cancelButtonTitle:@"取消"
//                     destructiveButtonTitle:@""
//                          otherButtonTitles:@[@"保存到联系人",@"发送短信",@"复制",@"拨打电话",@"查看详情"]
//                                    handler:^(LPActionSheet *actionSheet, NSInteger index) {
//                                        switch (index) {
//                                            case 0:
//                                            {
//                                                DLog(@"取消操作....");
//                                            }
//                                                break;
//                                            case 1:
//                                            {
//                                                [self savePhoneNum:phoneNum personName:name phoneNum2:GZDH withNickName:damName];
//                                                
//                                            }
//                                                break;
//                                            case 2:
//                                            {
//                                                [self sendMessage:phoneNum];
//                                            }
//                                                break;
//                                            case 3:
//                                            {
//                                                [self copyPhoneNum:[NSString stringWithFormat:@"%@,%@",phoneNum,GZDH]];
//                                            }
//                                                break;
//                                            case 4:
//                                            {
//                                                [self callPhone];
//                                            }
//                                                break;
//                                            case 5:
//                                            {
//                                                [self lookInfo:nameID];
//                                            }
//                                                break;
//                                            default:
//                                                break;
//                                        }
//                                        
//                                    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForSearchRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
    
}
//监听输入框的文本输入
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
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

#pragma mark -------- SegmentTapView delegate
-(void)selectedIndex:(NSInteger)index
{
    if (index==0) {
        
    }else{
        //
    }
    
    [self.flipView selectIndex:index];
    
}
-(void)scrollChangeToIndex:(NSInteger)index
{
    if (index==0) {
//        [_myPushVc loadMyPushNewData];
        
    }else{
        //        [_myFllowVc loadMyFllowNewData];
        
    }
    [self.segment selectIndex:index];
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
