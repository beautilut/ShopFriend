//
//  MessageUserUnionObject.h
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageUserUnionObject : NSObject

@property (nonatomic,retain) MessageModel * message;
@property (nonatomic,retain) UserObject* user;

+(MessageUserUnionObject *)unionWithMessage:(MessageModel *)aMessage andUser:(UserObject *)aUser;
@end
