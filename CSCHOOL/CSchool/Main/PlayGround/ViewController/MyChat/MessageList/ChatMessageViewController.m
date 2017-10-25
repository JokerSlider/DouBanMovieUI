//
//  ChatMessageViewController.m
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChatMessageViewController.h"
#import "ChatLisCell.h"
#import "ChatModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import <YYModel.h>
#import "XGChatViewController.h"
#import "XMPPFramework.h"
#import "HomeModel.h"
#import "FmdbTool.h"
#import "MessageModel.h"
#import "HQXMPPManager.h"
#import "MessageFrameModel.h"
#import "ChatUserInfoViewController.h"
#import "Add_NewFrindsViewController.h"
#import "HQRosterStorageTool.h"
#import "RequestMessageListViewController.h"
#import "XMPPvCardTemp.h"

@interface ChatMessageViewController ()<UITableViewDelegate,UITableViewDataSource,ResetCellMessageNumDeleagate,UIGestureRecognizerDelegate,XMPPStreamDelegate,XMPPRosterDelegate,NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultContr;//数据库查询结果控制器

}
//用户自己的头像
@property (nonatomic,strong) NSData *headImage;

//@property (nonatomic,strong,readwrite)UITableView *mainTableView;
//存放聊天最后一段信息的数组
@property(nonatomic,strong) NSMutableArray *chatData;
@property (nonatomic,assign)int messageCount; //未读的消息总数

@property (nonatomic,strong)  NSFetchedResultsController *resultController;

@property (strong, nonatomic) HQRosterStorageTool * storageTool;//好友分组管理工具


@end

@implementation ChatMessageViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.chatData = [NSMutableArray array];
    NSArray *arr=[FmdbTool selectAllDatawithXmppID:[HQXMPPManager shareXMPPManager].xmppStream.myJID andMessageType:nil];//[HQXMPPManager shareXMPPManager].xmppStream.myJID
    self.chatData=[arr mutableCopy];
    
    
    [self reloadMyMessageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readChatData];
    [self createView];
    [self initData];

}
#pragma mark 创建视图
-(void)createView
{
    //添加好友按钮
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-46) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableFooterView = [UIView new];
    [self.view addSubview: self.mainTableView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str
{
    NSArray *arr=[str componentsSeparatedByString:@"@"];
    return arr[0];
}
#pragma mark   从本地数据库中读取正在聊天的好友数据
-(void)readChatData
{
    self.chatData = [NSMutableArray array];
    NSArray *arr=[FmdbTool selectAllDatawithXmppID:[HQXMPPManager shareXMPPManager].xmppStream.myJID andMessageType:nil];//[HQXMPPManager shareXMPPManager].xmppStream.myJID
    self.chatData=[arr mutableCopy];
    [self reloadMyMessageData];
    //如果有未读消息的话 在标签栏下面显示未读消息
    for(HomeModel *model in arr){
        if(model.badgeValue.length>0 && ![model.badgeValue isEqualToString:@""]){
            int currentV=[model.badgeValue intValue];
            self.messageCount+=currentV;
        }
    }
    //如果消息数大于0
    if(self.messageCount>0){
        //如果消息总数大于99
        if(self.messageCount>=99){
            self.tabBarItem.badgeValue=@"99+";
        }else{
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
        }
        
    }
}

#pragma mark 有消息来的时候
-(void)messageCome:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    //设置未读消息总数消息 ([dict[@"user"]如果是正在和我聊天的用户才设置badgeValue)
    if([dict[@"user"] isEqualToString:@"other"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messageCount++;
            if(self.messageCount>=99){
                self.tabBarItem.badgeValue=@"99+";
            }else{
                self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
            }
        });
      
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateMessage:note];
    
    });
}
#pragma mark 更新消息
-(void)updateMessage:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    NSString *uname=[dict objectForKey:@"uname"]; //获得用户名
    NSString *body=[dict objectForKey:@"body"];
    XMPPJID *jid =[dict objectForKey:@"jid"];
    NSString *time=[dict objectForKey:@"time"];
    NSString *user=[dict objectForKey:@"user"];
    XMPPJID *myJid = [dict objectForKey:@"myJid"];
    NSString *messageType = [dict objectForKey:@"messageType"];

