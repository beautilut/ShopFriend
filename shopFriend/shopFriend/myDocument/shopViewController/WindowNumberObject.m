//
//  WindowNumberObject.m
//  shopFriend
//
//  Created by Beautilut on 14-4-19.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "WindowNumberObject.h"

@implementation WindowNumberObject
@synthesize delegate;
-(id)initWithNumber:(NSNumber*)number withURL:(NSURL*)url withDelegate:(id)delegate
{
    self =[super init];
    if (self) {
        countNumber=number;
        self.delegate=delegate;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            downImage =image;
            if ([self.delegate respondsToSelector:@selector(imageDown:)]) {
                [self.delegate imageDown:self];
            }
        }];
    }
    return self;
}
-(int)getCountNumber
{
    return [countNumber intValue];
}
-(UIImage*)getImage
{
    return downImage;
}
@end
