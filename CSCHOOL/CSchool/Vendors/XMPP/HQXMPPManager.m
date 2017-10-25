//
//  HQXMPPManager.m
//  XmppDemo
//
//  Created by ttlgz-0022 on 15/11/29.
//  Copyright © 2015年 Transaction Technologies Limited. All rights reserved.
//

#import "HQXMPPManager.h"
#import "XMPPvCardTemp.h"
#import "HQXMPPChatRoomManager.h"
#import "EncryptObject.h"
@implementation HQXMPPManager
static HQXMPPManager * manager;

+(HQXMPPManager *)shareXMPPManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[HQXMPPManager alloc] init];
    });
    return manager;
}

#pragma mark common method
- (void)xmppUserLoginWithResult:(XMPPResultBlock)resultBlock{
    _resultBlock = resultBlock;
    self.registerOperation = NO;
    [_xmppStream disconnect];
    [self connectToHost];
    [self getOfflineMsg];
}

- (void)xmppUserlogoutWithResult:(XMPPResultBlock)resultBlock{
    _resultBlock = resultBlock;
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];                                              // " 发送 "离线" 消息"
    [_xmppStream disconnect];                                                       //  与服务器断开连接
    [HQXMPPUserInfo shareXMPPUserInfo].loginStatus = NO;                            //  更新用户的登录状态
}
#pragma mark 获取离线消息
-(void)getOfflineMsg{
    NSString *jid = [NSString stringWithFormat:@"%@",[HQXMPPUserInfo shareXMPPUserInfo].user];
    XMPPIQ *iq = [[XMPPIQ alloc] initWithXMLString:[NSString stringWithFormat:@"<presence from='%@'><priority>1</priority></presence>",jid]error:nil];
    [_xmppStream sendElement:iq];
}
- (void)xmppUserRegisterWithResutl:(XMPPResultBlock)resultBlock{
    _resultBlock = resultBlock;
    self.registerOperation = YES;
    [_xmppStream disconnect];
    [self connectToHost];                                                           // 连接主机 成功后发送注册密码
}

#pragma mark private method
-(void)connectToHost{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = [HQXMPPUserInfo shareXMPPUserInfo].registerUser;
    }else{
        user = [HQXMPPUserInfo shareXMPPUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:kDOMAIN resource:@"iphone" ];
    
    [HQXMPPUserInfo shareXMPPUserInfo].user=user;
    
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名
    _xmppStream.hostName = kHOSTNAME;                                   //不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = KPort;
    
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        NSLog(@"%@",err);
    }
    
}

-(void)sendPwdToHost{
    NSLog(@"再发送密码授权");
    NSError *err = nil;
    NSString *pwd = [HQXMPPUserInfo shareXMPPUserInfo].pwd;
    [_xmppStream authenticateWithPassword:pwd error:&err];
    if (err) {
        NSLog(@"%@",err);
    }
}

