//
//  FmdbTool.m
//  微信
//
//  Created by Think_lion on 15/6/30.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "FmdbTool.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "HomeModel.h"
#import "ChatModel.h"

static FMDatabaseQueue *_queue;

@implementation FmdbTool

+(void)initialize
{
    NSString *path= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chat.sqlite"];
    _queue=[FMDatabaseQueue databaseQueueWithPath:path];
    //创建表
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL b=[db executeUpdate:@"create table if not exists message(ID integer primary key autoincrement,head blob,uname text,detailname text,time text,badge text,jid blob,myJid  blob,msgType text)"];
        BOOL c = [db executeUpdate:@"create table if not exists friendrequest(ID integer primary key autoincrement,fromStr text,jid blob,badge text,msg text,myJid blob,time text)"];
        if(!b){
            NSLog(@"创建表失败");
        }
        if (!c) {
            NSLog(@"创建加好友表失败");
        }
    }];
    NSLog(@"%@",path);
}

//数据库添加数据
+(BOOL)addHead:(NSData *)head uname:(NSString *)uname detailName:(NSString *)detailName time:(NSString *)time badge:(NSString *)badge xmppjid:(XMPPJID *)jid withMyjid:(XMPPJID *)myJid andMsgType:(NSString *)msgtype
{
    __block  BOOL b;
    [_queue inDatabase:^(FMDatabase *db) {
        //将对象转为二进制
         NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:jid];//信息发送者的id
        NSData *toJid = [NSKeyedArchiver archivedDataWithRootObject:myJid];//本地用户的jid
        b=[db executeUpdate:@"insert into message(head,uname,detailname,time,badge,jid,myJid,msgType) values(?,?,?,?,?,?,?,?)",head,uname,detailName,time,badge,xmjid,toJid,msgtype];
    }];
    return b;
}
//判断用户是否已经存在
+(BOOL)selectUname:(NSString *)uname withMyjid:(XMPPJID *)myJid
{
    __block BOOL b=NO;
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:myJid];
        FMResultSet *result=[db executeQuery:@"select * from message where uname=? and myJid = ?",uname,xmjid];
        
        while ([result next]) {
            b=YES;
           
        }
    }];
   
    return b;
}

//更新数据
+(BOOL)updateWithName:(NSString *)uname detailName:(NSString *)detailName time:(NSString *)time badge:(NSString *)badge withMyjid:(XMPPJID *)myJid andUserJId:(XMPPJID *)userJid  andMsgTyope:(NSString *)msgType
{
    __block BOOL b;
    NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:myJid];
    NSData *userjid = [NSKeyedArchiver archivedDataWithRootObject:userJid];
    [_queue inDatabase:^(FMDatabase *db) {
        if (!time) {
            b=[db executeUpdate:@"update message set detailname=? ,badge=?,msgType = ?,jid = ? where uname=? and myJid = ?",detailName,badge,msgType,userjid,uname,xmjid];
        }else{
            b=[db executeUpdate:@"update message set detailname=?, time=? ,badge=?,msgType = ? ,jid = ? where uname=? and myJid = ?",detailName,time,badge,msgType,userjid,uname,xmjid];
        }
    }];
    
    return b;
}


/*
  NSDictionary *dict=@{@"uname":[jid user],@"time":strDate,@"body":body,@"jid":jid};
 */
