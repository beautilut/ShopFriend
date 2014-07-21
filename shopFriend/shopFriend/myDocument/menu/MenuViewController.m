//
//  MenuViewController.m
//  ShopFriendForShop
//
//  Created by Beautilut on 14-2-11.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "MenuViewController.h"
#import "NSObject_URLHeader.h"
#import "CategoryCell.h"
#import "MenuCell.h"
#import "ShopNaviBar.h"
#import "GoodView.h"
@interface MenuViewController ()
{
    UIScrollView*categoryView;
    UITableView*menuTable;
    NSDictionary*menuData;
    NSMutableArray*categoryArray;
    UITableView*categoryTable;
    
}
@end

@implementation MenuViewController
@synthesize shopID;
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
    [self getMenu:shopID];
    categoryArray=[[NSMutableArray alloc] init];
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [navi addSubview:backImage];
    UIButton *navibutton=[[UIButton alloc] initWithFrame:CGRectMake(0,24,40, 40)];
    [navibutton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:navibutton];
//    UIBarButtonItem*leftButton=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backNavi:)];
//    self.navigationItem.leftBarButtonItem=leftButton;
    
    int titleHeight=navi.frame.size.height;
    menuTable=[[UITableView alloc] initWithFrame:CGRectMake(90, titleHeight, screenRect.size.width-90, screenRect.size.height-titleHeight) style:UITableViewStylePlain];
    [menuTable setDataSource:self];
    [menuTable setDelegate:self];

    //[menuTable setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:0.3]];
    [self.view addSubview:menuTable];
    categoryView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,titleHeight, 90, screenRect.size.height-titleHeight)];
    [categoryView setBackgroundColor:menuTable.backgroundColor];
    [self.view addSubview:categoryView];
    UIButton*button=[[UIButton alloc] initWithFrame:CGRectMake(5, 10, 80, 40)];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchButton:) forControlEvents:UIControlEventTouchDown];
//    [categoryView addSubview:button];
    categoryTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, menuTable.frame.size.height-50)];
    [categoryTable setDataSource:self];
    [categoryTable setDelegate:self];
    //[categoryTable setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:0.15]];
    [categoryTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [categoryView addSubview:categoryTable];
    [self.view bringSubviewToFront:navi];
	// Do any additional setup after loading the view.
}
-(void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchButton:(id)sender
{
    //searchButton
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - uichange
-(void)updateTableView:(id)sender
{
    [menuTable reloadData];
    [categoryTable reloadData];
}
#pragma mark - uitableView method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    if (tableView==menuTable) {
        return [categoryArray count];
    }
    if (tableView==categoryTable) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==menuTable) {
    NSDictionary*dic=[categoryArray objectAtIndex:section];
    NSString*key=[dic objectForKey:@"menu_categoryID"];
    return [[menuData objectForKey:key] count];
    }
    if (tableView==categoryTable) {
        return [categoryArray count];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==menuTable) {
        return 50;
    }
    if (tableView==categoryTable) {
        return 30;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==menuTable) {
    MenuCell*cell=(MenuCell*)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[MenuCell class]]) {
                cell=(MenuCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                NSArray*array=[self getCategoryData:indexPath];
                [cell setCellInfo:[array objectAtIndex:0] with:[array objectAtIndex:1] shop:shopID];
            }
        }

    }
    return cell;
    }
    if (tableView==categoryTable) {
        CategoryCell*cell=(CategoryCell*)[tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
        if (cell==nil) {
            NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"CategoryCell" owner:self options:nil];
            for (id oneObject in nib) {
                if ([oneObject isKindOfClass:[CategoryCell class]]) {
                    cell=(CategoryCell*)oneObject;
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    NSDictionary*dic=[categoryArray objectAtIndex:[indexPath row]];
                    [cell setName:[dic objectForKey:@"menu_category"]];
                }
            }
            
        }
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==menuTable) {
        return 20.0f;
    }
    if (tableView==categoryTable) {
        return 0.01f;
    }
    return 0.01f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==menuTable) {
    UIView*headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 20)];
    [headView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:0.3]];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10, 1, 230, 18)];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    //[label setTextColor:[UIColor colorWithRed:202.0/255.0 green:205.0/255.0 blue:229.0/255.0 alpha:1.0]];
    [label setTextColor:[UIColor orangeColor]];
    NSDictionary*dic=[categoryArray objectAtIndex:section];
    [label setText:[dic objectForKey:@"menu_category"]];
    [headView addSubview:label];
    return headView;
    }
    if (tableView==categoryTable) {
        return nil;
    }
    return nil;
}
-(NSArray*)getCategoryData:(NSIndexPath*)indexPath
{
    NSDictionary*sectionCategory=[categoryArray objectAtIndex:[indexPath section]];
    NSString*key=[sectionCategory objectForKey:@"menu_categoryID"];
    NSArray*categoryList=[menuData objectForKey:key];
    NSMutableDictionary*dataDic=[categoryList objectAtIndex:[indexPath row]];
    NSArray*array=[NSArray arrayWithObjects:dataDic,key, nil];
    return array;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==categoryTable) {
        
        NSDictionary*dic=[categoryArray objectAtIndex:[indexPath row]];
        NSString*key=[dic objectForKey:@"menu_categoryID"];
        if ([[menuData objectForKey:key] count]>0) {
            [menuTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[indexPath row]] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        for (int i=0; i<[categoryTable.visibleCells count]; i++) {
            CategoryCell*cell=[categoryTable.visibleCells objectAtIndex:i];
            if (i==[indexPath row]) {
                [cell.nameLabel setTextColor:[UIColor redColor]];
            }else
            {
            [cell.nameLabel setTextColor:[UIColor orangeColor]];
            }
        }
    }
    if (tableView==menuTable) {
         NSArray*array=[self getCategoryData:indexPath];
        [[GoodView sharedGoodView] setMenuArray:array withShopID:shopID ];
        [[GoodView sharedGoodView] setBlurImage:[self rn_screenshot]];
        [[GoodView sharedGoodView] selfsetBack:nil];
        [[GoodView sharedGoodView] show];
    }
}
- (UIImage *)rn_screenshot {
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // helps w/ our colors when blurring
    // feel free to adjust jpeg quality (lower = higher perf)
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}
#pragma mark - asi method
-(void)getMenu:(NSString*)shopID
{
    NSURL*url=[NSURL URLWithString:menuGetURL];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:shopID forKey:@"shopID"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if ([[dic objectForKey:@"kind"] isEqualToString:@"showMenu"]) {
            menuData=dic;
            categoryArray=[menuData objectForKey:@"category"];
            [self performSelectorOnMainThread:@selector(updateTableView:) withObject:nil waitUntilDone:YES];
        }
    }];
    [request setFailedBlock:^{
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"错误" message:@"获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }];
    [request startAsynchronous];
}
@end
