//
//  MessageUserUnionObject.m
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "MessageUserUnionObject.h"

@implementation MessageUserUnionObject
@synthesize message,user;


+(MessageUserUnionObject *)unionWithMessage:(MessageModel *)aMessage andUser:(UserObject *)aUser
{
    MessageUserUnionObject *unionObject=[[MessageUserUnionObject alloc]init];
    [unionObject setUser:aUser];
    [unionObject setMessage:aMessage];
    return unionObject;
}

@end
