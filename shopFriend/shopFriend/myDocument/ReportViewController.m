//
//  ReportViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-4-13.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ReportViewController.h"
#import "ShopNaviBar.h"
@interface ReportViewController ()
{
    NSIndexPath*path;
    ShopObject*theShop;
    UIAlertView*cancelAlter;
    UIAlertView*sureAlter;
    
    UIScrollView*backScroller;
    UITextView*infoView;
}
@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setShop:(ShopObject *)shop
{
    theShop=shop;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"投诉"];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [navi addSubview:backImage];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0,24,40, 40)];
    [button addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:button];
    UIButton*rightButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-55,24,60,40)];
    [rightButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchDown];
    [rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [navi addSubview:rightButton];
    
    backScroller=[[UIScrollView alloc] initWithFrame:CGRectMake(0, navi.frame.size.height, screenBounds.size.width, screenBounds.size.height-navi.frame.size.height)];
    [backScroller setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]];
    [self.view addSubview:backScroller];
    UITableView*table=[[UITableView alloc] initWithFrame:CGRectMake(0,0,backScroller.frame.size.width,backScroller.frame.size.height) style:UITableViewStyleGrouped];
    [table setDelegate:self];
    [table setDataSource:self];
    [backScroller addSubview:table];
    
    infoView=[[UITextView alloc] initWithFrame:CGRectMake(20, 300, table.frame.size.width-40, 200)];
    infoView.layer.borderWidth=1.0f;
    infoView.layer.borderColor=[UIColor orangeColor].CGColor;
    infoView.layer.masksToBounds = YES;
    infoView.layer.cornerRadius = 6.0;
    [infoView setFont:[UIFont systemFontOfSize:15.0f]];
    [infoView setHidden:YES];
    [backScroller addSubview:infoView];
    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}
-(void)backNavi:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[[UITableViewCell alloc] init];
    if (indexPath.section==0&&indexPath.row==0) {
        [cell.textLabel setText:@"色情"];
    }
    if (indexPath.section==0&&indexPath.row==1) {
        [cell.textLabel setText:@"欺诈"];
    }
    if (indexPath.section==0&&indexPath.row==2) {
        [cell.textLabel setText:@"骚扰"];
    }
    if (indexPath.section==0&&indexPath.row==3) {
        [cell.textLabel setText:@"侵权"];
    }
    if (indexPath.section==0&&indexPath.row==4) {
        [cell.textLabel setText:@"其他"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UITableViewCell *cell in tableView.visibleCells) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    path=indexPath;
    if (indexPath.row==4) {
        [infoView setHidden:NO];
        [tableView resignFirstResponder];
        [infoView becomeFirstResponder];
        [backScroller setContentSize:CGSizeMake(backScroller.frame.size.width, backScroller.frame.size.height+250)];
        [backScroller setContentOffset:CGPointMake(0,250) animated:YES];
    }else
    {
        [infoView setHidden:YES];
        [infoView resignFirstResponder];
        [tableView becomeFirstResponder];
        [backScroller setContentSize:CGSizeMake(0, backScroller.frame.size.height)];
        [backScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    }

}
-(void)send:(id)sender
{
    if (path==nil) {
        cancelAlter=[[UIAlertView alloc] initWithTitle:@"" message:@"请选择投诉原因" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [cancelAlter show];
    }else
    {
        NSURL*url=[NSURL URLWithString:reportURL];
        ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
        NSString*userID=[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
        [request setPostValue:userID forKey:@"userID"];
        [request setPostValue:theShop.shopID forKey:@"shopID"];
        [request setPostValue:[NSNumber numberWithInteger:[path row]] forKey:@"report"];
        if ([path row]==4) {
            [request setPostValue:infoView.text forKey:@"reportInfo"];
        }
        [request startAsynchronous];
        sureAlter=[[UIAlertView alloc] initWithTitle:@"感谢投诉" message:@"谢谢您！店友坚决反对色情、欺诈、侵权信息，我们会认真处理你的投诉，维护绿色、健康的网络环境" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
        [sureAlter show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==sureAlter) {
        if (buttonIndex==0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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
