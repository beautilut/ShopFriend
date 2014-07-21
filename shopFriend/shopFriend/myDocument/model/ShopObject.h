//
//  ShopObject.h
//  shopFriend
//
//  Created by Beautilut on 14-3-6.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>
#define sfSHOP_ID @"shopID"
#define sfSHOP_NAME @"shopName"
@interface ShopObject : NSObject
@property (nonatomic,retain) NSString*shopID;
@property (nonatomic,retain) NSString*shopName;
@property (nonatomic,retain) NSString*shopActivity;
//数据库操作
+(BOOL)saveNewShop:(ShopObject*)aShop;
+(BOOL)deleteShopByID:(NSNumber*)shopID;
+(BOOL)updateShopFlag:(NSString*)shopID withFlag:(NSNumber*)integer;
+(BOOL)haveSaveShopByID:(NSString*)shopID;
+(BOOL)haveSaveShopXmpp:(NSString*)shopID;
+(int)flagShopByID:(NSString*)shopID;
+(NSMutableArray*)fetchAllShopsFromLocal;
+(NSMutableArray*)fetchAllFriendShopFromLocal;
//转换
-(NSDictionary*)toDictionary;
+(ShopObject*)shopFromDictionary:(NSDictionary*)aDic;
@end