-(void)sendOnlineToHost{
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    //#warning 每一个模块添加后都要激活
    
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    // 添加花名册模块【获取好友列表】
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    [_roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 添加聊天模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _msgArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving activate:_xmppStream];
    [_msgArchiving setClientSideMessageArchivingOnly:YES];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    [_vCard addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    [_avatar addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    
    _xmppStream.enableBackgroundingOnSocket = YES;
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}


-(void)teardownXmpp{
    // 移除代理
    [_xmppStream removeDelegate:self];
    // 停止模块
    [_reconnect deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    // 清空资源
    _reconnect = nil;
    _roster = nil;
    _rosterStorage = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
    _xmppStream = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    
}

#pragma mark -XMPPStream delegate

//与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {                                                     //注册操作，发送注册的密码
        NSString *pwd = [HQXMPPUserInfo shareXMPPUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{                                                                              //登录操
        [self sendPwdToHost];                                                           // 主机连接成功后，发送密码进行授权
    }
    
}

//与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    [self teardownXmpp];
    if(error && _resultBlock){
        _resultBlock(XMPPResultTypeNetErr);
    }else if (error == nil && _resultBlock){
        _resultBlock(XMPPResultTypeLogoutSuccess);
    }

    // 弹窗 发送注销通知
    if (error.code == 7) {
        // 弹窗 发送注销通知
        dispatch_async(dispatch_get_main_queue(), ^{
            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"您的账号在其他地方登录!如非本人操作，请及时修改密码！" WithCancelButtonTitle:@"确定" withOtherButton:nil];
            alert.delegate = self;
            alert.isBackClick = YES;
            [alert show];
        });
    }else{
        if (error) {
//            XGAlertView *alert = [[XGAlertView alloc]initWithTarget:self withTitle:@"提示" withContent:@"与服务器断开连接！请重新登录" WithCancelButtonTitle:@"确定" withOtherButton:nil];
//            alert.delegate = self;
//            alert.isBackClick = YES;
//            [alert show];
        }
    }

    //重新登录
//   [self loadAgaing];
    
}
-(void)loadAgaing
{
    [HQXMPPUserInfo shareXMPPUserInfo].user =[NSString stringWithFormat:@"%@_%@",[AppUserIndex GetInstance].schoolCode,stuNum];
    [HQXMPPUserInfo shareXMPPUserInfo].pwd = [EncryptObject md532BitUpper:[EncryptObject md532BitUpper:[NSString stringWithFormat:@"%@@toplion",stuNum]]];
    [[NSUserDefaults standardUserDefaults] setObject:[HQXMPPUserInfo shareXMPPUserInfo].user forKey:@"xmppuserName"];
    
    WEAKSELF;
    [[HQXMPPManager shareXMPPManager] xmppUserLoginWithResult:^(XMPPResultType type) {
        [weakSelf handleResultType:type];
    }];
}
//xmpp登录后信息回掉
-(void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{                                //  线程刷新UI
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                //这里要获取到用户所有加入的群组列表，并且加入到每个群组中
                [[HQXMPPChatRoomManager shareChatRoomManager] setup];
                [[HQXMPPChatRoomManager shareChatRoomManager] queryRooms];
                
                [HQXMPPChatRoomManager shareChatRoomManager].updateData = ^(id sender){
                    for (XMPPElement *obj in [HQXMPPChatRoomManager shareChatRoomManager].roomList) {
                        NSString *jidString = obj.attributesAsDictionary[@"jid"];
                        
                        [[HQXMPPChatRoomManager shareChatRoomManager] joinInChatRoom:jidString withPassword:nil];
                        
                    }
                };
                
                [[HQXMPPManager shareXMPPManager].roster setAutoAcceptKnownPresenceSubscriptionRequests:NO];//自动同意好友请求
                break;
            case XMPPResultTypeLoginFailure:
                NSLog(@"登录失败");
                NSLog(@"The Name or password wrong");
                break;
            case XMPPResultTypeNetErr:
                NSLog(@"Network is not available");
            default:
                break;
        }
    });
    
}

//点击弹窗
- (void)alertView:(XGAlertView *)view didClickNormal:(NSString *)title
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationLogout object:nil];
}
//授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"授权成功");
    //[self getOfflineMsg];
    [self sendOnlineToHost];                                                    //登陆成功发送在线消息
    [HQXMPPUserInfo shareXMPPUserInfo].loginStatus = YES;
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);                               //执行登陆成功的操作
    }
    
}


//授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"授权失败 %@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);                               //执行登陆失败的操作
    }
}

//注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    [HQXMPPUserInfo shareXMPPUserInfo].loginStatus = YES;
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);                            //执行注册成功的操作
    }
    
}

//注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterFailure);                            //执行注册失败的操作
    }
    
}

//iQ
-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return YES;
}

