//
//  TextFieldCell.h
//  shopFriend
//
//  Created by Beautilut on 14-2-10.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell
{
   IBOutlet UILabel*titleLabel;
   IBOutlet UITextField*textField;
}
@property(nonatomic,retain) IBOutlet UILabel*titleLabel;
@property(nonatomic,retain) IBOutlet UITextField*textField;
-(void)setTitleLabelText:(NSString*)string;
-(void)setTextFieldText:(NSString*)string;
@end
