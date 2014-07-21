//
//  TalkInputView.m
//  shopFriend
//
//  Created by Beautilut on 14-1-21.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "TalkInputView.h"

@implementation TalkInputView
@synthesize delegate;
@synthesize message;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<UITextViewDelegate,MessageInputViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    [self setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:223.0/255.0 blue:226.0/255.0 alpha:1.0f]];
   
    message=[[MessageInputView alloc] initWithFrame:CGRectMake(1, 2,frame.size.width-50, 36)];
    [message setDelegate:delegate];
    [message setBackgroundColor:[UIColor whiteColor]];
    message.layer.borderWidth=2;
    message.layer.borderColor=[UIColor grayColor].CGColor;
    [self addSubview:message];
    
    UIButton*imageButton=[[UIButton alloc] initWithFrame:CGRectMake(screenBounds.size.width-40,5, 30, 30)];
    [imageButton addTarget:self action:@selector(SelfsendButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [imageButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [self addSubview:imageButton];
//    sendButton=[[UIButton alloc] initWithFrame:CGRectMake(inputTextView.frame.size.width, 1, 50, 33)];
//    [sendButton addTarget:self action:@selector(SelfsendButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
//    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    [self addSubview:sendButton];
    return self;
}
#pragma mark -delegate
-(void)SelfsendButtonTouchDown:(id)sender
{
    if ([delegate respondsToSelector:@selector(imageButtonDown:)]) {
        [delegate imageButtonDown:nil];
    }
}

#pragma mark -
+ (CGFloat)textViewLineHeight
{
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 2.5f;
}

+ (CGFloat)maxHeight
{
    return ([TalkInputView maxLines] + 1.0f) * [TalkInputView textViewLineHeight];
}
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.message.frame;
    
    int numLines = MAX([self.message numberOfLinesOfText],
                       [self.message numberOfLines]);
    
    self.message.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    self.message.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    self.message.scrollEnabled = (numLines >= 4);
    
    if(numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.message.contentSize.height - self.message.bounds.size.height);
        [self.message setContentOffset:bottomOffset animated:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