//接收到好友消息
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    XMPPJID *jid = message.from;
    NSString *str = jid.resource;
    
    [[NSUserDefaults standardUserDefaults] setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"terminateTime"];

    NSLog(@"++++++++++xmppstream didreceivemessage+++++++++++++++++%@",message);
    if([message isMessageWithBody]){
        if ([message.type isEqualToString:@"groupchat"]) {
            //如果是当前用户发送的群消息不做提醒处理 也不发送通知
            NSString *jidStr = message.fromStr;
            NSArray *sepJidStr = [jidStr componentsSeparatedByString:@"/"];
            if ([[sepJidStr lastObject] isEqualToString:[HQXMPPManager shareXMPPManager].xmppStream.myJID.user]) {
                return;
            }
        }
        NSDate *date=[self getDelayStampTime:message];
        //如果不是消息的话
        if(date==nil){
            date=[NSDate date];
        }
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate=[formatter stringFromDate:date];
        XMPPJID *jid=[message from];
        XMPPvCardTemp *friendvCard =[[HQXMPPManager shareXMPPManager].vCard vCardTempForJID:jid shouldFetch:YES];
        NSString *userName = friendvCard.nickname.length!=0?friendvCard.nickname:[[[[[jid user]componentsSeparatedByString:@"@"]firstObject]componentsSeparatedByString:@"_"]lastObject ];
        if ([message.type isEqualToString:@"groupchat"]) {
            NSArray *roomArray =  [HQXMPPChatRoomManager shareChatRoomManager].roomList;
            for ( XMPPElement *element in roomArray) {
                NSString *jidString =element.attributesAsDictionary[@"jid"];
                XMPPJID *roomJid = [XMPPJID jidWithString:jidString];
                if ([roomJid.user isEqualToString:jid.user]) {
                    userName =[NSString stringWithFormat:@"%@",element.attributesAsDictionary[@"name"]];
                }
            }

        }

        //获得body里面的内容
        NSString *body=[[message elementForName:@"body"] stringValue];
        NSString *msgBody = [NSString stringWithFormat:@"%@:%@",userName,body];
        //本地通知
//        UILocalNotification *local=[[UILocalNotification alloc]init];
//        local.alertBody=msgBody;
//        local.alertAction=msgBody;
//        //声音
//        local.soundName = UILocalNotificationDefaultSoundName;
//        //时区  根据用户手机的位置来显示不同的时区
//        local.timeZone=[NSTimeZone defaultTimeZone];
//        //开启通知
//        [[UIApplication sharedApplication] presentLocalNotificationNow:local];
//        //角标数量
//        [UIApplication sharedApplication].applicationIconBadgeNumber ++;
        NSString *chatRoomName = message.subject?message.subject:@"";
        //发送一个通知
        if(body){
            NSString *user = [jid user]?[jid user]:@"系统消息";
            NSDictionary *dict =@{@"uname":user,@"time":strDate,@"body":body,@"jid":jid,@"user":@"other",@"myJid":[HQXMPPManager shareXMPPManager].xmppStream.myJID,@"messageType":message.type?message.type:@"system",@"chatName":chatRoomName};

            NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:note];
        }
    }
}

//send message Fail
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    NSLog(@"%@",error);
    //    发送图片或者消息失败
}

