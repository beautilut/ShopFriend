//
//  SFMessageCell.m
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SFMessageCell.h"
#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation SFMessageCell
@synthesize userhead,delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        userhead=[[UIImageView alloc] initWithFrame:CGRectZero];
        bubbleBg=[[UIImageView alloc] initWithFrame:CGRectZero];
        messageConent=[[UILabel alloc] initWithFrame:CGRectZero];
        headMask=[[UIImageView alloc] initWithFrame:CGRectZero];
        chatImage=[[UIImageView alloc] initWithFrame:CGRectZero];
        [messageConent setBackgroundColor:[UIColor clearColor]];
        [messageConent setFont:[UIFont systemFontOfSize:15.0f]];
        [messageConent setNumberOfLines:20];
        [self.contentView addSubview:bubbleBg];
        [self.contentView addSubview:userhead];
        [self.contentView addSubview:headMask];
        [self.contentView addSubview:messageConent];
        [self.contentView addSubview:chatImage];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //headMask
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    NSString *orgin=messageConent.text;
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIButton*infoButton=[[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:infoButton];
    switch (_msgStyle) {
        case bSFMessageCellStyleMe:
        {
            [chatImage setHidden:YES];
            [messageConent setHidden:NO];
            [messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [userhead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            userhead.layer.borderWidth=2;
            userhead.layer.borderColor=[UIColor whiteColor].CGColor;
            userhead.layer.cornerRadius=CGRectGetHeight(userhead.bounds)/2;
            userhead.clipsToBounds=YES;
            [bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            bubbleBg.frame=CGRectMake(messageConent.frame.origin.x-15, messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
        }
            break;
        case bSFMessageCellStyleOther:
        {
            [chatImage setHidden:YES];
            [messageConent setHidden:NO];
            [userhead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            userhead.layer.borderWidth=2;
            userhead.layer.borderColor=[UIColor whiteColor].CGColor;
            [messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            bubbleBg.frame=CGRectMake(messageConent.frame.origin.x-15, messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
            [infoButton addTarget:self action:@selector(showShop:) forControlEvents:UIControlEventTouchDown];
        }
            break;
        case bSFMessageCellStyleMeWithImage:
        {
            //[_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [chatImage setHidden:NO];
            [messageConent setHidden:YES];
            [chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100)];
            [userhead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            userhead.layer.borderWidth=2;
            userhead.layer.borderColor=[UIColor whiteColor].CGColor;
            userhead.layer.cornerRadius=CGRectGetHeight(userhead.bounds)/2;
            userhead.clipsToBounds=YES;
            [bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            bubbleBg.frame=CGRectMake(chatImage.frame.origin.x-15, chatImage.frame.origin.y-12, 100+30, 100+30);
        }
            break;
        case bSFMessageCellStyleOtherWithImage:
        {
            [chatImage setHidden:NO];
            [messageConent setHidden:YES];
            [chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2,100,100)];
            [userhead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            userhead.layer.borderWidth=2;
            userhead.layer.borderColor=[UIColor whiteColor].CGColor;
            [bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            bubbleBg.frame=CGRectMake(chatImage.frame.origin.x-15, chatImage.frame.origin.y-12, 100+30, 100+30);
            [infoButton addTarget:self action:@selector(showShop:) forControlEvents:UIControlEventTouchDown];
        }
            break;
        default:
            break;
    }
    [infoButton setFrame:userhead.frame];
    //headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMessageObject:(MessageModel*)aMessage
{
    [messageConent setText:aMessage.messageContent];
    
}
-(void)setHeadImage:(NSURL*)headImage tag:(int)aTag
{
    //[userhead setTag:aTag];
    [userhead setImageWithURL:headImage placeholderImage:Nil];
    //[userhead setWebImage:headImage placeHolder:Nil downloadFlag:aTag];
}
-(void)setChatImage:(NSURL *)chatImageURL tag:(int)aTag
{
    //[chatImage setTag:aTag];
    [chatImage setImageWithURL:chatImageURL placeholderImage:Nil];
    //[_chatImage setWebImage:chatImage placeHolder:Nil downloadFlag:aTag];
}
-(void)showShop:(UIImage*)image
{
    if([delegate respondsToSelector:@selector(showShop:)])
    {
        [delegate showShop:userhead.image];
    }
}
@end
