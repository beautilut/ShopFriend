//
//  ShopTabView.m
//  shopFriend
//
//  Created by Beautilut on 14-3-1.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopTabView.h"

@implementation ShopTabView
@synthesize shopLogoButton;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:0.3]];
        shopLogoButton=[[UIButton alloc] initWithFrame:CGRectMake(20, -50, 80, 80)];
        [shopLogoButton addTarget:self action:@selector(logoMethod:) forControlEvents:UIControlEventTouchDown];
        shopLogoButton.layer.borderWidth=2;
        shopLogoButton.layer.borderColor=[UIColor whiteColor].CGColor;
        [self addSubview:shopLogoButton];
        UIButton*menuButton=[[UIButton alloc] initWithFrame:CGRectMake(110, 5, 80, 40)];
        [menuButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuMethod:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:menuButton];
        UIButton*talkButton=[[UIButton alloc] initWithFrame:CGRectMake(210,5,80, 40)];
        [talkButton setImage:[UIImage imageNamed:@"talk"] forState:UIControlStateNormal];
        [talkButton addTarget:self action:@selector(talkMethod:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:talkButton];
        [[self layer] setShadowOffset:CGSizeMake(0,1)];
        [[self layer] setShadowRadius:1];
        [[self layer]setShadowOpacity:0.5];
        [[self layer] setShadowColor:[UIColor whiteColor].CGColor];
    }
    return self;
}
#pragma mark - button Methods
-(void)logoMethod:(id)sender
{
    if ([delegate respondsToSelector:@selector(shopInfoShow:)]) {
        [delegate shopInfoShow:nil];
    }
}
-(void)menuMethod:(id)sender
{
    if ([delegate respondsToSelector:@selector(shopMenuShow:)]) {
        [delegate shopMenuShow:nil];
    }
}
-(void)talkMethod:(id)sender
{
    if ([delegate respondsToSelector:@selector(shopTalkShow:)]) {
        [delegate shopTalkShow:nil];
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