//receive presence
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSLog(@"didReceivePresence");
    NSLog(@"%@",presence);
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate=[formatter stringFromDate:date];

    //拒绝成为好友
    if ([presence.type isEqual:@"unsubscribed"]) {
        [_roster removeUser:presence.from];
        NSString *userName = [[[[presence from]user] componentsSeparatedByString:@"_"]lastObject];
        NSString *newMsg = [NSString stringWithFormat:@"%@拒绝您的好友请求",userName];

        NSDictionary *dict=@{@"from":presence.from,@"fromStr":presence.fromStr,@"message":newMsg,@"to":presence.to,@"toStr":presence.toStr,@"time":strDate};
        NSNotification *note=[[NSNotification alloc]initWithName:CancelAddFriends object:dict userInfo:nil];

        //本地通知
        [[NSNotificationCenter defaultCenter] postNotification:note];
        NSLog(@"%@",newMsg);
        UILocalNotification *local=[[UILocalNotification alloc]init];
        local.alertBody=newMsg;
        local.alertAction=newMsg;
        //声音
        local.soundName = UILocalNotificationDefaultSoundName;
        local.timeZone=[NSTimeZone defaultTimeZone];
        //开启通知
        [[UIApplication sharedApplication] presentLocalNotificationNow:local];

    }
    //已经添加
    else if([presence.type isEqual:@"subscribed"]){
        //取得好友状态
        NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
        //请求的用户
        NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
        NSLog(@"presenceType:%@",presenceType);
        
        NSLog(@"presence2:%@  sender2:%@",presence,sender);
        
        XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
        [_roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];

        NSString *newMsg = [NSString stringWithFormat:@"%@已经成为您的好友了,快开始聊天吧!",[[presence from]user]];
        NSDictionary *dict=@{@"from":presence.from,@"fromStr":presence.fromStr,@"message":newMsg,@"to":presence.to,@"toStr":presence.toStr,@"time":strDate};
        NSNotification *note=[[NSNotification alloc]initWithName:DiDBecomeFriends object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        NSLog(@"%@",newMsg);

    }
    if ([[presence type] isEqualToString:@"subscribe"])
    {// Presence subscription request from someone who's NOT in our roster
        
        [self xmppRoster:_roster didReceivePresenceSubscriptionRequest:presence];
    }
}

#pragma mark XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    [UIApplication sharedApplication].applicationIconBadgeNumber ++;
    NSLog(@"didReceivePresenceSubscriptionRequest:%@",presence);
    //receive remove friend message
    if([presence.type isEqual:@"subscribe"]){
        DDXMLDocument *requestMsg = [presence children].count!=0?[presence children][0]:nil;
        NSString *newMsg =[requestMsg stringValue].length!=0?[requestMsg stringValue]:@"0";
        NSString *userName = [[[[presence from]user] componentsSeparatedByString:@"_"]lastObject];
        NSString *msg = [NSString stringWithFormat:@"%@请求添加您为好友",userName];    //本地通知
        UILocalNotification *local=[[UILocalNotification alloc]init];
        local.alertBody=msg;
        local.alertAction=msg;
        //声音
        local.soundName = UILocalNotificationDefaultSoundName;
        local.timeZone=[NSTimeZone defaultTimeZone];
        //开启通知
        [[UIApplication sharedApplication] presentLocalNotificationNow:local];
        XMPPMessage *message = [[XMPPMessage alloc]initWithType:[presence type] to:[presence from]];
        NSDate *date=[self getDelayStampTime:message];
        if (date==nil) {
            date = [NSDate date];
        }
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate=[formatter stringFromDate:date];
        //发送通知
        NSDictionary *dict=@{@"from":presence.from,@"fromStr":presence.fromStr,@"message":newMsg,@"to":[HQXMPPManager shareXMPPManager].xmppStream.myJID,@"toStr":presence.toStr,@"time":strDate};
        NSNotification *note=[[NSNotification alloc]initWithName:FrindsRequest object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
    }

}

- (void)dealloc{
    [self teardownXmpp];
}
#pragma mark 获得离线消息的时间

-(NSDate *)getDelayStampTime:(XMPPMessage *)message{
    //获得xml中德delay元素
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){  //如果有这个值 表示是一个离线消息
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //创建日期格式构造器
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //按照T 把字符串分割成数组
        NSArray *arr=[timeString componentsSeparatedByString:@"T"];
        //获得日期字符串
        NSString *dateStr=[arr objectAtIndex:0];
        //获得时间字符串
        NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象的时区是0
        NSDate *localDate=[formatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
        return localDate;
    }else{
        return nil;
    }
    
}

@end
