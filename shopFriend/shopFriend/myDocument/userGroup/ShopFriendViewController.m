//
//  ShopFriendViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-26.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopFriendViewController.h"
#import "ShopFriendCell.h"
#import "SFSliderViewController.h"
#import "ShopNaviBar.h"
@interface ShopFriendViewController ()
{
    NSMutableArray*shopFriendArray;
    UITableView*shopFriendTable;
    NSMutableDictionary*imageDic;
}
@end

@implementation ShopFriendViewController

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
    shopFriendArray=[ShopObject fetchAllFriendShopFromLocal];
    imageDic=[[NSMutableDictionary alloc] init];
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setText:@"我的店友"];
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
    shopFriendTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height) style:UITableViewStylePlain];
    [shopFriendTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [shopFriendTable setDelegate:self];
    [shopFriendTable setDataSource:self];
    float topInset = self.navigationController.navigationBar.frame.size.height+20;
    shopFriendTable.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    [self.view addSubview:shopFriendTable];
    // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:navi];
}
-(void)viewWillAppear:(BOOL)animated
{
    shopFriendArray=[ShopObject fetchAllFriendShopFromLocal];
    [self getShopActivitys];
    [shopFriendTable reloadData];
}
-(void)getShopActivitys
{
    NSMutableArray*shopID=[[NSMutableArray alloc] init];
    for (ShopObject*aShop in shopFriendArray) {
        [shopID addObject:aShop.shopID];
    }
    NSURL*url=[NSURL URLWithString:GetShopActivity];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:hostID forKey:@"userID"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if ([[dic objectForKey:@"result"] intValue]==1) {
            NSArray*shopArray=[dic objectForKey:@"shop"];
            for (int i=0; i<[shopFriendArray count]; i++) {
                ShopObject*aShop=[shopFriendArray objectAtIndex:i];
                int x=0;
                while (x<[shopArray count]) {
                    NSArray*array=[shopArray objectAtIndex:x];
                    if ([array count]>0) {
                        NSDictionary*dic=[array objectAtIndex:0];
                        NSString*shop=[dic objectForKey:@"shop_ID"];
                        if ([shop isEqualToString:aShop.shopID]) {
                            aShop.shopActivity=[dic objectForKey:@"shop_activity_info"];
                            [shopFriendArray replaceObjectAtIndex:i withObject:aShop];
                        }
                    }
                    x++;
                }
            }
            [shopFriendTable reloadData];
        }
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableMethods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shopFriendArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopFriendCell*cell;
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"ShopFriendCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[ShopFriendCell class]]) {
                cell=(ShopFriendCell*)oneObject;
                ShopObject*aShop=[shopFriendArray objectAtIndex:indexPath.row];
                [cell setCellInfo:aShop];
                NSURL*url=[NSURL URLWithString:SHOP_LOGO_URL(aShop.shopID)];
                [cell.shopImage setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage*image,NSError*error,SDImageCacheType cacheType){
                    if (image) {
                        [imageDic setObject:image forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
                    }
                }];
                
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[SFSliderViewController sharedSliderController] defaultSubViews:[shopFriendArray objectAtIndex:indexPath.row] withImage:[imageDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
    [self.navigationController pushViewController:[SFSliderViewController sharedSliderController] animated:YES];
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