//    NSString *chatName = [dict objectForKey:@"chatName"];
   //如果用户在本地数据库中已存在 就直接更新聊天数据
    if([FmdbTool selectUname:uname withMyjid:myJid]){
        //修改模型数据
        [self.chatData enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL *stop) {
            HomeModel *model = (HomeModel *)obj;
            if ([model.uname isEqualToString:uname]) {
                *stop = YES;
            }
            if (*stop) {
                model.body=body;
                model.time=time;
                model.myJid = myJid;
                model.uname=uname;
                model.jid = jid;
                model.messageType = messageType;
                //如果是正在和我聊天的用户 才设置badgeValue
                if([user isEqualToString:@"other"]){
                    int currentV  =[model.badgeValue intValue]+1;
                    model.badgeValue=[NSString stringWithFormat:@"%d",currentV];
                    [self.chatData replaceObjectAtIndex:idx withObject:model];
                }else{
                    model.badgeValue=nil;
                }
                //更新数据库里面的值
                
                [FmdbTool updateWithName:uname detailName:body time:time badge:model.badgeValue withMyjid:myJid andUserJId:jid andMsgTyope:messageType];

            }
        }];
        }else{
        //没有的话  添加数据
        HomeModel *homeModel=[[HomeModel alloc]init];
        homeModel.uname=uname;
        homeModel.body=body;
        homeModel.jid=jid;
        homeModel.time=time;
        homeModel.myJid = myJid;
        homeModel.messageType = messageType;
        if([user isEqualToString:@"other"]){
            homeModel.badgeValue=@"1";
        }else{
            homeModel.badgeValue=nil;
        }
        [self.chatData addObject:homeModel];
        //重新加载标示图
        [FmdbTool addHead:nil uname:uname detailName:body time:time badge:homeModel.badgeValue xmppjid:jid withMyjid:myJid andMsgType:messageType];
    }
    int MessageNum = 0;
    
    for (HomeModel *model in _chatData) {
        
        MessageNum +=  [model.badgeValue intValue];
    }
    NSDictionary *dic = @{
                          @"funcID":@"40",
                          @"msgNum":[NSString stringWithFormat:@"%d",MessageNum]
                          };
    
    NSNotification *allFuncNote = [[NSNotification alloc]initWithName:AllFunctionNotication object:dic userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:allFuncNote];
    //将系统消息存档
    AppUserIndex *shareConfig = [AppUserIndex GetInstance];
    NSMutableArray *funcArr =[NSMutableArray arrayWithArray:shareConfig.funcMsgArr];
    if (funcArr.count == 0) {
        [funcArr addObject:dic];
    }
    [funcArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"funcID"] isEqualToString:@"40"]) {
            // do sth
            [funcArr removeObject:obj];
            [funcArr addObject:dic];
            *stop = YES;
        }else{
            [funcArr addObject:dic];
            *stop = YES;
        }
    }];

    shareConfig.funcMsgArr = funcArr;
    [shareConfig saveToFile];

    [self resetTabarNum];
    NSArray *sortArray =[self sortChatMessage:self.chatData];
    self.chatData = [NSMutableArray array];
    self.chatData = [NSMutableArray arrayWithArray:sortArray];

    [self reloadMyMessageData];
}
-(void)reloadMyMessageData
{
    if (self.chatData.count==0) {
        [self showErrorView:@"暂时没有消息哦~" andImageName:@"noMessage"];
    }else{
        [self hiddenErrorView];
    }
    [self.mainTableView reloadData];
    [self.mainTableView setNeedsDisplay];
    [self resetTabarNum];
}
//将聊天信息按照时间先后排序
-(NSArray *)sortChatMessage:(NSMutableArray *)sourceArr
{
    NSArray *result = [sourceArr  sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        HomeModel *pModel1 = obj1;
        HomeModel *pModel2 = obj2;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date1= [dateFormatter dateFromString:pModel1.time];
        NSDate *date2= [dateFormatter dateFromString:pModel2.time];
        
        
        if (date1==[date1 earlierDate: date2]) {
            
            return NSOrderedDescending;//NSOrderedDescending
            
        }else if (date1==[date1 laterDate: date2]) {
            return NSOrderedAscending;//NSOrderedAscending
            
        }else{
            return NSOrderedSame;
        }

    }];
    
    return result;
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatData.count;;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"chatMessage";
    ChatLisCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ChatLisCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.delegate = self;
    HomeModel  *model = self.chatData[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class currentClass = [ChatLisCell class];
    HomeModel *model = _chatData[indexPath.row];
    return [self.mainTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:currentClass contentViewWidth:[self cellContentViewWith]];
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
#pragma mark  TableviewDelegate

- (void)initData{
    if ([HQXMPPUserInfo shareXMPPUserInfo].loginStatus) {
        self.storageTool = [[HQRosterStorageTool alloc] init];
        self.storageTool.dataUpdate = ^ (id sender){
            
        };
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatLisCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    HomeModel   *model = _chatData[indexPath.row];
    model.badgeValue  = nil;
    cell.model = model;
    [_chatData replaceObjectAtIndex:indexPath.row withObject:model];

    [FmdbTool updateWithName:model.uname detailName:model.body time:nil badge:nil withMyjid:model.myJid  andUserJId:model.jid andMsgTyope:model.messageType];

    [self resetTabarNum];
    
    if ([model.messageType isEqualToString:@"system"]) {
        RequestMessageListViewController *vc = [[RequestMessageListViewController alloc]init];
        vc.userJid = model.jid;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //赋值分组名称
    XGChatViewController *vc = [[XGChatViewController alloc] init];
    if ([model.messageType isEqualToString:@"groupchat"]) {
        vc.isRoomChat = YES;
        vc.groupName = cell.userNickName.text;
    }else{
        vc.isRoomChat = NO;
        NSString *sectionName ;
        for (XMPPGroupCoreDataStorageObject *group in self.storageTool.fetchedResultsController.fetchedObjects) {
            for (XMPPUserCoreDataStorageObject *user in [group.users allObjects]) {
                
                if ([user.jid.user isEqualToString:model.jid.user]) {
                    sectionName = group.name;
                }
            }
        }
        HomeModel  *model = self.chatData[indexPath.row];
        vc.sectionName = sectionName;
        vc.userName = [[model.jid.user componentsSeparatedByString:@"_"] lastObject];//用户名
        XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:model.jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:model.jid shouldFetch:YES];

        if (!user) {
            NSString *jidStr = model.jid.user;
            XMPPJID *newJId =[XMPPJID jidWithString:jidStr];
            user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:newJId xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        }
        if (friendvCard.nickname.length!=0) {
            if ([user.nickname containsString:kDOMAIN]) {
                user.nickname = [[user.jid.user componentsSeparatedByString:@"_"]lastObject];
            }
            vc.userName = [NSString stringWithFormat:@"%@(%@)",user.nickname,friendvCard.nickname];
        }else if(user.nickname){
            vc.userName  = [NSString stringWithFormat:@"%@",user.nickname];
        }else{
            vc.userName = [[model.jid.user componentsSeparatedByString:@"_"]lastObject];
        }
    }
    vc.jidStr = [NSString stringWithFormat:@"%@", model.jid];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    HomeModel *model = self.chatData[indexPath.row];
    void(^rowActionHandler)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [_chatData removeObjectAtIndex:indexPath.row];
        [self resetTabarNum];
        //从本地数据库清除与该人的聊天记录
        [FmdbTool deleteWithName:model.uname withXmppID:model.myJid];
        //删除所有本地聊天记录
        [_mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self reloadMyMessageData];
    };

    //标为已读
    void(^rowActionHandler2)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        HomeModel *model = self.chatData[indexPath.row];
        if (model.badgeValue) {
            model.badgeValue = nil;
            [_chatData replaceObjectAtIndex:indexPath.row withObject:model];
            [self resetTabarNum];
            [FmdbTool updateWithName:model.uname detailName:model.body time:nil badge:nil withMyjid:model.myJid  andUserJId:model.jid andMsgTyope:model.messageType];

            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{

        }
    };

    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:rowActionHandler];
    action1.backgroundColor = [UIColor redColor];

    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"标为已读" handler:rowActionHandler2];
    action3.backgroundColor = [UIColor orangeColor];
    
    return @[action1];
}
// 必须写的方法，和editActionsForRowAtIndexPath配对使用，里面什么不写也行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark  设置tabbar的消息数量

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}
#pragma mark 侧滑手势
-(void)panGestureRecognized:(UIPanGestureRecognizer *)gester
{
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([[otherGestureRecognizer.view class] isSubclassOfClass:[UITableView class]]) {
        return NO;
    }
    
    if( [[otherGestureRecognizer.view class] isSubclassOfClass:[ChatLisCell class]] ||
       [NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UITableViewCellScrollView"] ||
       [NSStringFromClass([otherGestureRecognizer.view class]) isEqualToString:@"UITableViewWrapperView"]) {
        
        return YES;
    }
    return YES;
}
#pragma mark  设置tabbar的消息数量
-(void)resetTabarNum
{
    int MessageNum = 0;

    for (HomeModel *model in _chatData) {
        
        MessageNum +=  [model.badgeValue intValue];
    }
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
    if (MessageNum>99) {
        item.badgeValue = @"99+";
        return;
    }else if (MessageNum == 0){
        item.badgeValue = nil;
        return;
    }
    item.badgeValue = [NSString stringWithFormat:@"%d",MessageNum];
    

}
#pragma CellDelegate
-(void)MessgaeCell:(ChatLisCell *)cell
{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    HomeModel   *model = _chatData[indexPath.row];
    model.badgeValue  = nil;
    [_chatData replaceObjectAtIndex:indexPath.row withObject:model];
    [self reloadMyMessageData];
    [FmdbTool updateWithName:model.uname detailName:model.body time:nil badge:nil withMyjid:model.myJid  andUserJId:model.jid andMsgTyope:model.messageType];
    [self resetTabarNum];
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
