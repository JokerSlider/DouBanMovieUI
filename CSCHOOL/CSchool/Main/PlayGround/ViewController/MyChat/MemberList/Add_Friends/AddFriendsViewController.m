//
//  AddFriendsViewController.m
//  CSchool
//
//  Created by mac on 17/2/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AddFriendsCell.h"
#import "ChatModel.h"
#import <YYModel.h>
#import "FmdbTool.h"
#import "HQXMPPManager.h"
#import "ChatUserInfoViewController.h"
@interface AddFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)NSMutableArray *fetchRequestArtay;

@property (nonatomic,strong) NSFetchedResultsController *resultsContrl;


@end

@implementation AddFriendsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友请求";
    [self createView];
    [self registerAddfriendsNotifi];
    [self readFriendRequestData];
}
#pragma mark   从本地数据库中读取正在聊天的好友数据
-(void)readFriendRequestData
{
    _fetchRequestArtay   = [NSMutableArray array];
    NSArray *arr=[FmdbTool selectRequestDatawithXmppID:[HQXMPPManager shareXMPPManager].xmppStream.myJID];//[HQXMPPManager shareXMPPManager].xmppStream.myJID
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithCapacity:arr.count];
    for (ChatModel *item in arr) {
        [resultDict setObject:item forKey:item.fromStr];
    }
    NSArray *resultArray = resultDict.allValues;
    if (arr.count==0) {
        [self showErrorView:@"暂无好友请求" andImageName:nil];
    }else{
        [self hiddenErrorView];
    }
    self.fetchRequestArtay=[resultArray mutableCopy];
    [self reloadMyMessageData];
}
//强制刷新
-(void)reloadMyMessageData
{
    [self.mainTableView reloadData];
    [self.mainTableView setNeedsDisplay];
    
}
//注册接受好友请求的通知
-(void)registerAddfriendsNotifi
{
    //监听消息来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsRequest:) name:FrindsRequest object:nil];
}
-(void)createView
{
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _mainTableView.delegate =self;
    _mainTableView.dataSource =self;
    _mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:_mainTableView];
}
#pragma mark 有消息来的时候
-(void)friendsRequest:(NSNotification*)note
{
    [self hiddenErrorView];
    NSDictionary *dict=[note object];
    NSString *fromStr=[dict objectForKey:@"fromStr"]; //获得用户名
    XMPPJID *jid =[dict objectForKey:@"from"];
    NSString *msg = [dict objectForKey:@"message"];
    XMPPJID *myJid = [dict objectForKey:@"to"];
    NSString *time = [dict objectForKey:@"time"];
    //如果用户在本地数据库中已存在 
    if([FmdbTool selectfromString:fromStr xmppJid:jid]){
        NSLog(@"数据库中存在该用户");
        ChatModel *homeModel=[[ChatModel alloc]init];
        homeModel.fromStr = fromStr;
        homeModel.from = jid;
        homeModel.requestMsg = msg;
        homeModel.to = myJid;
        homeModel.badgeValue=@"1";
        homeModel.timeStr = time;
        [FmdbTool updateFfomString:fromStr xmppJid:jid andbadgeValue:homeModel.badgeValue andRequestMsg:msg withMyXmppID:myJid presenceTime:time];
    }else{
        //没有的话  添加数据
        ChatModel *homeModel=[[ChatModel alloc]init];
        homeModel.fromStr = fromStr;
        homeModel.from = jid;
        homeModel.requestMsg = msg;
        homeModel.to = myJid;
        homeModel.badgeValue = @"1";
        homeModel.timeStr = time;
        [FmdbTool addFriends:homeModel.fromStr xmppJid:jid andbadgeValue:homeModel.badgeValue andRequestMsg:msg withMyXmppID:myJid presenceTime:time];
        //重新加载标示图
        [self.fetchRequestArtay addObject:homeModel];
    }
    NSArray *sortArray =[self sortChatMessage];
    self.fetchRequestArtay = [NSMutableArray array];
    self.fetchRequestArtay = [NSMutableArray arrayWithArray:sortArray];
    [self readFriendRequestData];

}
//将聊天信息按照时间先后排序
-(NSArray *)sortChatMessage
{
    NSArray *result = [self.fetchRequestArtay  sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        ChatModel   *pModel1 = obj1;
        ChatModel    *pModel2 = obj2;
        //入职时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date1= [dateFormatter dateFromString:pModel1.timeStr];
        NSDate *date2= [dateFormatter dateFromString:pModel2.timeStr];
        
        if (date1==[date1 earlierDate: date2]) { //不使用intValue比较无效
            
            return NSOrderedDescending;//降序  NSOrderedAscending  NSOrderedAscending
            
        }else if (date1==[date1 laterDate: date2]) {
            return NSOrderedAscending;//升序  NSOrderedDescending
            
        }else{
            return NSOrderedSame;//相等
        }
        
    }];
    
    return result;
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchRequestArtay.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"chat_addFriends";
    AddFriendsCell *cell = [tableView cellForRowAtIndexPath:indexPath];;
    if (!cell) {
        cell = [[AddFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    }
    cell.model = _fetchRequestArtay[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    ChatModel *model = _fetchRequestArtay[indexPath.row];
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *presenceFromUser =[NSString stringWithFormat:@"%@", model.from];
        XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
        //判断是否子已经存在的好友
        XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:model.from xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        if ([user.subscription isEqualToString:@"both"]||[user.subscription isEqualToString:@"from"]||[user.subscription isEqualToString:@"to"]) {
            [_fetchRequestArtay removeObjectAtIndex:indexPath.row];
            [FmdbTool deleteFromString:model.fromStr xmppJid:model.from withMyXmppID:model.to];
            [_mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        }else{
            UIAlertController  *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除并拒绝该用户的添加好友请求？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_fetchRequestArtay removeObjectAtIndex:indexPath.row];
                [[HQXMPPManager shareXMPPManager].roster rejectPresenceSubscriptionRequestFrom:jid];//YES:自动发送请求添加对方为好友的请求   NO:不发送
                //从本地数据库清除 该人的添加好友请求。
                [FmdbTool deleteFromString:model.fromStr xmppJid:model.from withMyXmppID:model.to];
                [_mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self readFriendRequestData];
                
                NSArray *arr=[FmdbTool selectRequestDatawithXmppID:model.to];//[HQXMPPManager shareXMPPManager].xmppStream.myJID
                
                if (arr.count==0) {
                    [self showErrorView:@"暂无好友请求" andImageName:nil];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //do nothing
            }];
            
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            [self.navigationController presentViewController:alert animated:YES completion:^{
                //do nothing
            }];
        }
    };
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    action1.backgroundColor = [UIColor redColor];
    
    return @[action1];
}
// 必须写的方法，和editActionsForRowAtIndexPath配对使用，里面什么不写也行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击进入用户详情
    ChatUserInfoViewController *vc = [[ChatUserInfoViewController alloc]init];
    ChatModel *model = _fetchRequestArtay[indexPath.row];
    vc.jid = model.from;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:FrindsRequest];
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
