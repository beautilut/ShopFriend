//
//  TalkListViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-1-15.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "TalkListViewController.h"
#import "ShopNaviBar.h"
#import "TalkCell.h"
#import "SFTalkViewController.h"
#import "SFRefreshFooterView.h"
#define pageCount 15;
@interface TalkListViewController ()
{
    UITableView*talkList;
    NSArray*messageArray;
    int count;
    
    SFRefreshFooterView * _footer;
}
@end

@implementation TalkListViewController

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
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    ShopNaviBar*navi=[[ShopNaviBar alloc] init];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setText:@"店友"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    
    //定制tabbar
    ShopTabBar*tabbar=[[ShopTabBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0) withButtonID:1];
    [tabbar setDelegate:self];
    [self.view addSubview:tabbar];
    
    //tableViewCell
    talkList=[[UITableView alloc] initWithFrame:CGRectMake(0, navi.frame.origin.y+navi.frame.size.height, screenBounds.size.width, screenBounds.size.height-navi.frame.size.height-tabbar.frame.size.height)];
    [talkList setBackgroundColor:[UIColor clearColor]];
    [talkList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [talkList setDelegate:self];
    [talkList setDataSource:self];
    [self.view addSubview:talkList];
    [self.view bringSubviewToFront:navi];
    [self.view bringSubviewToFront:tabbar];
    count=0;
    [self refresh];
    [self addFooter];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTalkView:) name:@"showTalkView" object:nil];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self refresh];
}
-(void)newMsgCome:(NSNotification *)notifacation
{
    //[self.tabBarController.tabBarItem setBadgeValue:@"1"];
    [self refresh];
}
-(void)refresh
{
    messageArray=[MessageModel fetchRecentChatByPage:count];
    [talkList reloadData];
}
- (void)addFooter
{
    __unsafe_unretained TalkListViewController *vc = self;
    SFRefreshFooterView *footer = [SFRefreshFooterView footer];
    footer.scrollView = talkList;
    footer.beginRefreshingBlock = ^(SFRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此2秒后才调用）
        int listCount=count*pageCount;
        if (messageArray.count==listCount) {
            count=count+1;
        }
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}
- (void)doneWithView:(SFRefreshBaseView *)refreshView
{
    // 刷新表格
    [talkList reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
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
#pragma mark - tableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ShopCell"];
    // Configure the cell...
    TalkCell*cell=[tableView dequeueReusableCellWithIdentifier:@"TalkCell"];
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"TalkCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[TalkCell class]]) {
                cell=(TalkCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                MessageShopUnionObject*aUnion=[messageArray objectAtIndex:indexPath.row];
                ShopObject*aShop=aUnion.shop;
                MessageModel*aMessage=aUnion.message;
                NSURL*url=[NSURL URLWithString:SHOP_LOGO_URL(aShop.shopID)];
                [cell.talkView setImageWithURL:url];
                [cell.name setText:aShop.shopName];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setAMSymbol:@"上午"];
                [formatter setPMSymbol:@"下午"];
                [formatter setDateFormat:@"a HH:mm"];
                [cell.data setText:[formatter stringFromDate:aMessage.messageDate]];
                if ([aMessage.messageType intValue]==1) {
                    [cell.content setText:@"图片"];
                }else
                {
                [cell.content setText:aMessage.messageContent];
                }
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageShopUnionObject*aUnion=[messageArray objectAtIndex:indexPath.row];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SFTalkViewController*talkView=[mainStoryboard instantiateViewControllerWithIdentifier:@"SFTalkView"];
    [talkView setChatShop:aUnion.shop];
    [self.navigationController pushViewController:talkView animated:YES];
}
-(void)showTalkView:(id)sender
{
    SFTalkViewController*talkView=[sender object];
    [self.navigationController pushViewController:talkView animated:YES];
}
@end
