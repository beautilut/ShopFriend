
//
//  UserEnterViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-1-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//
#import "ShopNaviBar.h"
#import "UserEnterViewController.h"
#import "TextFieldCell.h"
#import "NSObject_URLHeader.h"
#import "AppDelegate.h"
@interface UserEnterViewController ()
{
    TextFieldCell*nameCell;
    TextFieldCell*passwordCell;
}
@end

@implementation UserEnterViewController

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
    [self.navigationController.navigationBar setHidden:YES];
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    ShopNaviBar*navi=[[ShopNaviBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setCenter:CGPointMake(navi.frame.size.width/2, navi.frame.size.height-23)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"店友"];
    [label setTextColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [navi addSubview:label];
   
   UIButton*enterButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-45,24,40,40)];
    [enterButton addTarget:self action:@selector(userEnterTouchDown:) forControlEvents:UIControlEventTouchDown];
    [enterButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [enterButton setTitle:@"登录" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [navi addSubview:enterButton];
    
    UIButton*registUser=[[UIButton alloc] initWithFrame:CGRectMake(0, screenRect.size.height-60, screenRect.size.width, 30)];
    [registUser setTitle:@"注册" forState:UIControlStateNormal];
    [registUser setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [registUser addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:registUser];
    
    UITableView*table=[[UITableView alloc] initWithFrame:CGRectMake(0,0, screenRect.size.width,150) style:UITableViewStyleGrouped];
    [table setCenter:CGPointMake(screenRect.size.width/2, screenRect.size.height/4)];
    [table setDelegate:self];
    [table setDataSource:self];
    [table setScrollEnabled:NO];
    [self.view addSubview:table];
    [self.view setBackgroundColor:table.backgroundColor];
    
    [self.view bringSubviewToFront:navi];
    
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)registerUser:(id)sender
{
    [self done:nil];
    [self performSegueWithIdentifier:@"registerUser" sender:nil];
}
#pragma mark - barButton item method
-(void)selfDismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)userEnterTouchDown:(id)sender
{
    BOOL popAlter =NO;
    if (nameCell.textField.text.length==0) {
        popAlter=YES;
    }else if(passwordCell.textField.text.length==0)
    {
        popAlter=YES;
    }
    if (popAlter==YES) {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入账号/密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }else
    {
        NSURL*url=[NSURL URLWithString:userEnter];
        ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:nameCell.textField.text forKey:@"userName"];
        [request setPostValue:passwordCell.textField.text forKey:@"userPassword"];
        [request setCompletionBlock:^{
            SBJsonParser*parser=[[SBJsonParser alloc] init];
            NSDictionary*dic=[parser objectWithString:request.responseString];
            if ([[dic objectForKey:@"back"] integerValue]==1) {
                //登入成功
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"userID"] forKey:kXMPPmyJID];
                [[NSUserDefaults standardUserDefaults] setObject:passwordCell.textField.text forKey:kXMPPmyPassword];
                [[SFXMPPManager sharedInstance] connect];
                //[((AppDelegate*)[[UIApplication sharedApplication] delegate]) connect];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[InfoManager sharedInfo] getUserInfo];
                UIImage*image=[[InfoManager sharedInfo] getUserImage];//[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userImageKey];
                if (image==nil) {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadWithURL:[NSURL URLWithString:GET_USER_HEADIMAGE([dic objectForKey:@"userID"])] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                     {
                         [[InfoManager sharedInfo] saveUserImage:image];
                         //[[SDImageCache sharedImageCache] storeImage:image forKey:userImageKey toDisk:YES];
                     }];
                }
                NSLog(@"yes");
            }else{
                UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"错误" message:@"账号密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }

        }];
        [request setFailedBlock:^{
            UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"错误" message:@"登录失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
        }];
        [request startAsynchronous];
    }
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ShopCell"];
    // Configure the cell...
    TextFieldCell*cell=[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
    if (cell==nil) {
        NSArray*nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                cell=(TextFieldCell*)oneObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
        }
        if ([indexPath row]==0) {
            [cell.titleLabel setText:@"用户账号"];
            [cell.textField setPlaceholder:@"请输入手机号码/用户账号"];
            [cell.textField setDelegate:self];
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.textField setReturnKeyType:UIReturnKeyDone];
            nameCell=cell;
        }
        if ([indexPath row]==1) {
            [cell.titleLabel setText:@"密码"];
            [cell.textField setSecureTextEntry:YES];
            [cell.textField setPlaceholder:@"请出入密码"];
            [cell.textField setDelegate:self];
            [cell.textField setSecureTextEntry:YES];
            [cell.textField setReturnKeyType:UIReturnKeyDone];
            passwordCell=cell;
        }
    }
    return cell;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(IBAction)done:(id)sender
{
    [nameCell.textField resignFirstResponder];
    [passwordCell.textField resignFirstResponder];
}
@end
