//
//  CouponListViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-4-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "CouponListViewController.h"
#import "ShopNaviBar.h"

#import "CouponViewController.h"
@interface CouponListViewController ()
{
    UITableView*couponView;
    NSMutableArray*couponList;
    NSIndexPath *selectRow;
}
@end

@implementation CouponListViewController

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
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setText:@"我的优惠库"];
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

    couponView=[[UITableView alloc] initWithFrame:CGRectMake(0, navi.frame.origin.y+navi.frame.size.height, screenBounds.size.width, screenBounds.size.height-navi.frame.size.height)];
    [couponView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0f]];
    [couponView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [couponView setDelegate:self];
    [couponView setDataSource:self];
    [self.view addSubview:couponView];
    couponList=[[NSMutableArray alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewCoupon:) name:@"CouponGet" object:nil];
    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    couponList=[CouponObject fetchUseAbleCouponsWithUser];
     //couponList=[CouponObject fetchAllCouponsWithUser];
}
-(void)getNewCoupon:(id)sender
{
    couponList=[CouponObject fetchUseAbleCouponsWithUser];
    [couponView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return couponList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell*cell=[tableView dequeueReusableCellWithIdentifier:@"couponCell"];
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[CouponCell class]]) {
                cell=(CouponCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                CouponObject*cellCoupon=[couponList objectAtIndex:indexPath.row];
                [cell setCouponCell:cellCoupon];
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectRow=indexPath;
    [self  performSegueWithIdentifier:@"couponDetail" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"couponDetail"]) {
        [[segue destinationViewController] getCoupon:[couponList objectAtIndex:selectRow.row]];
    }
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
