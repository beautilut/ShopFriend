//
//  SFTalkViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-2-25.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMessageCell.h"
#import "TalkInputView.h"
#import "MessageInputView.h"
@interface SFTalkViewController : UIViewController<UITextViewDelegate,TalkInputViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,SFMessageCellDelegate,MessageInputViewDelegate>
{
    TalkInputView*inputView;
    float previousTextViewContentHeight;
}
@property(nonatomic,retain) ShopObject*chatShop;
@property(assign,nonatomic) float  previousTextViewContentHeight;
@end
