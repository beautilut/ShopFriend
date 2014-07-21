//
//  HostModel.m
//  shopFriend
//
//  Created by Beautilut on 14-3-11.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "HostModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@implementation HostModel
@synthesize hostID,hostName,hostMail,hostBirthday,hostPhone,hostSex;

+(BOOL)saveNewHost:(HostModel *)aHost
{
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [HostModel checkTableCreateInDb:db];
    NSString*insertStr=@"INSERT INTO 'SFHost' ('hostID','hostName','hostMail','hostPhone','hostSex','hostBirthday') VALUES(?,?,?,?,?,?)";
    BOOL worked=[db executeUpdate:insertStr,aHost.hostID,aHost.hostName,aHost.hostMail,aHost.hostPhone,aHost.hostSex,aHost.hostBirthday];
    [db close];
    return worked;
}

+(BOOL)haveSaveHostByID:(NSString *)hostID
{
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [HostModel checkTableCreateInDb:db];
    FMResultSet*rs=[db executeQuery:@"SELECT COUNT(*) FROM 'SFHost' WHERE hostID=?",hostID];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
}
+(BOOL)deleteHostByID:(NSNumber *)hostID
{
    return NO;
}
+(BOOL)updateHost:(NSString*)column with:(id)data
{
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [HostModel checkTableCreateInDb:db];
    NSString*string=[NSString stringWithFormat:@"UPDATE SFHost SET %@ = ? WHERE hostID=?",column];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    BOOL worked=[db executeUpdate:string,data,hostID];
    return worked;
}
+(HostModel*)fetchHostInfo
{
    HostModel*host=[[HostModel alloc] init];
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [HostModel checkTableCreateInDb:db];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    FMResultSet*rs=[db executeQuery:@"SELECT * FROM SFHost WHERE hostID=?",hostID];
    while ([rs next]) {
        [host setHostID:[rs objectForColumnName:sfhostID]];
        [host setHostName:[rs objectForColumnName:sfhostName]];
        [host setHostMail:[rs objectForColumnName:sfhostMail]];
        [host setHostPhone:[rs objectForColumnName:sfhostPhone]];
        [host setHostSex:[rs objectForColumnName:sfhostSex]];
        [host setHostBirthday:[rs objectForColumnName:sfhostBirthday]];
    }
    return host;
}
+(HostModel*)hostFromDictionary:(NSDictionary *)aDic
{
    HostModel*host=[[HostModel alloc] init];
    [host setHostID:[aDic objectForKey:sfhostID]];
    [host setHostName:[aDic objectForKey:sfhostName]];
    [host setHostMail:[aDic objectForKey:sfhostMail]];
    [host setHostSex:[aDic objectForKey:sfhostSex]];
    [host setHostBirthday:[aDic objectForKey:sfhostBirthday]];
    [host setHostPhone:[aDic objectForKey:sfhostPhone]];
    return host;
}
-(NSDictionary*)toDictionary
{
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:hostID,sfhostID,hostName,sfhostName,hostMail,sfhostMail,hostPhone,sfhostPhone,hostBirthday,sfhostBirthday,hostSex,sfhostSex, nil];
    return dic;
}
+(BOOL)checkTableCreateInDb:(FMDatabase*)db
{
    NSString *createStr=@"CREATE TABLE IF NOT EXISTS 'SFHost' ('hostID' VARCHAR PRIMARY KEY NOT NULL UNIQUE,'hostName' VARCHAR,'hostMail' VARCHAR,'hostPhone' VARCHAR,'hostSex' VARCHAR,'hostBirthday' DATETIME)";
    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
}
@end
