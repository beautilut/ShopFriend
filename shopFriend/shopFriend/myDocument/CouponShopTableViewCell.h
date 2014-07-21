//
//  CouponShopTableViewCell.h
//  shopFriend
//
//  Created by Beautilut on 14-5-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponShopTableViewCell : UITableViewCell
{
    IBOutlet UILabel*shopName;
    IBOutlet UILabel*shopAddress;
    UIImageView*image;
}
@property(nonatomic,retain) IBOutlet UILabel * shopName;
@property(nonatomic,retain) IBOutlet UILabel * shopAddress;
-(void)setCellInfo:(NSDictionary*)dic;
@end
