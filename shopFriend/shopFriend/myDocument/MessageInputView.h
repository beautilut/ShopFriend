//
//  MessageInputView.h
//  shopFriend
//
//  Created by Beautilut on 14-5-13.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageInputView : UITextView
- (NSUInteger)numberOfLinesOfText;
+ (NSUInteger)maxCharactersPerLine;
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;
- (NSUInteger)numberOfLines;
@end
@protocol MessageInputViewDelegate <NSObject>


@end
