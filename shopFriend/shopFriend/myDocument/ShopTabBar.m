//
//  ShopTabBar.m
//  shopFriend
//
//  Created by Beautilut on 14-1-7.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopTabBar.h"
#import "naviTabButton.h"
#define barHeigh 50
@implementation ShopTabBar
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    
    
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withButtonID:(int)idNumber
{
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    btnArray=[[NSMutableArray alloc] init];
    self = [super initWithFrame:CGRectMake(0, screenBounds.size.height-barHeigh, screenBounds.size.width, barHeigh)];
    NSArray*array=[[NSArray alloc] initWithObjects:@"shop",@"shopFriend",@"me",nil];
    naviTabButton*btn;
    CGFloat width=320.0f/[array count];
    for (int i=0; i<[array count]; i++) {
        btn=[[naviTabButton alloc] initWithFrame:CGRectMake(width*i,0, width,barHeigh) withImage:[array objectAtIndex:i]];
        [btn setTag:i];
        //[UIButton buttonWithType:UIButtonTypeCustom];
        [btnArray addObject:btn];
        [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchDown];
        if (i==idNumber) {
            [btn buttonChangeImage:YES];
        }else
        {
            [btn buttonChangeImage:NO];
        }
        [self addSubview:btn];
    }
    [self setBackgroundColor:[UIColor whiteColor]];
    [[self layer] setShadowOffset:CGSizeMake(0,-2)];
    [[self layer] setShadowRadius:1];
    [[self layer]setShadowOpacity:0.5];
    [[self layer] setShadowColor:[UIColor grayColor].CGColor];
    return self;
}
-(void)tabBarButtonClicked:(id)sender
{
    naviTabButton*button=sender;
    if ([delegate respondsToSelector:@selector(selectViewController:)]) {
        [delegate selectViewController:button.tag];
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
