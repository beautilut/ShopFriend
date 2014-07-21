//
//  ChangeInfoViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-2-27.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ChangeInfoViewController.h"
#import "ShopNaviBar.h"
@interface ChangeInfoViewController ()
{
    NSDictionary*infoDic;
}
@end

@implementation ChangeInfoViewController
@synthesize infoField;
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
    
    UIView*backView=[[UIView alloc] initWithFrame:CGRectMake(0, 20+self.navigationController.navigationBar.frame.size.height+20, screenBounds.size.width, 50)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backView];
    infoField=[[UITextField alloc] initWithFrame:CGRectMake(0,0 , screenBounds.size.width, 50)];
    [infoField setTextAlignment:NSTextAlignmentCenter];
    [infoField setDelegate:self];
    [infoField setFont:[UIFont systemFontOfSize:20.0f]];
    [infoField setReturnKeyType:UIReturnKeyDone];
    if ([infoDic objectForKey:@"old"]!=[NSNull null]) {
        [infoField setText:[infoDic objectForKey:@"old"]];
    }
    [backView addSubview:infoField];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:245.0/255.0 alpha:1.0]];
    
    
    backImage=[[UIImageView alloc] initWithFrame:CGRectMake(navi.frame.size.width-35, 32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"check"]];
    [navi addSubview:backImage];
    UIButton*checkButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-40,24,40,40)];
    [checkButton addTarget:self action:@selector(infoChange:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:checkButton];
    //!! xxbutton
    button=[[UIButton alloc] initWithFrame:CGRectMake(screenBounds.size.width-30, 0, 30, 30)];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(textFieldClean:) forControlEvents:UIControlEventTouchDown];
    //[backView addSubview:button];
    
	// Do any additional setup after loading the view.
    [self.view bringSubviewToFront:navi];
}
-(IBAction)done:(id)sender
{
    [infoField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textFieldClean:(id)sender
{
    [infoField setText:@""];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //[self infoChange:nil];
    return YES;
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)infoChange:(id)sender
{
    if (![infoField.text isEqualToString:[infoDic objectForKey:@"old"]]) {
        if ([[infoDic objectForKey:@"web"] isEqualToString:@"user_email"]) {
            if (![self isValidateEmail:infoField.text]) {
                UIAlertView*alter=[[UIAlertView alloc] initWithTitle:nil message:@"邮箱格式不正确" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alter show];
                return;
            }
        }
        NSURL*url=[NSURL URLWithString:userInfoChange];
        ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[infoDic objectForKey:@"web"] forKey:@"key"];
        [request setPostValue:infoField.text forKey:@"data"];
        [request setPostValue:[infoDic objectForKey:@"userID"] forKey:@"userID"];
        [request setCompletionBlock:^{
            SBJsonParser*parser=[[SBJsonParser alloc] init];
            NSDictionary*dic=[parser objectWithString:request.responseString];
            if ([[dic objectForKey:@"result"] intValue]==1) {
            [HostModel updateHost:[infoDic objectForKey:@"local"] with:infoField.text];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tableRefresh" object:nil];
            }
        }];
        [request setFailedBlock:^{
            
        }];
        [request startAsynchronous];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getInfo:(NSDictionary *)dic
{
    infoDic=dic;
}
-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}
@end
