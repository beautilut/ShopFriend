//
//  FeedBackViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-24.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "FeedBackViewController.h"
#import "ShopNaviBar.h"
@interface FeedBackViewController ()
{
    UITextView*feedBackTextView;
    UILabel*placeLabel;
}
@end

@implementation FeedBackViewController

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
    
    feedBackTextView=[[UITextView alloc] initWithFrame:CGRectMake(10,naviHight+10,screenBounds.size.width-20,200)];
    feedBackTextView.layer.borderWidth=1.0f;
    feedBackTextView.layer.borderColor=[UIColor blackColor].CGColor;
    feedBackTextView.layer.masksToBounds = YES;
    feedBackTextView.layer.cornerRadius = 6.0;
    [feedBackTextView setFont:[UIFont systemFontOfSize:15.0f]];
    [feedBackTextView setDelegate:self];
    [self.view addSubview:feedBackTextView];
    placeLabel=[[UILabel alloc] initWithFrame:CGRectMake(13, naviHight+13, screenBounds.size.width-50,30)];
    [placeLabel setText:@"如有不足之处请指出，我们虚心整改。"];
    [placeLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [placeLabel setTextColor:[UIColor grayColor]];
    [placeLabel setAlpha:0.7f];
    [self.view addSubview:placeLabel];
    
    button=[[UIButton alloc] initWithFrame:CGRectMake(10, naviHight+250, screenBounds.size.width-20, 40)];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitle:@"反馈" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(feedBack:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    
    [self.view bringSubviewToFront:navi];
    // Do any additional setup after loading the view.
}
-(void)backNavi:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)feedBack:(id)sender
{
    if ([feedBackTextView.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSURL*url=[NSURL URLWithString:shopFriendFeedBack];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    NSString*hostID=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    [request setPostValue:hostID forKey:@"userID"];
    [request setPostValue:feedBackTextView.text forKey:@"feedBack"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*dic=[parser objectWithString:request.responseString];
        if ([[dic objectForKey:@"back"] intValue]==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [request setFailedBlock:^{
        UIAlertView*alter=[[UIAlertView alloc] initWithTitle:@"错误" message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
        //[self.navigationController popViewControllerAnimated:YES];
    }];
    [request startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    if (feedBackTextView.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            placeLabel.hidden=NO;//隐藏文字
        }else{
            placeLabel.hidden=YES;
        }
    }else{//textview长度不为0
        if (feedBackTextView.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                placeLabel.hidden=NO;
            }else{//不是删除
                placeLabel.hidden=YES;
            }
        }else{//长度不为1时候
            placeLabel.hidden=YES;
        }
    }
    return YES;
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
