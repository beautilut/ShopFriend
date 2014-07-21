//
//  ShopTabBar.h
//  shopFriend
//
//  Created by Beautilut on 14-1-7.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShopTabBarDelegate;
@interface ShopTabBar : UIView
{
    id <ShopTabBarDelegate> delegate;
    NSMutableArray*btnArray;
}
@property(nonatomic,strong) id <ShopTabBarDelegate> delegate;
-(id)initWithFrame:(CGRect)frame withButtonID:(int)idNumber;
-(void)tabBarButtonClicked:(id)sender;
@end
@protocol ShopTabBarDelegate <NSObject>
-(void)selectViewController:(NSInteger)integer;
@end