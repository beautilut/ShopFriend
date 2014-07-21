//
//  MessageShopUnionObject.h
//  shopFriend
//
//  Created by Beautilut on 14-3-17.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageShopUnionObject : NSObject
@property(nonatomic,retain) MessageModel*message;
@property(nonatomic,retain) ShopObject*shop;

+(MessageShopUnionObject*)unionWithMessage:(MessageModel*)aMessage andShop:(ShopObject*)aShop;
@end
