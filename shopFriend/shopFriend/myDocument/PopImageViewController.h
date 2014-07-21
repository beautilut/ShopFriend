//
//  PopImageViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-1-17.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
@interface PopImageViewController : UIViewController<UIScrollViewDelegate,SDWebImageManagerDelegate>
{
    NSString*imageUrl;
}
-(void)setImageUrl:(NSString*)url;
@end