//查询所有的数据  + XmppId 查询正在登陆用户的相关好友聊天数据
+(NSArray *)selectAllDatawithXmppID:(XMPPJID *)myXmppjid andMessageType:(NSString *)type
{
    __block NSMutableArray *arr=nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result;
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:myXmppjid];

        result =[db executeQuery:@"select * from message where myJid = ? order by time desc ",xmjid];
        if (type) {
            result =[db executeQuery:@"select * from message where myJid = ? and msgType = ? order by time desc ",xmjid,type];
        }
        if(result){
            //创建数组
            arr=[NSMutableArray array];
            while ([result next]) {
                
               //添加模型
                HomeModel *model=[[HomeModel alloc]init];
                model.uname=[result stringForColumn:@"uname"];
                model.body=[result stringForColumn:@"detailname"];
                model.time=[result stringForColumn:@"time"];
                model.badgeValue=[result stringForColumn:@"badge"];
                model.headerIcon=[result dataForColumn:@"head"];
                //获得XmppJid
                model.jid=[NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"jid"]];
                model.myJid = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"myJid"]];
                model.messageType = [result stringForColumn:@"msgType"];
                [arr addObject:model];
                
            }
        }
        [result close];//关闭
    }];
   
    
    return arr;
}
//清除小红点
+(void)clearRedPointwithName:(NSString *)uname withXmppID:(XMPPJID *)myXmppjid
{
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:myXmppjid];
        [db executeUpdate:@"update message set badge='' where uname=? AND myJid = ?",uname,xmjid];
    }];
}
#pragma mark 删除聊天数据的方法
+(void)deleteWithName:(NSString *)uname withXmppID:(XMPPJID *)myXmppjid
{
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *myjid=[NSKeyedArchiver archivedDataWithRootObject:myXmppjid];

        BOOL b=[db executeUpdate:@"delete  from message where uname=? AND myJid = ?",uname,myjid];
        if(!b){
            NSLog(@"删除失败");
        }
    }];
}
#pragma mark       查询正在登陆用户的相关添加好友的数据        +++++++++++++++++++++++++++++++++++添加好友++++++++++++++++++++++++++++++++++++++++
+(NSArray *)selectRequestDatawithXmppID:(XMPPJID *)xmppjid{
    
    __block NSMutableArray *arr=nil;
    
    
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:xmppjid];

        FMResultSet *result=[db executeQuery:@"select *  from friendrequest where myJid = ? order by time desc",xmjid];
        
        if(result){
            //创建数组
            arr=[NSMutableArray array];
            while ([result next]) {
                //添加模型
                ChatModel *model=[[ChatModel alloc]init];
                model.fromStr=[result stringForColumn:@"fromStr"];
                model.from  = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"jid"]];
                model.requestMsg = [result stringForColumn:@"msg"];
                model.to = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"myJid"]];
                model.badgeValue = [result stringForColumn:@"badge"];
                model.timeStr = [result stringForColumn:@"time"];
                //获得XmppJid
                [arr addObject:model];
                
            }
        }
        
    }];
    return arr;

}
//添加好友的信息存储 friendrequest 表
+(BOOL)addFriends:(NSString *)fromString  xmppJid:(XMPPJID *)jid andbadgeValue:(NSString *)badgeValue andRequestMsg:(NSString *)msg withMyXmppID:(XMPPJID *)myjid  presenceTime:(NSString *)time{
    __block  BOOL b;
    [_queue inDatabase:^(FMDatabase *db) {
        //将对象转为二进制
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:jid];
        NSData *myJid=[NSKeyedArchiver archivedDataWithRootObject:myjid];

        b=[db executeUpdate:@"insert into friendrequest(fromStr,jid,badge,msg,myJid,time) values(?,?,?,?,?,?)",fromString,xmjid,badgeValue,msg,myJid,time];
    }];
    return b;


}
//查询判断数据有没有存在
+(BOOL)selectfromString:(NSString*)selectfromString  xmppJid:(XMPPJID *)myjid {
    __block BOOL b=NO;
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *myXmjid=[NSKeyedArchiver archivedDataWithRootObject:myjid];

        FMResultSet *result=[db executeQuery:@"select * from friendrequest where fromStr=? and myJid=?",selectfromString,myXmjid];
        while ([result next]) {
            b=YES;
            
        }
    }];
    
    return b;

}
//更新添加好友的信息
+(BOOL)updateFfomString:(NSString*)fromString xmppJid:(XMPPJID *)jid andbadgeValue:(NSString *)badgeValue  andRequestMsg:(NSString *)msg withMyXmppID:(XMPPJID *)myjid  presenceTime:(NSString *)time{
    __block BOOL b;
    
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:jid];
        NSData *myXmjid=[NSKeyedArchiver archivedDataWithRootObject:myjid];

        b=[db executeUpdate:@"update friendrequest set fromStr = ?, jid = ?, badge = ?, msg = ?,time = ? where myJid = ?",fromString,xmjid,badgeValue,msg,time,myXmjid];
    }];
    
    return b;
 
}
//删除添加好友的信息
+(void)deleteFromString:(NSString*)fromStr xmppJid:(XMPPJID *)jid withMyXmppID:(XMPPJID *)myjid{
    
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:jid];
        NSData *myXmjid=[NSKeyedArchiver archivedDataWithRootObject:myjid];

        BOOL b=[db executeUpdate:@"delete  from friendrequest where fromStr=? AND jid = ? AND myJid = ?",fromStr,xmjid,myXmjid];
        if(!b){
            NSLog(@"删除失败");
        }
    }];
}
//清除小红点
+(void)clearRedPointwithFromString:(XMPPJID *)jid withMyXmppID:(XMPPJID *)myjid withbadgeValue:(NSString *)badgeValue
{
    [_queue inDatabase:^(FMDatabase *db) {
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:jid];
        NSData *myXmjid=[NSKeyedArchiver archivedDataWithRootObject:myjid];
        [db executeUpdate:@"update friendrequest set badge=? where jid = ? and myJid = ?",badgeValue,xmjid,myXmjid];
    }];
}
@end
