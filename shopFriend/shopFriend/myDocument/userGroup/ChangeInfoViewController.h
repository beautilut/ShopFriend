//
//  ChangeInfoViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-2-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeInfoViewController : UIViewController<UITextFieldDelegate>
{
    UITextField*infoField;
}
@property(nonatomic,retain) UITextField*infoField;
-(IBAction)done:(id)sender;
-(void)getInfo:(NSDictionary*)dic;
@end
