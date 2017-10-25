//
//  MemberListViewController.m
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "MemberListViewController.h"
//#import "UITableView+SDAutoTableViewCellHeight.h"
#import "ChatModel.h"
#import "FellowRequestCell.h"
#import <YYModel.h>
#import "FellowRequestCell.h"
#import "MemberListHeaderView.h"
#import "UITabBar+MyTabbar.h"
#import "FellowCell.h"
#import "ChatUserInfoViewController.h"
#import "AddFriendsViewController.h"
#import "FmdbTool.h"
#import "XGChatViewController.h"
#import "XMPPvCardTemp.h"
#import "HQRosterStorageTool.h"
#import "SetNickNameViewController.h"

#import "AddFriendsViewController.h"
@interface MemberListViewController ()<UITableViewDelegate,UITableViewDataSource,FellowRequestDeleagate,NSFetchedResultsControllerDelegate>
{
    NSInteger currentSection;
    NSInteger currentRow;
    MemberListHeaderView *_secHeader;

}
/** 结果调度器 */
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)NSMutableArray *modelArray;
@property (nonatomic,strong)NSMutableArray *sectionOpen;
@property (nonatomic,strong)NSMutableArray *groupArray;//群组名称

@property (strong, nonatomic) HQRosterStorageTool * storageTool;

@property (nonatomic, retain) NSMutableArray *userMutableArray;

@property (nonatomic,strong)ChatModel *fetchRequestModel;

@end

@implementation MemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self initData];

    [self readFriendRequestData];
}

//收到通知....  更新数据信息
-(void)friendsRequest:(NSNotification*)note
{
    [self.tabBarController.tabBar  showBadgeOnItemIndex:1];;
    
    [self updateMessage:note];

    
}
-(void)updateMessage:(NSNotification*)note
{
    //接收到消息 只更新角标数据 不对数据库进行操作
    NSDictionary *dict=[note object];
    NSString *fromStr=[dict objectForKey:@"fromStr"]; //获得用户名
    XMPPJID *jid =[dict objectForKey:@"from"];
    NSString *msg = [dict objectForKey:@"message"];
    XMPPJID *myJid = [HQXMPPManager shareXMPPManager].xmppStream.myJID;
    BOOL isExist = [FmdbTool selectfromString:fromStr xmppJid:myJid];
    NSString *time = [dict objectForKey:@"time"];
    //如果该用户已经请求过添加好友则只更新请求信息不更新
    //没有的话  添加数据
    ChatModel *homeModel=[[ChatModel alloc]init];
    homeModel.fromStr = fromStr;
    homeModel.from = jid;
    homeModel.requestMsg = msg;
    homeModel.to = myJid;
    homeModel.badgeValue=@"1";
    homeModel.timeStr = time;
    if(isExist){
        //更新用户的请求信息
        [FmdbTool updateFfomString:fromStr xmppJid:jid andbadgeValue:homeModel.badgeValue andRequestMsg:msg withMyXmppID:myJid presenceTime:time];
    }else{
        [FmdbTool addFriends:fromStr xmppJid:jid andbadgeValue:homeModel.badgeValue andRequestMsg:msg withMyXmppID:myJid presenceTime:time];
    }
    [self readFriendRequestData];

}

-(void)readFriendRequestData
{

    NSArray *arr=[FmdbTool selectRequestDatawithXmppID:[HQXMPPManager shareXMPPManager].xmppStream.myJID];//[HQXMPPManager shareXMPPManager].xmppStream.myJID
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithCapacity:arr.count];
    for (ChatModel *item in arr) {
        [resultDict setObject:item forKey:item.fromStr];
    }
    //去除重复元素
    NSArray *resultArray = resultDict.allValues;
    int badgeValue=0;
    _fetchRequestModel = [[ChatModel alloc]init];
    ChatModel *model = [[ChatModel alloc]init];
    for (ChatModel *mymodel in resultArray) {
        badgeValue  = [mymodel.badgeValue intValue] + badgeValue;
        model.badgeValue =[NSString stringWithFormat:@"%d",badgeValue];
        model.to  = mymodel.to;
        model.from = mymodel.from;
        model.fromStr = mymodel.fromStr;
    }
    if (badgeValue!=0) {
        [self.tabBarController.tabBar showBadgeOnItemIndex:1];
    }else{
        model.badgeValue = nil;
        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
    }
    _fetchRequestModel = model;
    
    
    [self.mainTableView reloadData];
}

