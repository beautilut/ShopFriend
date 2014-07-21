//
//  naviTabButton.m
//  shopFriend
//
//  Created by Beautilut on 14-3-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "naviTabButton.h"

@implementation naviTabButton
@synthesize noSelect,select;
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)name
{
    self = [super initWithFrame:frame];
    if (self) {
        noSelect=[NSString stringWithFormat:@"%@_select",name];
        select=[NSString stringWithFormat:@"%@_selected",name];
    }
    return self;
}
-(void)buttonChangeImage:(BOOL)yes
{
    if (yes) {
        [self setImage:[UIImage imageNamed:select] forState:UIControlStateNormal ];
    }else
    {
        [self  setImage:[UIImage imageNamed:noSelect] forState:UIControlStateNormal];
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
