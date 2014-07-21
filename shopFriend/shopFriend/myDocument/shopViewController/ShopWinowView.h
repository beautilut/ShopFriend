//
//  ShopWinowView.h
//  shopFriend
//
//  Created by Beautilut on 14-3-23.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WindowNumberObject.h"
@interface ShopWinowView : UIView<UIScrollViewDelegate,WindowNumberObjectDelegate>
@property(nonatomic,strong) UIScrollView*scrollView;
@property(nonatomic,strong) NSMutableArray*slideImages;
@property(nonatomic,strong) UIPageControl*pageControl;
- (id)initWithFrame:(CGRect)frame;
-(void)updateArray:(NSArray*)array;
@end
