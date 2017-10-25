//
//  BaseViewController.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "BaseViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ProgressHUD.h"
#import "ChatMianViewController.h"
#import "MemberListViewController.h"
#import "ChatMessageViewController.h"
#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "HQXMPPChatRoomManager.h"
#import "JohnTopAlert.h"
#import "SettingLeftViewController.h"
#import "NewIndexViewController.h"
//#import "UITableView+Extension.h"
@interface BaseViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSString *_emptyStr;
    NSString *_emptyImage;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
         self.edgesForExtendedLayout=UIRectEdgeNone;
    }
#else
    float barHeight =0;
    if (!isIPad()&& ![[UIApplication sharedApplication] isStatusBarHidden]) {
        barHeight+=([[UIApplication sharedApplication]statusBarFrame]).size.height;
    }
    if(self.navigationController &&!self.navigationController.navigationBarHidden) {
        barHeight+=self.navigationController.navigationBar.frame.size.height;
    }
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height - barHeight);
        } else {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +barHeight, view.frame.size.width, view.frame.size.height);
        }
    }
#endif

    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = Base_Orange;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
       @{NSFontAttributeName:[UIFont systemFontOfSize:19],
         NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsCompact];
    //自定义返回按钮


    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendRequest:) name:FrindsRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageisCome:) name:SendMsgName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBecomeFriends:) name:CancelAddFriends object:nil];//拒绝成为好友
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeFriends:) name:DiDBecomeFriends object:nil];


}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SendMsgName object:nil];
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:FrindsRequest object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CancelAddFriends object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DiDBecomeFriends object:nil];

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#pragma mark 全功能通知
-(void)handleMessage:(NSNotification*)note
{
    NewIndexViewController *vc = [[NewIndexViewController alloc]init];
    [vc handleFuncMessage:note];
}

