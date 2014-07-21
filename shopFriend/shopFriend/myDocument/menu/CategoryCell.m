//
//  CategoryCell.m
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell
@synthesize nameLabel;
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
-(void)setName:(NSString*)name
{
    [self setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:0.15]];
    [nameLabel setText:name];
    [nameLabel setTextColor:[UIColor orangeColor]];
}
@end
