//
//  MenuViewController.h
//  ShopFriendForShop
//
//  Created by Beautilut on 14-2-11.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString*shopID;
}
@property(nonatomic,retain)NSString*shopID;
@end
