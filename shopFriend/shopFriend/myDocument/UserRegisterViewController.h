//
//  UserRegisterViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-2-10.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "VPImageCropperViewController.h"
@interface UserRegisterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate>
{
    
}
-(void)getPhoneInfo:(NSDictionary*)info;
@end
