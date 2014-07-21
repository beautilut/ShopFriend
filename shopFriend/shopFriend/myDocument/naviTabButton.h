//
//  naviTabButton.h
//  shopFriend
//
//  Created by Beautilut on 14-3-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface naviTabButton : UIButton
@property(nonatomic,strong) NSString*select;
@property(nonatomic,strong) NSString*noSelect;
- (id)initWithFrame:(CGRect)frame withImage:(NSString*)name;
-(void)buttonChangeImage:(BOOL)yes;
@end
