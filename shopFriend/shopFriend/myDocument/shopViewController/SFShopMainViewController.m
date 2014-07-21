//
//  SFShopMainViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-1.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SFShopMainViewController.h"
#import "SFSliderViewController.h"
#import "ShopWinowView.h"
@interface SFShopMainViewController ()
{
    ShopTabView*shopTabView;
    ShopWinowView*shopWindow;
    UIImage*LogoImage;
    UIAlertView*attentionView;
    
        ShopNaviBar*navi;
    
    
//    UIView*infoView;
//    UIScrollView*infoScroller;
//    UILabel*infoLabel;
}
@end

@implementation SFShopMainViewController
@synthesize shopScroll;
@synthesize shopID;
@synthesize shopName;
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
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:shopName];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    shopTabView=[[ShopTabView alloc] initWithFrame:CGRectMake(0, screenBounds.size.height-50, screenBounds.size.width, 50)];
    [shopTabView setDelegate:self];
    [shopTabView.shopLogoButton setImage:LogoImage forState:UIControlStateNormal];
    [self.view addSubview:shopTabView];
    
    shopScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenBounds.size.width, screenBounds.size.height)];
    [shopScroll setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:shopScroll];
    shopWindow=[[ShopWinowView alloc] initWithFrame:CGRectMake(0,naviHight,shopScroll.frame.size.width, shopScroll.frame.size.height-naviHight-shopTabView.frame.size.height)];
    [shopScroll  addSubview:shopWindow];
    
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [navi addSubview:backImage];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0,24,40, 40)];
    [button addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:button];
    
    payAttentionView=[[UIView alloc] initWithFrame:CGRectMake(navi.frame.size.width-40, 24, 40, 40)];
    [navi addSubview:payAttentionView];
    UIButton*attentionButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [attentionButton addTarget:self action:@selector(payAttentionTo:) forControlEvents:UIControlEventTouchDown];
    [payAttentionView addSubview:attentionButton];
    UIImageView*image=[[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 25, 25)];
    [image setImage:[UIImage imageNamed:@"attend"]];
    [payAttentionView addSubview:image];
    
    settingView=[[UIView alloc] initWithFrame:CGRectMake(navi.frame.size.width-40,24, 40, 40)];
    [navi addSubview:settingView];
    UIButton*settingButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [settingButton addTarget:self action:@selector(shopSettingInfo:) forControlEvents:UIControlEventTouchDown];
    [settingView addSubview:settingButton];
    UIImageView*image2=[[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 30, 30)];
    [image2 setImage:[UIImage imageNamed:@"shopInfo"]];
    [settingView addSubview:image2];
    
    
//    attentionButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-35,28, 25, 25)];
//    [attentionButton addTarget:self action:@selector(payAttentionTo:) forControlEvents:UIControlEventTouchDown];
//    [attentionButton setImage:[UIImage imageNamed:@"attend"] forState:UIControlStateNormal];
//    [navi addSubview:attentionButton];
//    shopSettingButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-35, 27, 30, 30)];
//    [shopSettingButton addTarget:self action:@selector(shopSettingInfo:) forControlEvents:UIControlEventTouchDown];
//    [shopSettingButton setImage:[UIImage imageNamed:@"shopInfo"] forState:UIControlStateNormal];
//    [navi addSubview:shopSettingButton];
    
//
//    infoView=[[UIView alloc] initWithFrame:CGRectMake(0, naviHight, screenBounds.size.width, 40)];
//    [infoView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:infoView];
//    UIImageView*infoBack=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, infoView.frame.size.width, infoView.frame.size.height)];
//    [infoBack setBackgroundColor:[UIColor blackColor]];
//    [infoBack setAlpha:0.3f];
//    [infoView addSubview:infoBack];
//    infoScroller=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,infoView.frame.size.width, infoView.frame.size.height)];
//    [infoScroller setBackgroundColor:[UIColor clearColor]];
//    infoScroller.showsHorizontalScrollIndicator=NO;
//    [infoView addSubview:infoScroller];    
//    infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, infoView.frame.size.width, infoView.frame.size.height)];
//    [infoLabel setFont:[UIFont systemFontOfSize:16.0f]];
//    [infoLabel setTextColor:[UIColor whiteColor]];
//    [infoScroller addSubview:infoLabel];
//    [infoView setHidden:YES];
    
    
    [self.view bringSubviewToFront:navi];
    [self.view bringSubviewToFront:shopTabView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attentionChange:) name:@"attentionChange" object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark - shopTab Delegate
-(void)viewWillAppear:(BOOL)animated
{
//    NSURL*url=[NSURL URLWithString:GetShopStatus];
//    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:shopID forKey:@"shopID"];
//    [request setCompletionBlock:^{
//        SBJsonParser*parser=[[SBJsonParser alloc] init];
//        NSDictionary*rootDic=[parser objectWithString:request.responseString];
//        if ([[rootDic objectForKey:@"back"] intValue]==1) {
//            [infoLabel setText:[rootDic objectForKey:@"info"]];
//            CGSize labelSize=[infoLabel.text sizeWithFont:[UIFont systemFontOfSize:16.0]];
//            [infoLabel setFrame:CGRectMake(10, 0, labelSize.width+10, infoView.frame.size.height)];
//            [infoScroller setContentSize:CGSizeMake(labelSize.width+20, infoView.frame.size.height)];
//            [infoView setHidden:NO];
//        }
//    }];
//    [request setFailedBlock:^{
//        NSLog(@"InfoGetFail");
//    }];
//    [request startAsynchronous];
}
-(void)attentionChange:(id)sender
{
    BOOL change=[[sender object] boolValue];
    [self setAttentionHiden:change];
}
-(void)backNavi:(id)sender
{
    //[(SFSliderViewController*)self.parentViewController popView];
    [[SFSliderViewController sharedSliderController] popView];
}
-(void)payAttentionTo:(id)sender
{
    attentionView=[[UIAlertView alloc] initWithTitle:@"" message:@"是否关注此商户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [attentionView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==attentionView) {
        if (buttonIndex==1) {
            [[SFSliderViewController sharedSliderController] payAttention];
        }
    }
}
-(void)shopInfoShow:(id)sender
{
    [[SFSliderViewController sharedSliderController] leftItemClick];
}
-(void)shopMenuShow:(id)sender
{
    [[SFSliderViewController sharedSliderController] showMenu];
}
-(void)shopTalkShow:(id)sender
{
    [[SFSliderViewController sharedSliderController] showTalkView];
}
-(void)shopSettingInfo:(id)sender
{
    [[SFSliderViewController sharedSliderController] showSettingView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//ui
-(void)setTabImage:(UIImage*)image
{
    LogoImage=image;
}
-(void)updateArray:(NSArray*)array
{
    [shopWindow updateArray:array];
}
-(void)setAttentionHiden:(BOOL)hide
{
    [payAttentionView setHidden:hide];
    [settingView setHidden:!hide];
//    [attentionButton setHidden:hide];
//    [shopSettingButton setHidden:!hide];
}
@end
