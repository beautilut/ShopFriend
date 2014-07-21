//
//  CategoryCell.h
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell
{
    IBOutlet UILabel*nameLabel;
}
@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
-(void)setName:(NSString*)name;
@end
