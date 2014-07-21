//
//  ShopCell.m
//  shopFriend
//
//  Created by Beautilut on 14-1-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopCell.h"

@implementation ShopCell
@synthesize shopDistance;
@synthesize shopImage;
@synthesize shopName;
@synthesize shopIndustry;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"ShopCell"];
    if (self) {
        // Initialization code
    }
    
    return self;
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
-(void)setCellInfo:(NSDictionary*)dic
{
    [shopName setText:[dic objectForKey:@"shop_name"]];
    //NSDictionary*category=[dic objectForKey:@"category"];
    //int x=[[dic objectForKey:@"shopCategory"] integerValue];
    //NSString*categoryString=[category objectForKey:[[NSNumber numberWithInt:x] stringValue]];
    //NSString*string=[NSString stringWithFormat:@"%@,%@",categoryString,[dic objectForKey:@"shopCategoryDetail"]];
    if (![[dic objectForKey:@"shop_activity_info"] isEqualToString:@""]) {
        [shopIndustry setText:[dic objectForKey:@"shop_activity_info"]];
    }else{
        [shopIndustry setText:@"暂无活动。"];
    }
    
    NSString*distance=[NSString stringWithFormat:@"%@ km",[dic objectForKey:@"distance"]];
    [shopDistance setText:distance];
}
@end
