//
//  ShopTabView.h
//  shopFriend
//
//  Created by Beautilut on 14-3-1.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShopTabViewDelegate;
@interface ShopTabView : UIView
{
    UIButton*shopLogoButton;
    id <ShopTabViewDelegate> delegate;
}
@property(nonatomic,strong) id <ShopTabViewDelegate> delegate;
@property(nonatomic,retain) UIButton*shopLogoButton;
@end
@protocol ShopTabViewDelegate <NSObject>
-(void)shopInfoShow:(id)sender;
-(void)shopMenuShow:(id)sender;
-(void)shopTalkShow:(id)sender;
@end