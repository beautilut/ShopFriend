//
//  ShopSettingInfoViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-4-13.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopSettingInfoViewController.h"
#import "ShopNaviBar.h"
#import "ReportViewController.h"
@interface ShopSettingInfoViewController ()
{
    ShopObject*settingShop;
    UISwitch*acceptSwitch;
    UISwitch*attentionSwitch;
}
@end

@implementation ShopSettingInfoViewController

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
    
    UITableView*table=[[UITableView alloc] initWithFrame:CGRectMake(0,navi.frame.size.height, screenBounds.size.width, screenBounds.size.height-navi.frame.size.height) style:UITableViewStyleGrouped];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];
    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}
-(void)setShop:(ShopObject *)shop
{
    settingShop=shop;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0 ) {
        return 2;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return 1;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[[UITableViewCell alloc] init];
    if (indexPath.section==0&&indexPath.row==0) {
        [cell.textLabel setText:@"关注"];
        attentionSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, cell.frame.size.height-10)];
        [attentionSwitch setCenter:CGPointMake(cell.frame.size.width-40, cell.frame.size.height/2)];
        if ([ShopObject flagShopByID:settingShop.shopID]>0) {
            [attentionSwitch setOn:YES];
        }
        [cell addSubview:attentionSwitch];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [attentionSwitch addTarget:self action:@selector(payAttention:) forControlEvents:UIControlEventValueChanged];
    }
    if (indexPath.section==0&&indexPath.row==1) {
        [cell.textLabel setText:@"接受推送消息"];
        acceptSwitch=[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, cell.frame.size.height-10)];
        [acceptSwitch setCenter:CGPointMake(cell.frame.size.width-40, cell.frame.size.height/2)];
        if ([ShopObject flagShopByID:settingShop.shopID]==2) {
            [acceptSwitch setOn:YES];
        }
        [cell addSubview:acceptSwitch];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [acceptSwitch addTarget:self action:@selector(achievePushInfo:) forControlEvents:UIControlEventValueChanged];
    }
    if (indexPath.section==1&&indexPath.row==0) {
        [cell.textLabel setText:@"清除历史消息"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.section==2&&indexPath.row==0) {
        [cell.textLabel setText:@"举报"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==0) {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:nil message:@"是否清楚历史消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }
    if (indexPath.section==2&&indexPath.row==0) {
        ReportViewController*report=[[ReportViewController alloc] init];
        [self presentViewController:report animated:YES completion:nil];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex==1) {
            [MessageModel cleanMessageWithShop:[NSString stringWithFormat:@"%@shop",settingShop.shopID]];
        }
}
#pragma mark - switch
-(void)payAttention:(id)sender
{
    UISwitch*switchButton=(UISwitch*)sender;
    BOOL isbuttonOn=[switchButton isOn];
    if (isbuttonOn==YES) {
        [self updateState:1];
    }else
    {
        [acceptSwitch setOn:NO];
        [self updateState:0];
    }
}
-(void)achievePushInfo:(id)sender
{
    UISwitch*switchButton=(UISwitch*)sender;
    BOOL isbuttonOn=[switchButton isOn];
    if (isbuttonOn==YES) {
        [attentionSwitch setOn:YES];
        [self updateState:2];
    }else
    {
        [self updateState:1];
    }
}
-(void)updateState:(int)flag
{
    NSURL*url=[NSURL URLWithString:shopFlagUpdate];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    NSString*userID=[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID];
    [request setPostValue:userID forKey:@"userID"];
    [request setPostValue:settingShop.shopID forKey:@"shopID"];
    [request setPostValue:[NSNumber numberWithInt:flag] forKey:@"flag"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*rootDic=[parser objectWithString:request.responseString];
        if ([[rootDic objectForKey:@"back"] integerValue]==1) {
            [ShopObject updateShopFlag:settingShop.shopID withFlag:[NSNumber numberWithInt:flag]];
        }
        if (flag==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"attentionChange" object:[NSNumber numberWithInt:0]];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"attentionChange" object:[NSNumber numberWithInt:1]];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"InfoGetFail");
    }];
    [request startAsynchronous];
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
