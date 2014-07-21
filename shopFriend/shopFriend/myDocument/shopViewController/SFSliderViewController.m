//
//  SFSliderViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-1.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SFSliderViewController.h"
#import "MenuViewController.h"
#import "SFTalkViewController.h"
#import "ShopSettingInfoViewController.h"
@interface SFSliderViewController ()
{
    float LeftSContentOffset;
    float LeftSContentScale;
    float LeftSJudgeOffset;
    float LeftSOpenDuration;
    float LeftSCloseDuration;
    float RightSCloseDuration;
    UIView*mainContentView;
    UIView*leftSideView;
    NSMutableDictionary*windowImageDic;
    UITapGestureRecognizer*tapGestureRec;
    SDWebImageManager*manager;
    BOOL comeFromTalk;
}
@end

@implementation SFSliderViewController
@synthesize shopDict,leftView,mainView;
+(SFSliderViewController*)sharedSliderController
{
    static SFSliderViewController *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedSVC=[[self alloc] init];
    });
    return sharedSVC;
}
-(id)init
{
    if (self=[super init]) {
        LeftSContentOffset=220;
        LeftSContentScale=0.85;
        LeftSJudgeOffset=100;
        LeftSOpenDuration=0.4;
        LeftSCloseDuration=0.3;
        RightSCloseDuration=0.3;
        manager=[[SDWebImageManager alloc] init];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self initSubView];
    //[self initMainView:nil];
    tapGestureRec=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    tapGestureRec.delegate=self;
    [self.view addGestureRecognizer:tapGestureRec];
    tapGestureRec.enabled=NO;
    windowImageDic=[[NSMutableDictionary alloc] init];
	// Do any additional setup after loading the view.
}
-(void)defaultSubViews:(ShopObject*)aShop withImage:(UIImage*)image
{
    shopDic=[[ShopObject alloc] init];
    [shopDic setShopID:aShop.shopID];
    [shopDic setShopName:aShop.shopName];
    for (id view in self.view.subviews) {
        [view removeFromSuperview];
    }
    for (id controller in self.childViewControllers) {
        [controller removeFromParentViewController];
    }
    NSURL*url=[NSURL URLWithString:GetShopWindowImage];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:shopDic.shopID forKey:@"shopID"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*rootDic=[parser objectWithString:request.responseString];
        NSArray*imageArray=[rootDic objectForKey:@"imageURL"];
        [mainView updateArray:imageArray];
    }];
    [request setFailedBlock:^{
        NSLog(@"InfoGetFail");
    }];
    [request startAsynchronous];

    [self initSubView];
    [self initMainView:image];
}
//-(void)mainViewAddImage:(NSMutableDictionary*)dic
//{
//    NSMutableArray*imageArray=[[NSMutableArray alloc] initWithCapacity:[dic.allKeys count]];
//    for (int i=0; i<[dic.allKeys count]; i++) {
//        [imageArray addObject:[dic objectForKey:[[NSNumber numberWithInt:i] stringValue]]];
//    }
//    [mainView updateArray:imageArray];
//}
-(void)initSubView
{
    leftSideView=[[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:leftSideView];
    mainContentView =[[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mainContentView];
    leftView=[[SFShopInfoViewController alloc] init];
    leftView.shopID=shopDic.shopID;
    [self addChildViewController:leftView];
    leftView.view.frame=CGRectMake(0, 0, leftView.view.frame.size.width, leftView.view.frame.size.height);
    [leftSideView addSubview:leftView.view];
}
-(void)initMainView:(UIImage*)image
{
    [self closeSideBar];
    mainView=[[SFShopMainViewController alloc] init];
    [mainView setTabImage:image];
    if (mainContentView.subviews.count>0) {
        UIView*view=[mainContentView.subviews firstObject];
        [view removeFromSuperview];
    }
    mainView.shopName=shopDic.shopName;
    mainView.shopID=shopDic.shopID;
    mainView.view.frame=mainContentView .frame;
    [mainContentView addSubview:mainView.view];
    if ([ShopObject flagShopByID:shopDic.shopID]==0) {
        [mainView setAttentionHiden:NO];
    }else
    {
        [mainView setAttentionHiden:YES];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden=NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)closeSideBar
{
    
    CGAffineTransform oriT = CGAffineTransformIdentity;
    [UIView animateWithDuration:mainContentView.transform.tx==LeftSContentOffset?LeftSCloseDuration:RightSCloseDuration
                     animations:^{
                         mainContentView.transform = oriT;
                     }
                     completion:^(BOOL finished) {
                         tapGestureRec.enabled = NO;
                     }];
}
-(void)leftItemClick
{
    //self.navigationController.navigationBarHidden=YES;
    CGAffineTransform conT = [self transformWithDirection];
    
    [self configureViewShadowWithDirection];
    
    [UIView animateWithDuration:LeftSOpenDuration
                     animations:^{
                         mainContentView.transform = conT;
                     }
                     completion:^(BOOL finished) {
                         tapGestureRec.enabled = YES;
                     }];
}
- (void)configureViewShadowWithDirection
{
    CGFloat shadowW;
    shadowW = -2.0f;
    mainContentView.layer.shadowOffset = CGSizeMake(shadowW, 1.0);
    mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    mainContentView.layer.shadowOpacity = 0.8f;
}
- (CGAffineTransform)transformWithDirection
{
    CGFloat translateX = 0;
    CGFloat transcale = 0;
    translateX = LeftSContentOffset;
    transcale = LeftSContentScale;
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(1.0, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    
    return conT;
}
#pragma mark - show menu
-(void)showMenu
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController*menu=[mainStoryboard instantiateViewControllerWithIdentifier:@"MenuView"];
    menu.shopID=shopDic.shopID;
    [self.navigationController pushViewController:menu animated:YES];
}
-(void)showTalkView
{
    if (comeFromTalk==YES) {
        [self.navigationController popViewControllerAnimated:YES];
        comeFromTalk=NO;
    }else
    {
    ShopObject*shop=[[ShopObject alloc] init];
    shop.shopID=shopDic.shopID;
    shop.shopName=shopDic.shopName;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SFTalkViewController*talkView=[mainStoryboard instantiateViewControllerWithIdentifier:@"SFTalkView"];
    [talkView setChatShop:shop];
    //[talkView setChatPerson:user];
    self.tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:1];
    [self.navigationController popToRootViewControllerAnimated:NO];
    //[self.tabBarController.selectedViewController.navigationController pushViewController:talkView animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTalkView" object:talkView];
    }
}
-(void)showSettingView
{
    ShopObject*shop=[[ShopObject alloc] init];
    shop.shopID=shopDic.shopID;
    shop.shopName=shopDic.shopName;
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShopSettingInfoViewController*shopSetting=[mainStoryboard instantiateViewControllerWithIdentifier:@"shopSettingInfoView"];
    [shopSetting setShop:shop];
    [self.navigationController pushViewController:shopSetting animated:YES];
}
-(void)popView
{
    [self closeSideBar];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)payAttention
{
    NSURL*url=[NSURL URLWithString:addNewShopAttention];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    NSString*userID=[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    NSString*shopID=shopDic.shopID;
    [request setPostValue:userID forKey:@"userID"];
    [request setPostValue:shopDic.shopID forKey:@"shopID"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*rootDic=[parser objectWithString:request.responseString];
        if ([[rootDic objectForKey:@"back"] integerValue]==1) {
            if ([ShopObject haveSaveShopByID:shopID]) {
                [ShopObject updateShopFlag:shopID withFlag:[NSNumber numberWithInt:1]];
            }else
            {
                ShopObject*newShop=[[ShopObject alloc] init];
                [newShop setShopID:shopID];
                [newShop setShopName:shopDic.shopName];
                [ShopObject saveNewShop:newShop];
                [ShopObject updateShopFlag:shopID withFlag:[NSNumber numberWithInt:1]];
            }
            [mainView setAttentionHiden:YES];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"InfoGetFail");
    }];
    [request startAsynchronous];
}
-(void)setComeFrom:(BOOL)from
{
    comeFromTalk=from;
}
@end
