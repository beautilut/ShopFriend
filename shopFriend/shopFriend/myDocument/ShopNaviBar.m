//
//  ShopNaviBar.m
//  shopFriend
//
//  Created by Beautilut on 14-1-7.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopNaviBar.h"
#define titleHeigh 64
@implementation ShopNaviBar

- (id)initWithFrame:(CGRect)frame
{
    

    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    self = [super initWithFrame:CGRectMake(0,0,screenBounds.size.width,titleHeigh)];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setAlpha:1.0f];
    //UIImageView*backImage=[[UIImageView alloc] initWithFrame:self.frame];
    //[backImage setImage:[UIImage imageNamed:@"navi.png"]];
    //[self addSubview:backImage];
    if (self) {
        
    }
    return self;
}
-(void)openNaviShadow:(BOOL)ok
{
    if (ok==YES) {
        [[self layer] setShadowOffset:CGSizeMake(0,1)];
        [[self layer] setShadowRadius:3];
        [[self layer]setShadowOpacity:0.5];
        [[self layer] setShadowColor:[UIColor blackColor].CGColor];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
