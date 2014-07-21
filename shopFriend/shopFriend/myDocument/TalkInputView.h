//
//  TalkInputView.h
//  shopFriend
//
//  Created by Beautilut on 14-1-21.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInputView.h"
@protocol TalkInputViewDelegate;
@interface TalkInputView : UIView
{
    id <TalkInputViewDelegate> delegate;
    MessageInputView*message;
    
}
@property(nonatomic,strong) id <TalkInputViewDelegate> delegate;
@property(nonatomic,retain) MessageInputView*message;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<UITextViewDelegate,MessageInputViewDelegate>)delegate;
+ (CGFloat)textViewLineHeight;
+ (CGFloat)maxLines;
+ (CGFloat)maxHeight;
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;
@end

@protocol TalkInputViewDelegate <NSObject>
-(void)imageButtonDown:(id)sender;
@end