//
//  CouponObject.m
//  shopFriend
//
//  Created by Beautilut on 14-4-29.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "CouponObject.h"

#import "FMResultSet.h"
@implementation CouponObject
@synthesize couponID,couponName,couponInfo,couponBeginTime,couponEndTime,couponUseInfo,couponUsed,couponImageURL,couponPassword;
+(BOOL)saveNewCoupon:(CouponObject *)aCoupon
{
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        return NO;
    }
    [CouponObject checkTableCreateInDB:db];
    NSString*insertStr;
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    BOOL worked =NO;
    if (aCoupon.couponBeginTime==nil) {
        insertStr=@"INSERT INTO 'SFCoupon' ('Coupon_ID','CouponModel_Name','CouponModel_Info','CouponModel_EndTime','CouponModel_useInfo','Coupon_used','userID','Coupon_Password') VALUES(?,?,?,?,?,?,?,?)";
        worked=[db executeUpdate:insertStr,aCoupon.couponID,aCoupon.couponName,aCoupon.couponInfo,aCoupon.couponEndTime,aCoupon.couponUseInfo,aCoupon.couponUsed,host,aCoupon.couponPassword];
    }else{
        insertStr=@"INSERT INTO 'SFCoupon' ('Coupon_ID','CouponModel_Name','CouponModel_Info','CouponModel_BeginTime','CouponModel_EndTime','CouponModel_useInfo','Coupon_used','userID','Coupon_Password') VALUES(?,?,?,?,?,?,?,?,?)";
        worked=[db executeUpdate:insertStr,aCoupon.couponID,aCoupon.couponName,aCoupon.couponInfo,aCoupon.couponBeginTime,aCoupon.couponEndTime,aCoupon.couponUseInfo,aCoupon.couponUsed,host,aCoupon.couponPassword];
        
    }
    if (aCoupon.couponImageURL!=NULL) {
        NSString*sqlString=[NSString stringWithFormat:@"update 'SFCoupon' set CouponModel_Image='%@' where Coupon_ID='%@'",aCoupon.couponImageURL ,aCoupon.couponID];
        BOOL work=[db executeUpdate:sqlString];
    }
    [db close];
    return worked;
}
-(void)CouponSetImage:(NSString*)url withDB:(FMDatabase*)db withCouponID:(NSString*)couponID
{
    
}
+(BOOL)useCoupon:(NSString *)couponID
{
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        return NO;
    }
    [CouponObject checkTableCreateInDB:db];
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString*update=@"update 'SFCoupon' set Coupon_used=0 where userID=? and Coupon_ID=?";
    BOOL worked=[db executeUpdate:update,host,couponID];
    return worked;
}
+(NSMutableArray*)fetchAllCouponsWithUser;
{
    NSMutableArray*array=[[NSMutableArray alloc] init];
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        return nil;
    }
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString*queryString=@"select * from 'SFCoupon' where userID=?";
    FMResultSet*rs=[db executeQuery:queryString,host];
    while ([rs next]) {
        CouponObject*coupon=[[CouponObject alloc] init];
        [coupon setCouponID:[rs objectForColumnName:sfCouponID]];
        [coupon setCouponName:[rs objectForColumnName:sfCouponName]];
        [coupon setCouponInfo:[rs objectForColumnName:sfCouponInfo]];
        [coupon setCouponBeginTime:[rs objectForColumnName:sfCouponBeginTime]];
        [coupon setCouponEndTime:[rs objectForColumnName:sfCouponEndTime]];
        [coupon setCouponUseInfo:[rs objectForColumnName:sfCouponUseInfo]];
        [coupon setCouponUsed:[rs objectForColumnName:sfCouponUsed]];
        [coupon setCouponImageURL:[rs objectForColumnName:sfCouponImageURL]];
        [coupon setCouponPassword:[rs objectForColumnName:sfCouponPassword]];
        [array addObject:coupon];
    }
    return array;
}
+(NSMutableArray*)fetchUseAbleCouponsWithUser
{
    NSMutableArray*array=[[NSMutableArray alloc] init];
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        return nil;
    }
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString*queryString=@"select * from 'SFCoupon' where userID=? and Coupon_used=?";
    FMResultSet*rs=[db executeQuery:queryString,host,[NSNumber numberWithInt:1]];
    while ([rs next]) {
        CouponObject*coupon=[[CouponObject alloc] init];
        [coupon setCouponID:[rs objectForColumnName:sfCouponID]];
        [coupon setCouponName:[rs objectForColumnName:sfCouponName]];
        [coupon setCouponInfo:[rs objectForColumnName:sfCouponInfo]];
        [coupon setCouponBeginTime:[rs objectForColumnName:sfCouponBeginTime]];
        [coupon setCouponEndTime:[rs objectForColumnName:sfCouponEndTime]];
        [coupon setCouponUseInfo:[rs objectForColumnName:sfCouponUseInfo]];
        [coupon setCouponUsed:[rs objectForColumnName:sfCouponUsed]];
        [coupon setCouponImageURL:[rs objectForColumnName:sfCouponImageURL]];
        [coupon setCouponPassword:[rs objectForColumnName:sfCouponPassword]];
        [array addObject:coupon];
    }
    return array;
}
+(BOOL)couponExist:(CouponObject*)coupon
{
    NSMutableArray*array=[[NSMutableArray alloc] init];
    FMDatabase*db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        return NO;
    }
    NSString*host= [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSString*queryString=@"select COUNT(*) from 'SFCoupon' where userID=? and Coupon_ID=?";
    [CouponObject checkTableCreateInDB:db];
    FMResultSet*rs=[db executeQuery:queryString,host,coupon.couponID];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        if (count!=0){
            //[CouponObject couponUpdate:coupon];
            [rs close];
            return NO;
        }else
        {
            
            [rs close];
            return YES;
        }
    };
    [rs close];
    return YES;
    
}
+(CouponObject*)CouponFromDictionary:(NSDictionary *)aDic
{
    CouponObject*aCoupon=[[CouponObject alloc] init];
    [aCoupon setCouponID:[aDic objectForKey:sfCouponID]];
    [aCoupon setCouponName:[aDic objectForKey:sfCouponName]];
    [aCoupon setCouponInfo:[aDic objectForKey:sfCouponInfo]];
    [aCoupon setCouponBeginTime:[aDic objectForKey:sfCouponBeginTime]];
    [aCoupon setCouponEndTime:[aDic objectForKey:sfCouponEndTime]];
    [aCoupon setCouponUseInfo:[aDic objectForKey:sfCouponUseInfo]];
    [aCoupon setCouponUsed:[aDic objectForKey:sfCouponUsed]];
    [aCoupon setCouponImageURL:[aDic objectForKey:sfCouponImageURL]];
    [aCoupon setCouponPassword:[aDic objectForKey:sfCouponPassword]];
    return aCoupon;
}
-(NSDictionary*)toDictionary
{
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:couponID,sfCouponID,couponName,sfCouponName,couponInfo,sfCouponInfo,couponBeginTime,sfCouponBeginTime,couponEndTime,sfCouponEndTime,couponUseInfo,sfCouponUseInfo,couponUsed,sfCouponUsed,couponImageURL,sfCouponImageURL,couponPassword,sfCouponPassword,nil];
    return dic;
}
+(BOOL)checkTableCreateInDB:(FMDatabase*)db
{
    NSString*createStr=@"CREATE TABLE IF NOT EXISTS 'SFCoupon' ('Coupon_ID' PRIMARY KEY NOT NULL UNIQUE,'CouponModel_Name' VARCHAR,'CouponModel_Info' VARCHAR,'CouponModel_BeginTime' VARCHAR,'CouponModel_EndTime' VARCHAR,'CouponModel_useInfo' VARCHAR,'Coupon_used' INTEGER,'userID' VARCHAR,'CouponModel_Image' VARCHAR,'Coupon_Password' VARCHAR)";
    BOOL worked = [db executeUpdate:createStr];
    return worked;
}
@end
