//
//  ShopFriendCell.h
//  shopFriend
//
//  Created by Beautilut on 14-3-26.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopFriendCell : UITableViewCell
{
    IBOutlet UILabel*nameLabel;
    IBOutlet UILabel*talkLabel;
    IBOutlet UIImageView*shopImage;
}
@property(nonatomic,retain) IBOutlet UILabel*nameLabel;
@property(nonatomic,retain) IBOutlet UILabel*talkLabel;
@property(nonatomic,retain) IBOutlet UIImageView*shopImage;
-(void)setCellInfo:(ShopObject*)ashop;
-(void)setCellShopImage:(UIImage*)image;
-(void)getStatus:(NSString*)shopID;
@end
