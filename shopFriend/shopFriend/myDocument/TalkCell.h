//
//  TalkCell.h
//  shopFriend
//
//  Created by Beautilut on 14-1-16.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UIImageView*talkView;
@property(nonatomic,retain) IBOutlet UILabel*data;
@property(nonatomic,retain) IBOutlet UILabel*name;
@property(nonatomic,retain) IBOutlet UILabel*content;
@end
