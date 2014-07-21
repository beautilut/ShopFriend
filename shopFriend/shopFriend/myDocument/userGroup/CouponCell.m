//
//  CouponCell.m
//  shopFriend
//
//  Created by Beautilut on 14-4-28.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "CouponCell.h"

@implementation CouponCell
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
-(void)setCouponCell:(CouponObject *)aCoupon
{
    [self setBackgroundColor:[UIColor clearColor]];
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20,self.frame.size.height-15)];
    [backImage setBackgroundColor:[UIColor whiteColor]];
    backImage.userInteractionEnabled=YES;
    [self addSubview:backImage];
    
    UILabel*couponContent=[[UILabel alloc] initWithFrame:CGRectMake(backImage.frame.origin.x+15, backImage.frame.origin.y+3, backImage.frame.size.width-30, backImage.frame.size.height-20)];
    [couponContent setText:aCoupon.couponInfo];
    [couponContent setFont:[UIFont systemFontOfSize:20.0f]];
    [couponContent setNumberOfLines:20.0f];
    [couponContent setTextColor:[UIColor orangeColor]];
    [self addSubview:couponContent];
    
    UILabel*lastTime=[[UILabel alloc] initWithFrame:CGRectMake(backImage.frame.origin.x, backImage.frame.origin.y+couponContent.frame.size.height, backImage.frame.size.width, backImage.frame.size.height-couponContent.frame.size.height)];
    [lastTime setFont:[UIFont systemFontOfSize:10.0f]];
    [self addSubview:lastTime];
    [lastTime setTextAlignment:NSTextAlignmentCenter];
    [lastTime setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    NSString*string=[aCoupon.couponEndTime substringToIndex:10];
    [lastTime setText:string];
}
-(UIColor *)randomColor {
    static BOOL seeded = NO;
    if(!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
@end
