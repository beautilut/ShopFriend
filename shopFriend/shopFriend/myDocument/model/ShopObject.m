//
//  ShopObject.m
//  shopFriend
//
//  Created by Beautilut on 14-3-6.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopObject.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@implementation ShopObject
@synthesize shopID,shopName,shopActivity;

+(BOOL)saveNewShop:(ShopObject *)aShop
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ShopObject checkTableCreatedInDb:db];
    NSString*xmppString=[NSString stringWithFormat:@"%@shop",aShop.shopID];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString*insertStr=@"INSERT INTO 'SFShop' ('shopID','hostID','shopXMPP','shopName','shopFlag')VALUES(?,?,?,?,?)";
    BOOL worked=[db executeUpdate:insertStr,aShop.shopID,hostID,xmppString,aShop.shopName,[NSNumber numberWithInt:0]];
    [db close];
    return  worked;
}
+(BOOL)haveSaveShopByID:(NSString *)shopID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ShopObject checkTableCreatedInDb:db];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    FMResultSet*rs=[db executeQuery:@"SELECT COUNT(*) FROM SFShop WHERE shopID=? AND hostID=?",shopID,hostID];
    while ([rs next]) {
        int count=[rs intForColumnIndex:0];
        if  (count!=0)
        {
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
+(BOOL)haveSaveShopXmpp:(NSString*)shopID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ShopObject checkTableCreatedInDb:db];
    
    FMResultSet*rs=[db executeQuery:@"SELECT COUNT(*) FROM SFShop WHERE shopXMPP=?",shopID];
    while ([rs next]) {
        int count=[rs intForColumnIndex:0];
        if  (count!=0)
        {
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
+(int)flagShopByID:(NSString*)shopID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ShopObject checkTableCreatedInDb:db];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    FMResultSet*rs=[db executeQuery:@"SELECT COUNT(*),shopFlag FROM SFShop WHERE shopID=? AND hostID=?",shopID,hostID];
    while ([rs next]) {
    int count=[rs intForColumnIndex:0];
    if (count==0) {
        return 0;
    }else
    {
    int x=[[rs stringForColumn:@"shopFlag"] integerValue];
    [rs close];
    return x;
    }}
    return 0;
}
+(BOOL)updateShopFlag:(NSString*)shopID withFlag:(NSNumber*)number
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ShopObject checkTableCreatedInDb:db];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    BOOL worked=[db executeUpdate:@"UPDATE SFShop SET shopFlag=? WHERE shopID=? AND hostID=?",number,shopID,hostID];
    return worked;
}
+(BOOL)deleteShopByID:(NSNumber *)shopID
{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [ShopObject checkTableCreatedInDb:db];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    BOOL worked=[db executeUpdate:@"DELETE FROM SFShop WHERE shopID=? AND hostID=?",shopID,hostID];
    return worked;
}
//+(BOOL)updateShop:(ShopObject*)shop
//{
//    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
//    if (![db open]) {
//        NSLog(@"数据库打开失败");
//        return  NO;
//    }
//    [ShopObject checkTableCreatedInDb:db];
//    BOOL worked=[db executeUpdate:@"UPDATE SFShop SET "];
//    return worked;
//}
+(NSMutableArray*)fetchAllShopsFromLocal
{
    NSMutableArray*resultArr=[[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return  resultArr;
    }
    [ShopObject checkTableCreatedInDb:db];
    FMResultSet*rs=[db executeQuery:@"select * from SFShop"];
    while ([rs next]) {
        ShopObject*shop=[[ShopObject alloc] init];
        shop.shopID=[rs stringForColumn:sfSHOP_ID];
        shop.shopName=[rs stringForColumn:sfSHOP_NAME];
        [resultArr addObject:shop];
    }
    [rs close];
    return resultArr;
}
+(NSMutableArray*)fetchAllFriendShopFromLocal
{
    NSMutableArray*resultArr=[[NSMutableArray alloc] init];
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return  resultArr;
    }
    [ShopObject checkTableCreatedInDb:db];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    FMResultSet*rs=[db executeQuery:@"select * from SFShop where shopFlag >0 and hostID=?",hostID];
    while ([rs next]) {
        ShopObject*shop=[[ShopObject alloc] init];
        shop.shopID=[rs stringForColumn:sfSHOP_ID];
        shop.shopName=[rs stringForColumn:sfSHOP_NAME];
        [resultArr addObject:shop];
    }
    [rs close];
    return resultArr;
}
+(ShopObject*)shopFromDictionary:(NSDictionary *)aDic
{
    ShopObject*shop=[[ShopObject alloc] init];
    [shop setShopID:[aDic objectForKey:sfSHOP_ID]];
    [shop setShopName:[aDic objectForKey:sfSHOP_NAME]];
    return  shop;
}
-(NSDictionary*)toDictionary
{
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:shopID,sfSHOP_ID,shopName,sfSHOP_NAME,nil];
    return  dic;
}
+(BOOL)checkTableCreatedInDb:(FMDatabase*)db
{
    NSString*createStr=@"CREATE TABLE IF NOT EXISTS 'SFShop'('shopID' VARCHAR,'hostID' VARCHAR,'shopXMPP' VARCHAR,'shopName' VARCHAR,'shopFlag' INT,PRIMARY KEY ('shopID','hostID'))";
    BOOL worked=[db executeUpdate:createStr];
    return  worked;
}
@end
