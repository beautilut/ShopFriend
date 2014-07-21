//
//  SexViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-19.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SexViewController.h"
#import "ShopNaviBar.h"
@interface SexViewController ()
{
    UITableView*sexTable;
}
@end

@implementation SexViewController
@synthesize hostSex;
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
    UIImageView*backImage=[[UIImageView alloc] initWithFrame:CGRectMake(5,32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [navi addSubview:backImage];
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0,24,40, 40)];
    [button addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:button];
    
    sexTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height) style:UITableViewStyleGrouped];
    float topInset = self.navigationController.navigationBar.frame.size.height+20;
    sexTable.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    [sexTable setDelegate:self];
    [sexTable setDataSource:self];
    [self.view addSubview:sexTable];
    // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:navi];
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
#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"HeadImageCell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] init];
    }
    if (indexPath.row==0) {
        [cell.textLabel setText:@"男"];
    }
    if (indexPath.row==1) {
        [cell.textLabel setText:@"女"];
    }
    if (hostSex !=[NSNull null]) {
        if (indexPath.row==[hostSex intValue]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cell setSelected:NO];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber*sexNumber;
    if (indexPath.row==0) {
        sexNumber=[NSNumber numberWithInt:0];
    }else
    {
        sexNumber=[NSNumber numberWithInt:1];
    }
        NSURL*url=[NSURL URLWithString:userInfoChange];
        ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:@"user_sex" forKey:@"key"];
        [request setPostValue:[sexNumber stringValue] forKey:@"data"];
        NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
        [request setPostValue:hostID forKey:@"userID"];
        [request setCompletionBlock:^{
            SBJsonParser*parser=[[SBJsonParser alloc] init];
            NSDictionary*dic=[parser objectWithString:request.responseString];
            if ([[dic objectForKey:@"result"] intValue]==1) {
                [HostModel updateHost:@"hostSex" with:sexNumber];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tableRefresh" object:nil];
            }
        }];
        [request setFailedBlock:^{
            
        }];
        [request startAsynchronous];
    
    [self.navigationController popViewControllerAnimated:YES];

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
