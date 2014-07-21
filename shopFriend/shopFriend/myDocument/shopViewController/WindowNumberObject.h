//
//  WindowNumberObject.h
//  shopFriend
//
//  Created by Beautilut on 14-4-19.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WindowNumberObjectDelegate;
@interface WindowNumberObject : NSObject
{
    id<WindowNumberObjectDelegate>delegate;
    NSNumber*countNumber;
    UIImage*downImage;
}
@property(nonatomic,strong)id<WindowNumberObjectDelegate>delegate;
-(id)initWithNumber:(NSNumber*)number withURL:(NSURL*)url withDelegate:(id)delegate;
-(int)getCountNumber;
-(UIImage*)getImage;
@end
@protocol WindowNumberObjectDelegate <NSObject>
-(void)imageDown:(WindowNumberObject*)object;
@end