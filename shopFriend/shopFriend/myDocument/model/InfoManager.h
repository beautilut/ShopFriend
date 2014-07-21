//
//  InfoManager.h
//  shopFriend
//
//  Created by Beautilut on 14-3-13.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface InfoManager : NSObject
{
    HostModel*host;
}
@property(nonatomic,retain) HostModel*host;
+(InfoManager*)sharedInfo;
#pragma mark -setInfo-
-(void)getUserInfo;
#pragma mark -changeInfo-
-(void)getCoupon;
#pragma mark -getUser image-
-(void)saveUserImage:(UIImage*)image;
-(UIImage*)getUserImage;
#pragma mark checkPhone
-(BOOL)checkPhone:(NSString*)string;
@end
