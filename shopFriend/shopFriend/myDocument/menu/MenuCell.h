//
//  MenuCell.h
//  ShopFriendForShop
//
//  Created by Beautilut on 14-2-12.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface MenuCell : UITableViewCell
{
   IBOutlet UIImageView*menuImage;
   IBOutlet UILabel*menuLabel;
    IBOutlet UILabel*priceLabel;
}
@property(nonatomic,retain)IBOutlet UIImageView*menuImage;
@property(nonatomic,retain)IBOutlet UILabel*menuLabel;
@property(nonatomic,retain)IBOutlet UILabel*priceLabel;
-(void)setCellInfo:(NSDictionary*)dic with:(NSString*)key shop:(NSString*)shop;
@end
