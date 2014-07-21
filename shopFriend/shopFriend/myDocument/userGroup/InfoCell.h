//
//  InfoCell.h
//  shopFriend
//
//  Created by Beautilut on 14-2-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell
{
    IBOutlet UILabel*titleCell;
    IBOutlet UILabel*detailCell;
}
@property(nonatomic,retain) IBOutlet UILabel *titleCell;
@property(nonatomic,retain) IBOutlet UILabel *detailCell;
@end
