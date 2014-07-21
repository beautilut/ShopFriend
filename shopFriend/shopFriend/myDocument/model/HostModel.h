//
//  HostModel.h
//  shopFriend
//
//  Created by Beautilut on 14-3-11.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>
#define sfhostID @"hostID"
#define sfhostName @"hostName"
#define sfhostMail @"hostMail"
#define sfhostPhone @"hostPhone"
#define sfhostSex @"hostSex"
#define sfhostBirthday @"hostBirthday"

@interface HostModel : NSObject
@property(nonatomic,retain) NSString* hostID;
@property(nonatomic,retain) NSString* hostName;
@property(nonatomic,retain) NSString* hostMail;
@property(nonatomic,retain) NSString* hostPhone;
@property(nonatomic,retain) NSNumber* hostSex;
@property(nonatomic,retain) NSDate * hostBirthday;

//数据库增删改查
+(BOOL)saveNewHost:(HostModel*)aHost;
+(BOOL)deleteHostByID:(NSNumber*)hostID;
+(BOOL)updateHost:(NSString*)column with:(id)data;
+(BOOL)haveSaveHostByID:(NSString*)hostID;

+(HostModel*)fetchHostInfo;

//将对象转换成字典
-(NSDictionary*)toDictionary;
+(HostModel*)hostFromDictionary:(NSDictionary*)aDic;
@end
