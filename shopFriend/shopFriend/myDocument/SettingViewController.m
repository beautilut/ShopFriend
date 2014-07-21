//
//  SettingViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-20.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SettingViewController.h"
#import "InfoCell.h"
#import "ShopNaviBar.h"
@interface SettingViewController ()
{
    UITableView*settingTable;
    UIAlertView*quitAlter;
    UIAlertView*cacheAlter;
}
@end

@implementation SettingViewController

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
    [label setText:@"设置"];
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
    settingTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height) style:UITableViewStyleGrouped];
    [settingTable setDelegate:self];
    [settingTable setDataSource:self];
    float topInset = self.navigationController.navigationBar.frame.size.height+20;
    settingTable.contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    [self.view addSubview:settingTable];

    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)quit:(id)sender
{
    quitAlter=[[UIAlertView alloc] initWithTitle:@"" message:@"是否退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [quitAlter show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==quitAlter) {
        if (buttonIndex==1) {
            [[SFXMPPManager  sharedInstance] disconnect];
            [InfoManager sharedInfo].host =nil;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //UserEnterViewController*userEnterView=[mainStoryboard instantiateViewControllerWithIdentifier:@"userEnter"];
            UINavigationController*navi=[mainStoryboard instantiateViewControllerWithIdentifier:@"userEnter"];
            [self  presentViewController:navi animated:NO completion:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"quitNotification" object:nil];
        }
    }
    if (alertView==cacheAlter) {
        if (buttonIndex==1) {
            //UIImage*headImage=[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageKey];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            //[[SDImageCache sharedImageCache] storeImage:headImage forKey:userImageKey];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0 ) {
        return 1;
    }
    if (section==1) {
        return 1;
    }
    if (section==2) {
        return 3;
    }
    if (section==3) {
        return 1;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell=[[UITableViewCell alloc] init];
    }
    if ([indexPath section]==0&&indexPath.row==0) {
        [cell.textLabel setText:@"修改密码"];
    }
    if ([indexPath section]==1&&indexPath.row==0) {
        [cell.textLabel setText:@"清除缓存"];
    }
    if ([indexPath section]==2&&indexPath.row==0) {
        [cell.textLabel setText:@"反馈"];
    }
    if ([indexPath section]==2&&indexPath.row==1) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[InfoCell class]]) {
                InfoCell*cell=(InfoCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                [cell.titleCell setText:@"版本"];
                NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
                NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
                [cell.detailCell setText:localVersion];
                return cell;
            }
        }
    }
    if ([indexPath section]==2&&indexPath.row==2) {
        [cell.textLabel setText:@"关于店友"];
    }
    if ([indexPath section]==3&&indexPath.row==0) {
        cell.backgroundView=[[UIView alloc] initWithFrame:CGRectZero];
        [cell setBackgroundColor:[UIColor clearColor]];
        UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [backView setBackgroundColor:[UIColor redColor]];
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,backView.frame.size.width,backView.frame.size.height)];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"退出"];
        [backView addSubview:label];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:backView];
        return cell;
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0&&indexPath.row==0) {
        [self performSegueWithIdentifier:@"password" sender:nil];
    }
    if ([indexPath section]==1&&indexPath.row==0)
    {
        float x=[[SDImageCache sharedImageCache] getSize];
        float kb=x/1024;
        float mb=kb/1024;
        NSString*string=[NSString stringWithFormat:@"%fMB",mb];
        cacheAlter=[[UIAlertView alloc] initWithTitle:@"是否清除缓存" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [cacheAlter show];
    }
    if ([indexPath section]==2&&indexPath.row==0) {
        [self performSegueWithIdentifier:@"feedback" sender:nil];
    }
    if ([indexPath section]==3&&indexPath.row==0)
    {
        [self quit:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
