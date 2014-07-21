//
//  ShopFriendCell.m
//  shopFriend
//
//  Created by Beautilut on 14-3-26.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopFriendCell.h"

@implementation ShopFriendCell
@synthesize talkLabel;
@synthesize shopImage;
@synthesize nameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellShopImage:(UIImage*)image
{
    [shopImage setImage:image];
}
-(void)setCellInfo:(ShopObject*)ashop
{
    [nameLabel setText:ashop.shopName];
    if ([ashop.shopActivity isEqualToString:@""]) {
        [talkLabel setText:@"本店暂无活动"];
    }else
    {
    [talkLabel setText:ashop.shopActivity];
    }
}
@end
