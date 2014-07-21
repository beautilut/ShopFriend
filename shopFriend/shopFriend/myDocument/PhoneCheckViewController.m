//
//  PhoneCheckViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-2-10.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "PhoneCheckViewController.h"
#import "TextFieldCell.h"
#import "UserRegisterViewController.h"
#import "ShopNaviBar.h"
@interface PhoneCheckViewController ()
{
    UITableView*tableView;
    NSMutableDictionary*sendDic;
    TextFieldCell*phoneText;
    TextFieldCell*invitationText;
    UIButton*invitationButton;
    int secondsCountDown;
    NSTimer*countDown;
}
@end

@implementation PhoneCheckViewController

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
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    sendDic=[[NSMutableDictionary alloc] init];
    
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
    
    UIButton*rightButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-65,24,60,40)];
    [rightButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchDown];
    [rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [navi addSubview:rightButton];
    
    UIButton*leftButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 24, 40, 40)];
    [leftButton addTarget:self action:@selector(backNavi:) forControlEvents:UIControlEventTouchDown];
    [leftButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [navi addSubview:leftButton];

    
    //tableView
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, screenRect.size.width,150) style:UITableViewStyleGrouped];
    [tableView setCenter:CGPointMake(screenRect.size.width/2, screenRect.size.height/4)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setScrollEnabled:NO];
    [self.view addSubview:tableView];
    [self.view setBackgroundColor:tableView.backgroundColor];
    
    invitationButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250,50)];
    [invitationButton setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
    [invitationButton setTitle:@"获取激活码" forState:UIControlStateNormal];
    [invitationButton addTarget:self action:@selector(getInvitationNumber:) forControlEvents:UIControlEventTouchDown];
    [invitationButton setCenter:CGPointMake(screenRect.size.width/2,tableView.frame.size.height+navi.frame.size.height+30)];
    [self.view addSubview:invitationButton];
    [self.view bringSubviewToFront:navi];
	// Do any additional setup after loading the view.
}
-(IBAction)done:(id)sender
{
    [phoneText.textField  resignFirstResponder];
    [invitationText.textField resignFirstResponder];
}
-(void)getInvitationNumber:(id)sender
{
    if ([[InfoManager sharedInfo] checkPhone:phoneText.textField.text]) {
        secondsCountDown=60;
        countDown=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [self getInvitation];
        [invitationButton setUserInteractionEnabled:NO];
        [invitationButton setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:0.5f]];
        [self done:nil];
    }else
    {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"手机号码输入错误" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
    }
    
}
-(void)timeFireMethod
{
    secondsCountDown--;
    if (secondsCountDown==1) {
        [countDown invalidate];
        [invitationButton setUserInteractionEnabled:YES];
        [invitationButton setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:173.0/255.0 blue:220.0/255.0 alpha:1.0f]];
        [invitationButton setTitle:@"获取激活码" forState:UIControlStateNormal];
        return;
    }
    NSString*string=[NSString stringWithFormat:@"请等待 %d 秒",secondsCountDown];
    [invitationButton setTitle:string forState:UIControlStateNormal];
}
-(void)getInvitation
{
    NSURL*url=[NSURL URLWithString:webInvitationGet];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:phoneText.textField.text forKey:@"phoneNumber"];
    [request setCompletionBlock:^{
        NSData*data=[request responseData];
        NSError*error;
        NSArray*array=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"%@",array);
    }];
    [request setFailedBlock:^{
        NSLog(@"fail");
    }];
    [request startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RegisterMain"]) {
        
        [[segue destinationViewController] getPhoneInfo:sendDic];
    }
}
#pragma mark - navi methods
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)next:(id)sender
{
    if ([phoneText.textField.text isEqualToString:@""]) {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    [sendDic setObject:phoneText.textField.text forKey:@"userPhone"];
    if ([invitationText.textField.text isEqualToString:@""]) {
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入邀请码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    [phoneText.textField setEnabled:NO];
    [invitationText.textField setEnabled:NO];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:invitation]];
    [request setPostValue:invitationText.textField.text forKey:@"invitationNumber"];
    [request setPostValue:phoneText.textField.text forKey:@"phoneNumber"];
    [request setCompletionBlock:^{
        [phoneText.textField setEnabled:YES];
        [invitationText.textField setEnabled:YES];
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if ([[dic objectForKey:@"result"] intValue]==1) {
            [self performSegueWithIdentifier:@"RegisterMain" sender:nil];
        }else{
            UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"错误" message:[dic objectForKey:@"note"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
            return;
        }
    }];
    [request setFailedBlock:^{
        [phoneText.textField setEnabled:YES];
        [invitationText.textField setEnabled:YES];
    }];
    [request startAsynchronous];
    
}
#pragma mark - tableViewDelegate
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
            [cell.titleLabel setText:@"手机号码"];
            [cell.textField setPlaceholder:@"请输入手机号码"];
            [cell.textField setDelegate:self];
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.textField setReturnKeyType:UIReturnKeyDone];
            phoneText=cell;
        }
        if ([indexPath row]==1) {
            [cell.titleLabel setText:@"邀请码"];
            [cell.textField setSecureTextEntry:YES];
            [cell.textField setPlaceholder:@"请输入邀请码"];
            [cell.textField setDelegate:self];
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad];
            [cell.textField setReturnKeyType:UIReturnKeyDone];
            invitationText=cell;
        }
    }
    return cell;
}
#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==phoneText.textField) {
        if (range.location>10) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - check

@end
