//
//  UserInfoViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-2-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ShopNaviBar.h"
#define imagesHeight 160
@interface UserInfoViewController ()
{
    UIScrollView*backScrollView;
    UIImageView*backImageView;
    float imagesScrollStart;
    float scrollingKoef;
    UIImageView*headImageView;
    UITableView*table;
    UILabel*namelabel;
}
@end

@implementation UserInfoViewController

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
    [self.navigationController.navigationBar setHidden:YES];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    //定制tabbar
    ShopTabBar*tabbar=[[ShopTabBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withButtonID:2];
    [tabbar setDelegate:self];
    [self.view addSubview:tabbar];
    
    namelabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [namelabel setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [namelabel setTextAlignment:NSTextAlignmentCenter];
    [namelabel setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [namelabel setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:namelabel];
    
    UIImageView*editView=[[UIImageView alloc] initWithFrame:CGRectMake(navi.frame.size.width-35,28, 25, 25)];
    [editView setImage:[UIImage imageNamed:@"edit"]];
    [navi addSubview:editView];
    UIButton*editButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-40,24,40,40)];
    [editButton addTarget:self action:@selector(userSetting:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:editButton];
    
    UIBarButtonItem*settingItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(userSetting:)];
    self.navigationItem.rightBarButtonItem=settingItem;
    
    
    backScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,naviHight, screenBounds.size.width,screenBounds.size.height-naviHight)];
    [backScrollView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]];
    [backScrollView setContentSize:CGSizeMake(screenBounds.size.width,600)];
    [backScrollView setDelegate:self];
    [self.view addSubview:backScrollView];
    
    [self designImage];
    backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,imagesScrollStart, backScrollView.frame.size.width,300)];
    [backImageView setImage:[UIImage imageNamed:@"1.jpg"]];
    [backScrollView addSubview:backImageView];
    
    headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [headImageView setCenter:CGPointMake(screenBounds.size.width/2,90)];
    headImageView.layer.borderWidth=2;
    headImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    headImageView.layer.cornerRadius=CGRectGetHeight(headImageView.bounds)/2;
    headImageView.clipsToBounds=YES;
    [headImageView setBackgroundColor:[UIColor whiteColor]];
    [backScrollView addSubview:headImageView];
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 170, screenBounds.size.width, backScrollView.contentSize.height-170) style:UITableViewStyleGrouped];
    [table setDelegate:self];
    [table setDataSource:self];
    [table  setScrollEnabled:NO];
    [backScrollView addSubview:table];
	// Do any additional setup after loading the view.
    [self.view bringSubviewToFront:tabbar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeadImage:) name:@"userImageChange"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quit:) name:@"quitNotification" object:nil];
    [self.view bringSubviewToFront:navi];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setHeadImage:nil];
    HostModel* host=[HostModel fetchHostInfo];
    [namelabel setText:host.hostName];
}
-(void)setHeadImage:(id)sender
{
    UIImage*image=[[InfoManager sharedInfo] getUserImage];//[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageKey];
    [headImageView setImage:image];
}
-(void)quit:(id)sender
{
    self.tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:0];
}
-(void)designImage
{
    imagesScrollStart = -(backScrollView.frame.size.width - imagesHeight)/2 - 10;
    
    scrollingKoef = 0.2*imagesHeight/80.0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectViewController:(NSInteger)integer
{
    
    self.tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:integer];
}
//methods
-(void)userSetting:(id)sender
{
    [self performSegueWithIdentifier:@"userEdit" sender:nil];
}
#pragma mark - tableMethod
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return 1;
    }
    return 0;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell;
    if (!cell) {
        cell=[[UITableViewCell alloc] init];
    }
//    if ([indexPath section]==0&&indexPath.row==0) {
//        [cell.textLabel setText:@"好友"];
//    }
    if ([indexPath section]==0&&indexPath.row==0) {
        [cell.textLabel setText:@"店友"];
    }
    if ([indexPath section]==1&&indexPath.row==0) {
        [cell.textLabel setText:@"优惠库"];
    }
    if ([indexPath section]==2&&indexPath.row==0) {
        [cell.textLabel setText:@"设置"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0&&indexPath.row==0) {
        [self performSegueWithIdentifier:@"shopFriend" sender:nil];
    }
    if ([indexPath section]==1&&indexPath.row==0) {
        [self performSegueWithIdentifier:@"coupon" sender:nil];
    }
    if ([indexPath section]==2&&indexPath.row==0) {
        [self performSegueWithIdentifier:@"setting" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - scrollMethod
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==backScrollView) {
        backImageView.frame = CGRectMake(backImageView.frame.origin.x, imagesScrollStart + backScrollView.contentOffset.y*scrollingKoef, backImageView.frame.size.width, backImageView.frame.size.height);
        return;
    }
}

@end
