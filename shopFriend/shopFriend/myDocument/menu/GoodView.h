//
//  GoodView.h
//  shopFriend
//
//  Created by Beautilut on 14-3-26.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowNumberObject.h"
@interface GoodView : UIView<UIScrollViewDelegate,WindowNumberObjectDelegate>
{
    UIControl*overView;
    UIImage*backImage;
    UIView*deepView;
    UIScrollView*imageScroller;
    NSMutableArray*menuImageArray;
    UITextView*infoText;
    UIPageControl*pageControl;
    SDWebImageManager*manager;
}
@property(nonatomic,strong) UIPageControl*pageControl;
@property(nonatomic,strong) UIScrollView*imageScroller;
@property(nonatomic,strong) NSMutableArray*menuImageArray;
+(GoodView*)sharedGoodView;
-(void)setMenuArray:(NSArray*)menuArray withShopID:(NSString*)shopID;
-(void)show;
-(void)setBlurImage:(UIImage*)image;
-(void)selfsetBack:(UIImage*)image;
@end
