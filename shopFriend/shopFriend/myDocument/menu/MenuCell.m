//
//  MenuCell.m
//  ShopFriendForShop
//
//  Created by Beautilut on 14-2-12.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "MenuCell.h"
#import "NSObject_URLHeader.h"
#import <CommonCrypto/CommonDigest.h>
@implementation MenuCell
@synthesize menuImage;
@synthesize menuLabel;
@synthesize priceLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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
-(void)setCellInfo:(NSDictionary *)dic with:(NSString *)key shop:(NSString *)shop
{
    [menuLabel setText:[dic objectForKey:@"good_name"]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    float floatNumber=[[dic objectForKey:@"good_price"] floatValue];
    NSString *pricestring = [formatter stringFromNumber:[NSNumber numberWithFloat:floatNumber]];
    NSString*price=[NSString stringWithFormat:@"%@",pricestring];
    [priceLabel setText:price];
    NSString*md5=[self md5:[dic objectForKey:@"good_name"]];
    NSString*string=[NSString stringWithFormat:@"%@/menu/%@/%@0.jpg",shop,key,md5];
    NSURL*url=[NSURL URLWithString:SHOP_MENU_PICK(string)];
    [menuImage setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage*image,NSError*error,SDImageCacheType cacheType){
    }];
}
-(NSString*)md5:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSString*string=[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
    return [string lowercaseString];
}
@end
