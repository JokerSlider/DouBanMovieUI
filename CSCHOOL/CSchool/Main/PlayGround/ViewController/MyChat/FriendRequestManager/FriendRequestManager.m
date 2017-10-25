//
//  FriendRequestManager.m
//  CSchool
//
//  Created by mac on 17/4/13.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "FriendRequestManager.h"
#import "HQXMPPManager.h"
@implementation FriendRequestManager
+(id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
- (void)handleRequestMessageWithDic:(NSDictionary *)dic andisSuccess:(BOOL)isSuccess
{
    NSString *strDate=dic[@"time"];
    if (!isSuccess) {
        XMPPJID *jid=[XMPPJID jidWithString:dic[@"fromStr"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            XMPPJID *userJid =[XMPPJID jidWithString:dic[@"fromStr"]];
            NSString *body;
            NSString *userName = [[[userJid user] componentsSeparatedByString:@"_"]lastObject];
            
            XMPPUserCoreDataStorageObject * user = [[HQXMPPManager shareXMPPManager].rosterStorage userForJID:jid xmppStream:[HQXMPPManager shareXMPPManager].xmppStream managedObjectContext:[HQXMPPManager shareXMPPManager].rosterStorage.mainThreadManagedObjectContext];
            if ([user.subscription isEqualToString:@"both"]) {
                [JohnAlertManager showFailedAlert:[NSString stringWithFormat:@"%@将您从他的好友列表里删除了!",userName] andTitle:@"好友请求"];
                body=[NSString stringWithFormat:@"%@将您从他的好友列表里删除了!",userName];
            }else if([user.subscription isEqualToString:@"to"]){
                [JohnAlertManager showFailedAlert:[NSString stringWithFormat:@"%@将您从他的好友列表里删除了!",userName] andTitle:@"好友请求"];
                body=[NSString stringWithFormat:@"%@将您从他的好友列表里删除了!",userName];
            }else{
                [JohnAlertManager showFailedAlert:[NSString stringWithFormat:@"%@拒绝了您的添加好友请求!",userName] andTitle:@"好友请求"];
                //获得body里面的内容
                body=[NSString stringWithFormat:@"%@拒绝了您的添加好友请求!!",userName];
            }
#pragma 注释掉将不再接受好友请求的回执消息
            //发送一个通知
            if(body){
                NSString *user =[NSString stringWithFormat:@"%@+系统消息",userJid];
                NSDictionary *dict =@{@"uname":user,@"time":strDate,@"body":body,@"jid":jid,@"user":@"other",@"myJid":[HQXMPPManager shareXMPPManager].xmppStream.myJID,@"messageType":@"system",@"chatName":@""};
                NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:note];
                
            }

        });
        
 
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            XMPPJID *userJid =[XMPPJID jidWithString:dic[@"fromStr"]];
            NSString *userName = [[[userJid user] componentsSeparatedByString:@"_"]lastObject];
            NSString *user =[NSString stringWithFormat:@"%@+系统消息",userJid];
            NSString *body = [NSString stringWithFormat:@"你和%@已经成为好友了,快开始聊天吧!",userName];
            NSDictionary *dict =@{@"uname":user,@"time":strDate,@"body":body,@"jid":userJid,@"user":@"other",@"myJid":[HQXMPPManager shareXMPPManager].xmppStream.myJID,@"messageType":@"system",@"chatName":@""};
            NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:note];

//            [JohnAlertManager showFailedAlert:[NSString stringWithFormat:@"你和%@已经成为好友了,快开始聊天吧!",userName] andTitle:@"好友请求"];
        });

    }

}

@end
