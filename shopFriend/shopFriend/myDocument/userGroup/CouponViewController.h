//
//  CouponViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-4-28.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
-(void)getCoupon:(CouponObject*)aCoupon;
@end
