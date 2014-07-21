//
//  BirthdayViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-19.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "BirthdayViewController.h"
#import "ShopNaviBar.h"
@interface BirthdayViewController ()
{
    UIDatePicker*datePicker;
}
@end

@implementation BirthdayViewController
@synthesize oldDate;
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
    
    backImage=[[UIImageView alloc] initWithFrame:CGRectMake(navi.frame.size.width-35, 32, 20, 20)];
    [backImage setImage:[UIImage imageNamed:@"check"]];
    [navi addSubview:backImage];
    UIButton*checkButton=[[UIButton alloc] initWithFrame:CGRectMake(navi.frame.size.width-40,24,40,40)];
    [checkButton addTarget:self action:@selector(infoChange:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:checkButton];
    
    datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height,screenBounds.size.width , 400)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:datePicker];
    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
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
-(void)infoChange:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString*old=[dateFormatter stringFromDate:oldDate];
    NSString*new=[dateFormatter stringFromDate:datePicker.date];
    if ([old isEqual:new]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else
    {
        NSURL*url=[NSURL URLWithString:userInfoChange];
        ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:@"user_BIRTHDAY" forKey:@"key"];
        [request setPostValue:new forKey:@"data"];
        NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
        [request setPostValue:hostID forKey:@"userID"];
        [request setCompletionBlock:^{
            SBJsonParser*parser=[[SBJsonParser alloc] init];
            NSDictionary*dic=[parser objectWithString:request.responseString];
            if ([[dic objectForKey:@"result"] intValue]==1) {
                [HostModel updateHost:@"hostBirthday" with:new];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tableRefresh" object:nil];
            }
        }];
        [request setFailedBlock:^{
            
        }];
        [request startAsynchronous];
        
        [self.navigationController popViewControllerAnimated:YES];
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
