//
//  GroupListViewController.m
//  CSchool
//
//  Created by mac on 17/2/14.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "GroupListViewController.h"
#import "GroupViewCell.h"
#import "UITabBar+MyTabbar.h"
#import "GroupInfoViewController.h"
#import "HQXMPPChatRoomManager.h"
#import "XGChatViewController.h"
#import "NSString+HQUtility.h"
#import "ChatUserModel.h"
#import <YYModel.h>
@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self loadData];
    
    //收到群列表更新后重新刷新列表
//    WEAKSELF;
//    [HQXMPPChatRoomManager shareChatRoomManager].updateData = ^(id sender){
//        [weakSelf.mainTableView reloadData];
//    };
}
-(void)loadData
{
#warning ⚠️演示版，记得修改⚠️
    NSArray *arr = [[HQXMPPUserInfo shareXMPPUserInfo].user componentsSeparatedByString:@"_"];
    NSString *roleId = arr.count == 2?arr[1]:[AppUserIndex GetInstance].role_id;
    _modelArray = [NSMutableArray array];
    [NetworkCore requestPOST:[AppUserIndex GetInstance].API_URL  parameters:@{@"rid":@"getGroupsByPerson",@"userid":stuNum} success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        for (NSDictionary *dic in responseObject[@"data"]) {
            ChatUserModel *model = [[ChatUserModel alloc]init];
            [model yy_modelSetWithDictionary:dic];
            [_modelArray addObject:model];
        }
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSDictionary * _Nullable error) {
        
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //查询群列表
//    [[HQXMPPChatRoomManager shareChatRoomManager] queryRooms];
}

-(void)createView
{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-46) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:_mainTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
//    return [HQXMPPChatRoomManager shareChatRoomManager].roomList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GroupID";
    GroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[GroupViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = _modelArray[indexPath.row];
//    cell.xmppElement = [HQXMPPChatRoomManager shareChatRoomManager].roomList[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XGChatViewController *vc = [[XGChatViewController alloc]init];
    ChatUserModel *model = _modelArray[indexPath.row];
    NSString *groupDomain = [NSString stringWithFormat:@"%@@conference.toplion.toplion-domain",model.ROOMJID];

//    XMPPJID *jid = [XMPPJID jidWithString:groupDomain];
//    XMPPElement *element = [HQXMPPChatRoomManager shareChatRoomManager].roomList[indexPath.row];
//    vc.jidStr = element.attributesAsDictionary[@"jid"];
    vc.jidStr = groupDomain;
    vc.roomJid = model.ROOMJID;
    vc.isRoomChat = YES;
    vc.groupName = model.GROUPNAME;
//    vc.groupName =element.attributesAsDictionary[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
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
