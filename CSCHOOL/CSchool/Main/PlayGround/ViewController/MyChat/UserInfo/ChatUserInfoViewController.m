//
//  ChatUserInfoViewController.m
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChatUserInfoViewController.h"
#import "ChatUserInfoCell.h"
#import "ChatUserOtherCell.h"
#import "ChatAddFriendsFooterView.h"
#import <YYModel.h>
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "SetNickNameViewController.h"
#import "SDPhotoBrowser.h"
#import "ChatUserModel.h"
#import "MOFSPickerManager.h"

@interface ChatUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>

@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)NSMutableArray *modelArray;

@property (nonatomic,copy)NSString *userNiName;

@property (nonatomic,copy)NSString *address;

@property (nonatomic,copy)NSArray *userInfoArray;
@end

@implementation ChatUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    self.title = @"用户详情";
}
//加载数据
-(void)loadData
{
    _modelArray = [NSMutableArray array];
    NSArray *jidArr = [self.jid.bare componentsSeparatedByString:@"@"];
    NSString *userId = [NSString stringWithFormat:@"%@",[jidArr firstObject]];
    userId = [[userId componentsSeparatedByString:@"_"]lastObject];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"showPersonBaseInfo",@"userid":userId} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject[@"data"];
        ChatUserModel *userModel = [[ChatUserModel alloc]init];
        [userModel yy_modelSetWithDictionary:dic];
        [self handleData:userModel];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
}
//解析数据
-(void)handleData:(ChatUserModel *)userModel
{
    NSString *sex = [userModel.XBM isEqualToString:@"1"]?@"男":@"女";
    [[MOFSPickerManager shareManger]searchAddressByZipcode:userModel.CSDM block:^(NSString *address) {
        self.userInfoArray =@[
                              @{@"userMessage":@[@{@"picImageUrl":[self handleNullData:userModel.TXDZ],@"name":userModel.NC?userModel.NC:@"nil",@"sex":sex,@"nickName":@"",@"trueName":[self handleNullData:userModel.XM]}]},
                              @{@"setNickName":userModel.NC?userModel.NC:@"无"},
                              @{@"userInfo":@[@{@"nickTitle":@"学校",@"content":[self handleNullData:userModel.SDSNAME]},@{@"nickTitle":@"故乡",@"content":address?address:@"无"},@{@"nickTitle":@"鲜花",@"content":userModel.FLOWERSNUMBER?userModel.FLOWERSNUMBER:@"0"}]}
                              ];
        [self handleDataArray:self.userInfoArray];
    }];
}
-(NSString *)handleNullData:(NSString *)dataStr
{
    if (dataStr==nil&&dataStr.length==0) {
        return @"无";
    }
    return dataStr;
}
-(void)handleDataArray:(NSArray *)dataArray
{
    for (NSDictionary *dic in dataArray) {
        ChatModel *model = [[ChatModel alloc]init];
        model.from = _jid;
        [model yy_modelSetWithDictionary:dic];
        [_modelArray addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //设置 view 的 布局操作
        [self.mainTableView reloadData];
    });
}
-(void)createView
{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
}
#pragma mark Tableviewdelegate  &  datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _modelArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 3;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellID = @"userInfo_chat";
        ChatUserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];;
        if (!cell) {
            cell = [[ChatUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        XMPPJID *jid = _jid;
        ChatModel *model = _modelArray[indexPath.section];
        NSArray *userArr = model.userMessage;
        NSDictionary *dic = userArr[indexPath.row];
        ChatModel *Mymodel = [[ChatModel alloc]init];
        [Mymodel yy_modelSetWithDictionary:dic];

        Mymodel.userjid = jid;
        Mymodel.nickName = self.userNiName;
        cell.model = Mymodel;
        return cell;
    }else if (indexPath.section==1){
      
        static NSString *cellID = @"setUserNickName";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.textLabel.text = @"设置备注";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGB(1, 1, 1);
       
        return cell;
    }
    static NSString *cellID = @"userInfo";
    ChatUserOtherCell *cell = [tableView cellForRowAtIndexPath:indexPath];;
    if (!cell) {
        cell = [[ChatUserOtherCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    ChatModel *model = _modelArray[indexPath.section];
    NSArray *userInfoArray = model.userInfo;

    NSDictionary *dic = userInfoArray[indexPath.row];
    ChatModel *Mymodel = [[ChatModel alloc]init];
    [Mymodel yy_modelSetWithDictionary:dic];
    cell.model = Mymodel ;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 110;
    }else if (indexPath.section==2){
        return 60;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 15.0f;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 200;
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        ChatAddFriendsFooterView *view = [[ChatAddFriendsFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        
        view.userJid =_jid;
        //判断是否子已经存在的好友
        XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:_jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        if ([user.subscription isEqualToString:@"both"]) {
            view.addFriends.hidden = YES;
        }else{
            view.addFriends.hidden = NO;
        }
        return view;

        
    }
    return  nil;

}
/**
 点击事件
 
 @return void
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
       /* XMPPJID *jid = [XMPPJID jidWithString:_jid.user];
        if (!jid) {
            jid = _jid;
        }*/
        XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:_jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        if(![user.subscription isEqualToString:@"both"]){
            [ProgressHUD showError:@"对方还不是您的好友，不能设置昵称"];
            return;
        }
        SetNickNameViewController *vc =[[SetNickNameViewController alloc]init];
        vc.jid  = _jid;
        vc.groupName = self.groupName;
        vc.setNickNameSucessBlock = ^(NSString *nickName){
            self.userNiName = nickName;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView reloadData];
                [self.mainTableView setNeedsDisplay];
            });
  

        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 点击浏览

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
