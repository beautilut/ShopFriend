//
//  TextFieldCell.m
//  shopFriend
//
//  Created by Beautilut on 14-2-10.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell
@synthesize titleLabel;
@synthesize textField;
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
-(void)setTextFieldText:(NSString *)string
{
    [textField setText:string];
}
-(void)setTitleLabelText:(NSString *)string
{
    [titleLabel setText:string];
}
@end
