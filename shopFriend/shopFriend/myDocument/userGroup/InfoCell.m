//
//  InfoCell.m
//  shopFriend
//
//  Created by Beautilut on 14-2-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell
@synthesize titleCell;
@synthesize detailCell;
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

@end