/**
 获取好友列表
 
 @return 返回查询实体
 */

-(void)createView
{

    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-46) style:UITableViewStyleGrouped];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableView];
    _modelArray = [NSMutableArray array];

}

#pragma mark private
- (void)initData{
    if ([HQXMPPUserInfo shareXMPPUserInfo].loginStatus) {
        self.storageTool = [[HQRosterStorageTool alloc] init];
        WEAKSELF;
        [self translateData];
        self.storageTool.dataUpdate = ^ (id sender){
            [weakSelf translateData];
            [weakSelf.mainTableView reloadData];
        };
        [self.mainTableView reloadData];
    }
}

- (NSMutableArray *)sectionOpen{
    if (!_sectionOpen) {
        _sectionOpen = [NSMutableArray array];
    }
    return _sectionOpen;
}


/**
 这里，将分组信息里的用户，只选择互相加好友的用户，并且排序将在线用户优先显示
 */
- (void)translateData{
//    [self.sectionOpen addObject:@"0"];
    self.userMutableArray = [NSMutableArray array];
    int i = 0;
    for (XMPPGroupCoreDataStorageObject *group in self.storageTool.fetchedResultsController.fetchedObjects) {
        if (self.sectionOpen.count <= i) {
            [self.sectionOpen addObject:@"0"];
        }
        i++;
        NSMutableArray *users = [NSMutableArray array];
        for (XMPPUserCoreDataStorageObject *user in [group.users allObjects]) {
            if (![user.subscription isEqualToString:@"none"]) {
                [users addObject:user];
            }
        }
        NSArray *userArr = [users sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([(NSNumber *)[obj1 valueForKey:@"sectionNum"] intValue]<[(NSNumber *)[obj2 valueForKey:@"sectionNum"] intValue]) {
                return NSOrderedAscending;
                
            }else{
                return NSOrderedDescending;
            }
        }];
        [self.userMutableArray addObject:userArr];
    }
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionOpen.count+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    BOOL sectionStatus = [self.sectionOpen[section-1] boolValue];
    if (sectionStatus) {
        if (_userMutableArray.count != 0) {
            NSArray *arr = _userMutableArray[section-1];
            return arr.count;
        }
        return 0;
    }else{
        //section是收起状态时候
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *ID = @"chatadd_Member";
        FellowRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[FellowRequestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.delegate = self;

        //如果该用户已经请求过添加好友则只更新请求信息不更新
        cell.model = _fetchRequestModel;
      
        return  cell;
    }
    static NSString *ID = @"chatMemberList1";
    FellowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FellowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    XMPPGroupCoreDataStorageObject *group = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.section-1];
    XMPPUserCoreDataStorageObject * user = self.userMutableArray[indexPath.section-1][indexPath.row];
    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:user.jid shouldFetch:YES];

    ChatModel *model = [[ChatModel alloc] init];
    model.name = user.displayName;
    model.userjid =user.jid;

    if (friendvCard.nickname.length!=0) {
        if ([user.nickname containsString:kDOMAIN]) {
            user.nickname = [[user.jid.user componentsSeparatedByString:@"_"]lastObject];
        }
        model.name = [NSString stringWithFormat:@"%@(%@)",user.nickname,friendvCard.nickname];
    }else if(user.nickname) {
        model.name = user.nickname;
        if ([user.nickname containsString:kDOMAIN]) {
            model.name = [[user.jid.user componentsSeparatedByString:@"_"] lastObject];
        }
    }
    model.avatarImage = [UIImage imageWithData:friendvCard.photo];
    if ([(NSNumber *)[user valueForKey:@"sectionNum"] intValue] == 0) { //为0时，为在线，2为离线。
        model.state = YES;
    }
    
    model.groupName = group.name;
    
    cell.model = model;
    return cell;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    MemberListHeaderView *header= [[MemberListHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51)];
    header.backgroundColor = [UIColor whiteColor];
    header.tap_button.selected = NO;
    [header.tap_button addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
    header.tap_button.tag = section-1;


    XMPPGroupCoreDataStorageObject *group = self.storageTool.fetchedResultsController.fetchedObjects[section-1];
    header.memberName.text = group.name;
    NSArray *users = _userMutableArray[section-1];
    header.memberNum.text = [NSString stringWithFormat:@"%ld",users.count];
    
    BOOL currentIsOpen ;
    if (section==currentSection+1) {
       currentIsOpen = ((NSNumber *)self.sectionOpen[currentSection]).boolValue;
    }else{
       currentIsOpen = ((NSNumber *)self.sectionOpen[section-1]).boolValue;
    }
    [header tranformImgaelocation:currentIsOpen];

    return header;

}

