//
//  ShopListViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-1-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopListViewController.h"
#import "AppDelegate.h"
#import "ShopCell.h"
#import "SFSliderViewController.h"
#import "SFShopMainViewController.h"
#import "ShopNaviBar.h"
#import "SFRefreshHeaderView.h"
#import "SFRefreshFooterView.h"
#define pageCount 15;
@interface ShopListViewController ()
{
    NSMutableArray*shopListArray;
    NSMutableDictionary*imageDic;
    NSMutableDictionary*locateDic;
    NSMutableDictionary*categoryList;
    int count;
    
    SFRefreshFooterView * _footer;
    SFRefreshHeaderView * _header;
}
@end

@implementation ShopListViewController
@synthesize shopListTable;
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    [self.navigationController.navigationBar setHidden:YES];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    [self.tabBarController.tabBar setHidden:YES];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setText:@"店铺"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    //定制tabbar
    ShopTabBar*tabbar=[[ShopTabBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withButtonID:0];
    [tabbar setDelegate:self];
    [self.view addSubview:tabbar];
    //tableView
    shopListArray=[[NSMutableArray alloc] init];
    imageDic=[[NSMutableDictionary alloc] init];
    locateDic=[[NSMutableDictionary alloc] init];
     float topInset = self.navigationController.navigationBar.frame.size.height+20;
    shopListTable=[[UITableView alloc] initWithFrame:CGRectMake(0, topInset, screenBounds.size.width, screenBounds.size.height-topInset-tabbar.frame.size.height)];
   // shopListTable.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    //[shopListTable setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:0.3]];
    [shopListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [shopListTable setBackgroundColor:[UIColor whiteColor]];
    [shopListTable setDelegate:self];
    [shopListTable setDataSource:self];
    
    [self addHeader];
    [self addFooter];
    //[shopListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:shopListTable];
    [self.view bringSubviewToFront:tabbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocaiton:) name:@"getLocation" object:nil];
    [self.view bringSubviewToFront:navi];
    //[refreshHeaderView refreshLastUpdatedDate];
    //[self getShopList:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)getShopList:(id)sender
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"startLocation" object:nil];
    NSURL*url=[NSURL URLWithString:GetShopList];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[locateDic objectForKey:@"userLat"] forKey:@"userLat"];
    [request setPostValue:[locateDic objectForKey:@"userLon"] forKey:@"userLon"];
    [request setPostValue:[NSNumber numberWithInt:count] forKey:@"page"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if (count==0) {
            shopListArray=[dic objectForKey:@"data"];
        }else
        {
        [shopListArray addObjectsFromArray:[dic objectForKey:@"data"]];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"fail");
    }];
    [request startAsynchronous];
}
-(void)getLocaiton:(id)sender
{
    //NSLog(@"%@",[sender object]);
    if ([sender object]==nil) {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"错误" message:@"无法定位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return ;
    }
    CLLocation * currLocation = [[sender object] lastObject];
    NSString* lat=[NSString stringWithFormat:@"%3.5f",currLocation.coordinate.latitude];
    NSString* lon=[NSString stringWithFormat:@"%3.5f",currLocation.coordinate.longitude];
    [locateDic setObject:lat forKey:@"userLat"];
    [locateDic setObject:lon forKey:@"userLon"];
    [self getShopList:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"startLocation" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return shopListArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ShopCell"];
    // Configure the cell...
    ShopCell*cell;
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"ShopCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[ShopCell class]]) {
                cell=(ShopCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
              NSDictionary*shopDic=[shopListArray objectAtIndex:indexPath.row];
                [cell setCellInfo:shopDic];
                NSString*shopID=[shopDic objectForKey:@"shop_ID"];
                NSURL*url=[NSURL URLWithString:SHOP_LOGO_URL(shopID)];
                [cell.shopImage setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage*image,NSError*error,SDImageCacheType cacheType){
                    if (image!=nil) {
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
    ShopObject*aShop=[[ShopObject alloc] init];
    NSDictionary*dic=[shopListArray objectAtIndex:indexPath.row];
    [aShop setShopID:[dic objectForKey:@"shop_ID"]];
    [aShop setShopName:[dic objectForKey:@"shop_name"]];
    [[SFSliderViewController sharedSliderController] defaultSubViews:aShop withImage:[imageDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
    [self.navigationController pushViewController:[SFSliderViewController sharedSliderController] animated:YES];
}
-(void)selectViewController:(NSInteger)integer
{

    self.tabBarController.selectedViewController=[self.tabBarController.viewControllers objectAtIndex:integer];
    
}
#pragma mark - refreshView Methods
- (void)addFooter
{
    __unsafe_unretained ShopListViewController *vc = self;
    SFRefreshFooterView *footer = [SFRefreshFooterView footer];
    footer.scrollView = shopListTable;
    footer.beginRefreshingBlock = ^(SFRefreshBaseView *refreshView) {
        // 增加5条假数据
//        for (int i = 0; i<5; i++) {
//            int random = arc4random_uniform(1000000);
//            [vc->_fakeData addObject:[NSString stringWithFormat:@"随机数据---%d", random]];
//        }
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        int listAll=(count+1)*pageCount;
        if (shopListArray.count==listAll) {
            count=count+1;
            [self getShopList:nil];
        }
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)addHeader
{
    __unsafe_unretained ShopListViewController *vc = self;
    
    SFRefreshHeaderView *header = [SFRefreshHeaderView header];
    header.scrollView = shopListTable;
    header.beginRefreshingBlock = ^(SFRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
//        for (int i = 0; i<5; i++) {
//            int random = arc4random_uniform(1000000);
//            [vc->_fakeData insertObject:[NSString stringWithFormat:@"随机数据---%d", random] atIndex:0];
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startLocation" object:nil];
        count=0;
        //[self getLocaiton:nil];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(SFRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
       // NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(SFRefreshBaseView *refreshView, SFRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case SFRefreshStateNormal:
                //NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case SFRefreshStatePulling:
                //NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case SFRefreshStateRefreshing:
                //NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}
- (void)doneWithView:(SFRefreshBaseView *)refreshView
{
    // 刷新表格
    [shopListTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark - Navigation

//// In a story board-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
