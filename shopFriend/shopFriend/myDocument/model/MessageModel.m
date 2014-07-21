//
//  MessageModel.m
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "MessageModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@implementation MessageModel
@synthesize messageContent,messageDate,messageFrom,messageTo,messageType,messageId;
+(MessageModel*)messageWithType:(int)aType
{
    MessageModel*msg=[[MessageModel alloc] init];
    [msg setMessageType:[NSNumber numberWithInt:aType]];
    return msg;
}
+(MessageModel*)messageFromDication:(NSDictionary *)adic
{
    MessageModel*msg=[[MessageModel alloc] init];
    [msg setMessageFrom:[adic objectForKey:kMESSAGE_FROM]];
    [msg setMessageTo:[adic objectForKey:kMESSAGE_TO]];
    [msg setMessageContent:[adic objectForKey:kMESSAGE_CONTENT]];
    [msg setMessageDate:[adic objectForKey:kMESSAGE_DATE]];
    //[msg setMessageType:[NSNumber numberWithInt:[adic objectForKey:kMESSAGE_TYPE]]];
    return msg;
}
//讲对象转换成字典
-(NSDictionary*)toDictionary
{
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:messageId,kMESSAGE_ID,messageFrom,kMESSAGE_FROM,messageTo,kMESSAGE_TO,messageContent,kMESSAGE_CONTENT,messageDate,kMESSAGE_DATE,messageType,kMESSAGE_TYPE,nil];
    return dic;
}
//数据库操作
+(BOOL)save:(MessageModel *)aMessage
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString *createStr=[NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS 'SFMessage' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'messageFrom' VARCHAR, 'messageTo' VARCHAR, 'messageContent' VARCHAR, 'messageDate' DATETIME,'messageType' INTEGER )"];
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    
    NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO 'SFMessage' ('messageFrom','messageTo','messageContent','messageDate','messageType') VALUES (?,?,?,?,?)"];
    worked = [db executeUpdate:insertStr,aMessage.messageFrom,aMessage.messageTo,aMessage.messageContent,aMessage.messageDate,aMessage.messageType];
    FMDBQuickCheck(worked);
    
    
    
    [db close];
    //发送全局通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:aMessage ];
    //[aMessage release];
    
    
    return worked;
}
//获取某联系人的聊天记录
+(NSMutableArray*)fetchMessageListWithUser:(NSString *)userId byPage:(int)pageInde
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString *queryString=[NSString stringWithFormat:@"select * from SFMessage where messageFrom=? or messageTo=? order by messageDate"];
   
    FMResultSet *rs=[db executeQuery:queryString,userId,userId];
    while ([rs next]) {
        MessageModel*message=[[MessageModel alloc]init];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
        if ([message.messageTo isEqualToString:host]||[message.messageFrom isEqualToString:host]) {
            [messageList addObject:message];
        }
    }
    return  messageList;
}
+(BOOL)cleanMessageWithShop:(NSString*)shopID
{
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
    }
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString *queryString=[NSString stringWithFormat:@"delete from SFMessage where messageFrom=? or messageTo=?"];
    BOOL work=[db executeUpdate:queryString,shopID,shopID];
     [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:nil];
    return work;
}
//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString *queryString=@"select * from ( select * from SFMessage where messageFrom=? or messageTo=? order by messageDate asc ) as m ,SFShop as s where m.messageFrom=s.shopXMPP or m.messageTo=s.shopXMPP group by s.shopID  order by m.messageDate desc limit ?,10";
    FMResultSet *rs=[db executeQuery:queryString,host,host,[NSNumber numberWithInt:pageIndex*10]];
    while ([rs next]) {
        MessageModel*message=[[MessageModel alloc]init];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
        
        ShopObject*shop=[[ShopObject alloc] init];
        [shop setShopID:[rs objectForColumnName:sfSHOP_ID]];
        [shop setShopName:[rs objectForColumnName:sfSHOP_NAME]];
        MessageShopUnionObject*unionObject=[MessageShopUnionObject unionWithMessage:message andShop:shop];
        [messageList addObject:unionObject];
    }
    return  messageList;
}
@end