- (void)sectionAction:(UIButton *)value{
    currentSection = value.tag;
    NSNumber *sectionStatus = self.sectionOpen[[value tag]];
    BOOL newSection = ![sectionStatus boolValue];
    [self.sectionOpen replaceObjectAtIndex:[value tag] withObject:[NSNumber numberWithBool:newSection]];
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:[value tag]+1] withRowAnimation:UITableViewRowAnimationFade];
}
//收起全部section
-(void)reloadSections
{

    for (int i = 0; i < self.sectionOpen.count; i ++) {
        [self.sectionOpen replaceObjectAtIndex:i withObject:@"0"];
    }
    [self.mainTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 66;
    }
    return 65;
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        AddFriendsViewController *vc = [[AddFriendsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        //
        ChatModel   *model = _fetchRequestModel;
        model.badgeValue  = nil;
        _fetchRequestModel = model;
        [self.mainTableView reloadData];
        NSArray *arr=[FmdbTool selectRequestDatawithXmppID:model.to];//[HQXMPPManager shareXMPPManager].xmppStream.myJID

     
        for (ChatModel *mymodel in arr) {
            [FmdbTool clearRedPointwithFromString:mymodel.from withMyXmppID:model.to withbadgeValue:nil];
        }

        //隐藏小红点
        [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
        return;
    }
    XGChatViewController *vc = [[XGChatViewController alloc] init];
    XMPPUserCoreDataStorageObject * user = self.userMutableArray[indexPath.section-1][indexPath.row];
    NSArray *arr=[user.jidStr componentsSeparatedByString:@"@"];
    vc.jidStr = arr[0];
    XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:user.jid shouldFetch:YES];
    if (friendvCard.nickname.length!=0) {
        if (user.nickname) {
            if ([user.nickname containsString:kDOMAIN]) {
                user.nickname = [[user.jid.user componentsSeparatedByString:@"_"]lastObject];
            }
            vc.userName= [NSString stringWithFormat:@"%@(%@)",user.nickname,friendvCard.nickname];
        }else{
            vc.userName= [NSString stringWithFormat:@"%@",friendvCard.nickname];

        }
    }else if(user.nickname){
            vc.userName = user.nickname;
    }else{
       vc.userName = [[user.jid.user componentsSeparatedByString:@"_"]lastObject];
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 删除好友消息
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject * user = self.userMutableArray[indexPath.section-1][indexPath.row];
    XMPPGroupCoreDataStorageObject *group = self.storageTool.fetchedResultsController.fetchedObjects[indexPath.section-1];
    //删除好友
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

         [[HQXMPPManager shareXMPPManager].roster removeUser:user.jid];
        //从本地数据库清除与该人的聊天记录
        [_userMutableArray removeObject:self.userMutableArray[indexPath.section-1][indexPath.row]];
        [_mainTableView reloadData];
        
        // [_mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    //备注
    void(^rowActionHandler2)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        SetNickNameViewController *setNickNameVc = [[SetNickNameViewController alloc]init];
        setNickNameVc.jid  = user.jid;
        setNickNameVc.groupName = group.name;
        [self.navigationController pushViewController:setNickNameVc animated:YES];
    
    };
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    action1.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"备注" handler:rowActionHandler2];
    action3.backgroundColor = [UIColor lightGrayColor];
    
    return @[action3];
}
// 必须写的方法，和editActionsForRowAtIndexPath配对使用，里面什么不写也行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark FellowRequestCell

/**
 隐藏

 @param cell   FellowRequestCell  Cell
 */
-(void)FellowRequestCell:(FellowRequestCell *)cell
{
    [self.tabBarController.tabBar hideBadgeOnItemIndex:1];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:FrindsRequest];
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
