//
//  CouponShopListViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-5-4.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "CouponShopListViewController.h"
#import "ShopNaviBar.h"
#import "SFSliderViewController.h"
#import "CouponShopTableViewCell.h"
@interface CouponShopListViewController ()
{
    NSMutableArray*shopListArray;
    NSMutableDictionary*shopImageDic;
}
@end

@implementation CouponShopListViewController

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
    shopImageDic=[[NSMutableDictionary alloc] init];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setText:@"可用店铺"];
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
    
    UITableView*table=[[UITableView alloc] initWithFrame:CGRectMake(0,navi.frame.size.height,screenBounds.size.width, screenBounds.size.height-navi.frame.size.height)];
    [table setDelegate:self];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [table setDataSource:self];
    [self.view addSubview:table];

    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getShopList:(NSMutableArray*)array
{
    shopListArray=array;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark table
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopObject*aShop=[[ShopObject alloc] init];
    NSDictionary*dic=[shopListArray objectAtIndex:indexPath.row];
    [aShop setShopID:[dic objectForKey:@"shop_ID"]];
    [aShop setShopName:[dic objectForKey:@"shop_name"]];
    [[SFSliderViewController sharedSliderController] defaultSubViews:aShop withImage:[shopImageDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
    [self.navigationController pushViewController:[SFSliderViewController sharedSliderController] animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shopListArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CouponShopTableViewCell"];
    // Configure the cell...
    CouponShopTableViewCell*cell;
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"CouponShopTableViewCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[CouponShopTableViewCell class]]) {
                cell=(CouponShopTableViewCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                NSDictionary*shopDic=[shopListArray objectAtIndex:indexPath.row];
                [cell setCellInfo:shopDic];
                NSString*shopID=[shopDic objectForKey:@"shop_ID"];
                NSURL*url=[NSURL URLWithString:SHOP_LOGO_URL(shopID)];
                [cell.imageView setHidden:YES];
                [cell.imageView setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage*image,NSError*error,SDImageCacheType cacheType){
                    if (image!=nil) {
                        [shopImageDic setObject:image forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
                    }
                }];
            }
        }
    }
    return cell;
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
