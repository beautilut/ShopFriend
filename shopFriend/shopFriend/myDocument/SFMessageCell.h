//
//  SFMessageCell.h
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SFMessageCellDelegate;
//头像大小
#define HEAD_SIZE 40.f
#define TEXT_MAX_HEIGHT 500.0f
//
#define INSETS 8.0f
@interface SFMessageCell : UITableViewCell
{
    id<SFMessageCellDelegate> delegate;
    UIImageView*userhead;
    UIImageView*bubbleBg;
    UIImageView*headMask;
    UIImageView*chatImage;
    UILabel *messageConent;
}
@property(nonatomic,strong) id <SFMessageCellDelegate> delegate;
@property(nonatomic) enum bSFMessageCellStyle msgStyle;
@property(nonatomic) int height;
@property(nonatomic,retain) UIImageView*userhead;
-(void)setMessageObject:(MessageModel*)aMessage;
-(void)setHeadImage:(NSURL*)headImage tag:(int)aTag;
-(void)setChatImage:(NSURL *)chatImage tag:(int)aTag;
@end
@protocol SFMessageCellDelegate <NSObject>
-(void)showShop:(UIImage*)image;
@end