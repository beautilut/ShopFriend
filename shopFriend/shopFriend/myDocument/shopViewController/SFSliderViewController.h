//
//  SFSliderViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-3-1.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFShopInfoViewController.h"
#import "SFShopMainViewController.h"
@interface SFSliderViewController : UIViewController<UIGestureRecognizerDelegate>
{
        SFShopInfoViewController*leftView;
        SFShopMainViewController*mainView;
        ShopObject*shopDic;
}
@property(nonatomic,retain) NSDictionary*shopDict;
@property(nonatomic,strong) SFShopInfoViewController*leftView;
@property(nonatomic,strong) SFShopMainViewController*mainView;
-(void)leftItemClick;
+(SFSliderViewController*)sharedSliderController;
-(void)showMenu;
-(void)showTalkView;
-(void)showSettingView;
-(void)popView;
-(void)payAttention;
-(void)defaultSubViews:(ShopObject*)aShop withImage:(UIImage*)image;
-(void)setComeFrom:(BOOL)from;
@end