-(void)removeFuncNoti:(NSNotification*)note
{
    NewIndexViewController *vc = [NewIndexViewController new];
    [vc removeAllFunction:note];
}
#pragma 聊天的通知处理方法
//拒绝成为好友
-(void)cancelBecomeFriends:(NSNotification*)note
{
    if ([self isKindOfClass:[SettingLeftViewController class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict=[note object];
        NSString *body=[dict objectForKey:@"message"];
        NSString *alertMsg = [NSString stringWithFormat:@"%@",body];
        [JohnAlertManager showSuccessAlert:alertMsg  andTitle:@"好友请求" AndDelegate:self];
        MemberListViewController *_contactVC =[[MemberListViewController alloc]init];
        [_contactVC friendsRequest:note];
    });
}
//已经成为好友
-(void)DidBecomeFriends:(NSNotification*)note
{
    if ([self isKindOfClass:[SettingLeftViewController class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict=[note object];
        NSString *body=[dict objectForKey:@"message"];
        NSString *alertMsg = [NSString stringWithFormat:@"%@",body];
        [JohnAlertManager showSuccessAlert:alertMsg  andTitle:@"好友请求" AndDelegate:self];
        MemberListViewController *_contactVC =[[MemberListViewController alloc]init];
        [_contactVC friendsRequest:note];
    });
    
}

//有好友请求的时候
-(void)friendRequest:(NSNotification*)note
{
    if ([self isKindOfClass:[SettingLeftViewController class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict=[note object];
        NSString *body=[dict objectForKey:@"message"];
        XMPPJID *jid =[dict objectForKey:@"from"];
        NSString *userName = [[jid.user componentsSeparatedByString:@"_"] lastObject];//用户名
        body = [body isEqualToString:@"0"]?@"请求添加您为好友!":body;
        NSString *alertMsg = [NSString stringWithFormat:@"%@:%@",userName,body];
        //        [JohnAlertManager showFailedAlert:alertMsg andTitle:@"好友请求"];
        [JohnAlertManager showSuccessAlert:alertMsg  andTitle:@"好友请求" AndDelegate:self];
        
        MemberListViewController *_contactVC =[[MemberListViewController alloc]init];
        [_contactVC friendsRequest:note];
    });
}
//消息来得时候
-(void)messageisCome:(NSNotification*)note
{
    if ([self isKindOfClass:[SettingLeftViewController class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict=[note object];
        NSString *body=[dict objectForKey:@"body"];
        XMPPJID *jid =[dict objectForKey:@"jid"];
        NSString *messageType = [dict objectForKey:@"messageType"];
        XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:jid shouldFetch:YES];
        XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        if (!user) {
            NSString *jidStr = jid.user;
            XMPPJID *newJId =[XMPPJID jidWithString:jidStr];
            user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:newJId xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
        }
        NSString *userName = [[jid.user componentsSeparatedByString:@"_"] lastObject];//用户名
        
        if (friendvCard.nickname.length!=0) {
            userName= [NSString stringWithFormat:@"%@",friendvCard.nickname];
        }else if(user.nickname){
            userName = user.nickname;
            if ([user.nickname containsString:kDOMAIN]) {
                userName = [[jid.user componentsSeparatedByString:@"_"] lastObject];
            }
        }
        NSString *alertMessage = [NSString stringWithFormat:@"%@",body];
        
        if ([messageType isEqualToString:@"system"]) {
            //            [JohnAlertManager showFailedAlert:alertMessage andTitle:@"系统消息"]; - -- - 简洁版本
            [JohnAlertManager showSuccessAlert:alertMessage andTitle:@"系统消息" AndDelegate:self];
        }else if([messageType isEqualToString:@"groupchat"]){
            NSString *friendJIdStr =[NSString stringWithFormat:@"%@" ,jid];
            NSArray *friendArr = [friendJIdStr componentsSeparatedByString:@"/"];
            XMPPJID   *groupusrJid   =[XMPPJID jidWithUser:[friendArr lastObject] domain:kDOMAIN resource:nil];
            
            user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:groupusrJid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
            alertMessage =[NSString stringWithFormat:@"%@:%@",user.nickname,body];
            
            NSArray *roomArray =  [HQXMPPChatRoomManager shareChatRoomManager].roomList;
            for ( XMPPElement *element in roomArray) {
                NSString *jidString =element.attributesAsDictionary[@"jid"];
                XMPPJID *roomJid = [XMPPJID jidWithString:jidString];
                if ([roomJid.user isEqualToString:jid.user]) {
                    userName =[NSString stringWithFormat:@"%@",element.attributesAsDictionary[@"name"]];
                }
            }
            
            [JohnAlertManager showSuccessAlert:alertMessage andTitle:userName AndDelegate:self];
            
        }else{
            [JohnAlertManager showSuccessAlert:alertMessage andTitle:userName AndDelegate:self];
        }
        ChatMessageViewController *messageVC = [[ChatMessageViewController alloc]init];
        messageVC = [[ChatMessageViewController alloc]init];
        [messageVC readChatData];
        [messageVC messageCome:note];
    });
}
#pragma mark 点击弹窗进入聊天界面 或者 相应界面
-(void)tapAlertViewBySingle
{
    ChatMianViewController *vc = [[ChatMianViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setEmptyView:(UITableView *)tableView withString:(NSString *)emptyStr withImageName:(NSString *)imageName{
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    _emptyStr = emptyStr;
    _emptyImage = imageName;
    // A little trick for removing the cell separators
    if (!tableView.tableFooterView) {
        tableView.tableFooterView = [UIView new];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (!_emptyStr) {
        _emptyStr = @"";
    }
    NSString *text = _emptyStr;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:_emptyImage];
}
- (void)UMengEvent:(NSString *)event{
    [MobClick event:event];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SendMsgName object:nil];
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:FrindsRequest object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CancelAddFriends object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DiDBecomeFriends object:nil];
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
