//
//  CouponViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-4-28.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "CouponViewController.h"
#import "ShopNaviBar.h"
#import "CouponShopListViewController.h"
#import "CouponFeedBackViewController.h"
@interface CouponViewController ()
{
    CouponObject*myCoupon;
    
    UIScrollView*backScroll;
    UIView*infoView;
    UIImageView*couponImage;
    
    CGFloat firstViewHeight;
    CGFloat secondeViewHeight;
    NSInteger shopNumber;
    NSMutableArray*shopList;
    UITableView*table;
}
@end

@implementation CouponViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    shopList=[[NSMutableArray alloc] init];
    [self getShopList];
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setText:myCoupon.couponName];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [navi addSubview:backImage];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0,24,40, 40)];
    [button addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:button];
    
    backScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, navi.frame.size.height, screenBounds.size.width, screenBounds.size.height-navi.frame.size.height)];
    [backScroll setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0f]];
    [self.view addSubview:backScroll];
    couponImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [backScroll addSubview:couponImage];
    infoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, backScroll.frame.size.width, 0)];
    [infoView setFrame:CGRectMake(0, 0, backScroll.frame.size.width,1000)];
    UIView*view=[self setFirstView:screenBounds];
    [infoView addSubview:view];
    
    UIView*textView=[self textView:screenBounds];
    CGRect textFrame=textView.frame;
    [textView setFrame:CGRectMake(0, view.frame.origin.y+view.frame.size.height+30, textView.frame.size.width, textView.frame.size.height)];
    [infoView addSubview:textView];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, textView.frame.size.height+textView.frame.origin.y, infoView.frame.size.width, 300) style:UITableViewStyleGrouped];
    [table setDelegate:self];
    [table setDataSource:self];
    [table setScrollEnabled:NO];
    [infoView addSubview:table];
    
    [infoView setFrame:CGRectMake(0, 0, backScroll.frame.size.width, table.frame.size.height+table.frame.origin.y)];
    [backScroll addSubview:infoView];
    [backScroll setContentSize:CGSizeMake(screenBounds.size.width, infoView.frame.size.height)];
    [self.view bringSubviewToFront:navi];
    [self getCouponImage];
    
    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getCoupon:(CouponObject *)aCoupon
{
    myCoupon=aCoupon;
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView*)setFirstView:(CGRect)screenRect
{
    UIView*fView=[[UIView alloc] init];
    CGSize infoSize=[myCoupon.couponInfo sizeWithFont:[UIFont fontWithName:@"verdana-Bold" size:25.0f]];
    NSInteger line=infoSize.width/(screenRect.size.width-40)+1;
    [fView setFrame:CGRectMake(0, 0, screenRect.size.width, 500)];
    
    UILabel*infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 40, fView.frame.size.width-40, infoSize.height*line)];
    [infoLabel setFont:[UIFont fontWithName:@"verdana-Bold" size:25.0f]];
    [infoLabel setText:myCoupon.couponInfo];
    [infoLabel setNumberOfLines:20.0f];
    [fView addSubview:infoLabel];
    
    UIImageView*line1=[[UIImageView alloc] initWithFrame:CGRectMake(10, infoLabel.frame.origin.y+infoLabel.frame.size.height+30, fView.frame.size.width-20, 1)];
    [line1 setBackgroundColor:[UIColor orangeColor]];
    [fView addSubview:line1];
    
    UILabel*useDate=[[UILabel alloc] initWithFrame:CGRectMake(20, line1.frame.origin.y+1+5, line1.frame.size.width, 20)];
    NSString*date;
    if (myCoupon.couponBeginTime!=[NSNull null]) {
        NSString*bt=[myCoupon.couponBeginTime substringToIndex:10];
        NSString*et=[myCoupon.couponEndTime substringToIndex:10];
        date=[NSString stringWithFormat:@"使用有效期:%@ 至 %@",bt,et];
    }else{
        NSString*et=[myCoupon.couponEndTime substringToIndex:10];
        date=[NSString stringWithFormat:@"使用有效期:%@ ",et];
    }
    [useDate setText:date];
    [fView addSubview:useDate];
    
    UIImageView*line2=[[UIImageView alloc] initWithFrame:CGRectMake(10, useDate.frame.origin.y+useDate.frame.size.height+5, line1.frame.size.width, 1)];
    [line2 setBackgroundColor:[UIColor orangeColor]];
    [fView addSubview:line2];
    
    UILabel*showLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, line2.frame.origin.y+1+5, line2.frame.size.width, 20)];
    [showLabel setText:@"出示此页既享优惠"];
    [fView addSubview:showLabel];
    
    [fView setFrame:CGRectMake(0, 0, screenRect.size.width, showLabel.frame.origin.y+showLabel.frame.size.height+10)];
    [fView setBackgroundColor:[UIColor whiteColor]];
    return fView;
}
-(UIView*)textView:(CGRect)screenRect
{
    UIView*fView=[[UIView alloc] init];
    [fView setBackgroundColor:[UIColor whiteColor]];
    [fView setFrame:CGRectMake(0, 0, screenRect.size.width, 500)];
    
    UITextView*text=[[UITextView alloc] initWithFrame:CGRectMake(20, 5, fView.frame.size.width-40, 250)];
    [text setText:myCoupon.couponUseInfo];
    [text setSelectable:NO];
    [text setEditable:NO];
    
    CGRect frame = text.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [text sizeThatFits:constraintSize];
    [text setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height)];
    [fView addSubview:text];
    
    [fView setFrame:CGRectMake(0, 0, screenRect.size.width, size.height+10)];
    return fView;
}
#pragma mark table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell;
    if (cell==nil) {
        cell=[[UITableViewCell alloc] init];
    }
    if ([indexPath section]==0) {
        NSString*string=[NSString stringWithFormat:@"可用店铺（%d家）",shopNumber];
        [cell.textLabel setText:string];
    }
    if ([indexPath section]==1) {
        [cell.textLabel setText:@"投诉"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0) {
        [self performSegueWithIdentifier:@"couponShopList" sender:nil];
    }
    if ([indexPath section]==1) {
        [self performSegueWithIdentifier:@"couponFeedBack" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"couponFeedBack"]) {
        
    }
    if ([[segue identifier] isEqualToString:@"couponShopList"]) {
        [[segue destinationViewController] getShopList:shopList];
    }
}
#pragma  mark webMethod
-(void)getShopList
{
    NSURL*url=[NSURL URLWithString:GetCouponShopList];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:myCoupon.couponID forKey:@"couponID"];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    [request setPostValue:hostID forKey:@"userID"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if ([[dic objectForKey:@"back"] intValue]==1) {
            shopList =[dic objectForKey:@"shopID"];
            shopNumber=[shopList count];
            [table reloadData];
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
-(void)getCouponImage
{
    if (myCoupon.couponImageURL!=[NSNull null]) {
        NSURL*url=[NSURL URLWithString:myCoupon.couponImageURL];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:url
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 // do something with image
                 [couponImage setFrame:CGRectMake(0, 0, backScroll.frame.size.width,300)];
                 [couponImage setImage:image];
                 [self setCoupon];
             }
         }];
    }
}
-(void)setCoupon
{
    [infoView setFrame:CGRectMake(0, couponImage.frame.size.height,backScroll.frame.size.width, infoView.frame.size.height)];
    [backScroll setContentSize:CGSizeMake(backScroll.frame.size.width, couponImage.frame.size.height+infoView.frame.size.height)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
