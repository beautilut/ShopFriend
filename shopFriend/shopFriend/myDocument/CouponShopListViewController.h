//
//  CouponShopListViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-5-4.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponShopListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}
-(void)getShopList:(NSMutableArray*)array;
@end
