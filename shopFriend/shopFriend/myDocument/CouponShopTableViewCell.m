//
//  CouponShopTableViewCell.m
//  shopFriend
//
//  Created by Beautilut on 14-5-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "CouponShopTableViewCell.h"

@implementation CouponShopTableViewCell
@synthesize shopName,shopAddress;
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
-(void)setCellInfo:(NSDictionary *)dic
{
    [shopName setText:[dic objectForKey:@"shop_name"]];
    [shopAddress setText:[dic objectForKey:@"shop_address"]];
}
@end
