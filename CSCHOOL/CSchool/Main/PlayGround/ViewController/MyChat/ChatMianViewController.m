//
//  ChatMianViewController.m
//  CSchool
//
//  Created by mac on 17/2/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "ChatMianViewController.h"
#import "ChatMessageViewController.h"
#import "MemberListViewController.h"
#import "GroupListViewController.h"
#import "UITabBar+MyTabbar.h"
#import "Add_NewFrindsViewController.h"
#import "HQXMPPManager.h"
@interface ChatMianViewController ()<UITabBarControllerDelegate>
{
    UITabBarController * _tabbar;
    ChatMessageViewController *_messageVC;
    MemberListViewController * _contactVC ;
    GroupListViewController * _dynamicVC;
    UIButton *_add_Friends;//添加好友按钮;
}
@property(nonatomic,assign)int i;

//@property (strong, nonatomic) NSDate *lastDate;


@end

@implementation ChatMianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeToolBarView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addFriendsRequest];
}
- (void)makeToolBarView{
    
    _tabbar = [[UITabBarController alloc]init];
    _tabbar.delegate = self;
    _tabbar.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:_tabbar];
    [self.view insertSubview:_tabbar.view atIndex:0];
    
    
    _messageVC = [[ChatMessageViewController alloc] init];
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:@"消息" image:[[UIImage imageNamed:@"chatMessUn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"mesSel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _messageVC.tabBarItem=item1;

   _contactVC = [[MemberListViewController alloc]init];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:@"联系人" image:[[UIImage imageNamed:@"contactList"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"chatListSel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _contactVC.tabBarItem=item2;

    _dynamicVC = [[GroupListViewController alloc]init];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:@"群聊" image:[[UIImage imageNamed:@"contactGroup"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"chatGroupSel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _dynamicVC.tabBarItem=item3;

    _tabbar.viewControllers = @[_messageVC,_contactVC,_dynamicVC];
    _tabbar.selectedIndex = 0;
    _tabbar.tabBar.tintColor = Base_Orange;
    if (_tabbar.selectedIndex == 0) {
        self.title = @"消息";
    }
    [self add_Friends];

}

-(void)addFriendsRequest
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsRequest:) name:FrindsRequest object:nil];
    //监听消息来得通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCome:) name:SendMsgName object:nil];
    //监听删除好友时发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBecomeFriends:) name:CancelAddFriends object:nil];//拒绝成为好友
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeFriends:) name:DiDBecomeFriends object:nil];
}
//拒绝添加好友  或者删除好友
-(void)cancelBecomeFriends:(NSNotification*)note
{
    NSDictionary *dic = [note object];
    
    [[FriendRequestManager shareInstance]handleRequestMessageWithDic:dic andisSuccess:NO];

}
//已经成为好友
-(void)DidBecomeFriends:(NSNotification*)note
{
    NSDictionary *dic = [note object];
   
    [[FriendRequestManager shareInstance]handleRequestMessageWithDic:dic andisSuccess:YES];
}

//消息来得时候
-(void)messageCome:(NSNotification*)note
{
    [_messageVC messageCome:note];
}
//有好友请求的时候
-(void)friendsRequest:(NSNotification*)note
{
    //收到通知....
    [_contactVC.tabBarController.tabBar showBadgeOnItemIndex:1];;
    
    [_contactVC friendsRequest:note];

}
#pragma mark 设置导航栏右侧添加好友按钮
-(void)add_Friends
{
    _add_Friends = [UIButton buttonWithType:UIButtonTypeCustom];
    _add_Friends.frame = CGRectMake(0, 0, 30, 40);
    [_add_Friends setImage:[UIImage imageNamed:@"add_Friends"] forState:UIControlStateNormal];
    [_add_Friends addTarget:self action:@selector(addNewFriendsAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.backgroundColor = [UIColor greenColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_add_Friends];
    self.navigationItem.rightBarButtonItem = leftItem;
}
#pragma mark 添加好友
-(void)addNewFriendsAction{
    Add_NewFrindsViewController *vc = [[Add_NewFrindsViewController alloc]init];
    vc.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  TabbarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (_tabbar.selectedIndex) {
        case 0:
            self.title = @"消息";
            _add_Friends.hidden = NO;
            break;
            case 1:
            self.title = @"联系人";
            _add_Friends.hidden = NO;
            break;
            case 2:
            self.title = @"群聊";
            _add_Friends.hidden = YES;
            break;
        default:
            break;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)vc {
    UIViewController *tbSelectedController = tbc.selectedViewController;
    
    if ([tbSelectedController isEqual:vc]) {
        //在这里可以捕捉到这个方法
        self.i++;
        if (self.i==2) {
            self.i=0;
            //这里做逻辑处理就行了
            if ([vc isEqual:_contactVC]) {
                [_contactVC  reloadSections];
            }
        }
        return NO;
    }
    //NSLog(@"1");
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SendMsgName object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:FrindsRequest object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DiDBecomeFriends object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CancelAddFriends object:nil];


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SendMsgName object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:FrindsRequest object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DiDBecomeFriends object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CancelAddFriends object:nil];
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
