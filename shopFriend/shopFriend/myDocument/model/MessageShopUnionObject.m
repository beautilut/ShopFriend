//
//  MessageShopUnionObject.m
//  shopFriend
//
//  Created by Beautilut on 14-3-17.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "MessageShopUnionObject.h"

@implementation MessageShopUnionObject
@synthesize message,shop;
+(MessageShopUnionObject*)unionWithMessage:(MessageModel *)aMessage andShop:(ShopObject *)aShop
{
    MessageShopUnionObject*unionObject=[[MessageShopUnionObject alloc] init];
    [unionObject setShop:aShop];
    [unionObject setMessage:aMessage];
    return unionObject;
}
@end
