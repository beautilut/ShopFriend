//
//  SFShopMainViewController.h
//  shopFriend
//
//  Created by Beautilut on 14-3-1.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopTabView.h"
#import "ShopNaviBar.h"
@interface SFShopMainViewController : UIViewController<ShopTabViewDelegate,UIAlertViewDelegate>
{
    UIScrollView*shopScroll;
     //UIButton*attentionButton;
    //UIButton *shopSettingButton;
    UIView*settingView;
    UIView*payAttentionView;
    NSString*shopID;
    NSString*shopName;
}
@property(nonatomic,retain) UIScrollView*shopScroll;
@property(nonatomic,retain) NSString*shopID;
@property(nonatomic,retain) NSString*shopName;
//-(void)getShopInfo:(NSDictionary*)dic;
-(void)setTabImage:(UIImage*)string;
-(void)updateArray:(NSArray*)array;
-(void)setAttentionHiden:(BOOL)hide;
@end
