//
//  SFShopInfoViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-3-1.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SFShopInfoViewController.h"
#import <Accelerate/Accelerate.h>
@interface SFShopInfoViewController ()
{
    NSDictionary*shopInfo;
    UILabel*nameLabel;
    UITextView*statuLabel;
    UILabel*locationLabel;
    UILabel*phoneLabel;
    UIView*phoneView;
    UIView*localView;
    UILabel*categoryLabel;
    //UIButton*phoneButton;
    UILabel*lastLaunch;
    
    UIAlertView*phoneAlter;
    NSMutableArray*colorArray;
}
@end

@implementation SFShopInfoViewController
@synthesize shopID;
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
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgV setImage:[self blurryImage:[UIImage imageNamed:@"2222"] withBlurLevel:0.8f]];
    [self.view addSubview:imgV];
    nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 70, 200, 70)];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [self.view addSubview:nameLabel];
    
    //statuLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,175, 200, 150)];
    statuLabel=[[UITextView alloc]  initWithFrame:CGRectMake(10, 175, 200,230)];
    [statuLabel setEditable:NO];
    [statuLabel setSelectable:NO];
    [statuLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [statuLabel setBackgroundColor:[UIColor clearColor]];
    [statuLabel setTextColor:[UIColor whiteColor]];
    [statuLabel setTextAlignment:NSTextAlignmentCenter];
    //[statuLabel setNumberOfLines:20.0f];
    [self.view addSubview:statuLabel];
    
    categoryLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 145, 200, 20)];
    [categoryLabel setTextColor:[UIColor whiteColor]];
    [categoryLabel setTextAlignment:NSTextAlignmentCenter];
    [categoryLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.view addSubview:categoryLabel];
    
    localView=[[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-150, 220, 40)];
    [self.view addSubview:localView];
    UIImageView*imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [imageView setImage:[UIImage imageNamed:@"location"]];
    [imageView setCenter:CGPointMake(25, localView.frame.size.height/2)];
    [localView addSubview:imageView];
    locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 160,60)];
    [locationLabel setTextColor:[UIColor whiteColor]];
    [locationLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [locationLabel setNumberOfLines:15];
    [locationLabel setTextAlignment:NSTextAlignmentLeft];
    [locationLabel setCenter:CGPointMake(140, localView.frame.size.height/2)];
    [localView addSubview:locationLabel];
    
    phoneView=[[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-100, 220, 40)];
    [self.view addSubview:phoneView];
    UIButton* phoneButton =[[UIButton alloc] initWithFrame:CGRectMake(0 ,0, 200, 40)];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchDown];
    [phoneView addSubview:phoneButton];
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"phone"]];
    [imageView setCenter:CGPointMake(25, phoneView.frame.size.height/2)];
    [phoneView addSubview:imageView];
    phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 160, 40)];
    [phoneLabel setTextAlignment:NSTextAlignmentCenter];
    [phoneLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [phoneLabel setTextColor:[UIColor whiteColor]];
    [phoneLabel setCenter:CGPointMake(140, phoneView.frame.size.height/2)];
    [phoneView addSubview:phoneLabel];
    
   
    
    lastLaunch=[[UILabel alloc] initWithFrame:CGRectMake(10, 350, 200, 30)];
    [lastLaunch setTextColor:[UIColor whiteColor]];
    [lastLaunch  setTextAlignment:NSTextAlignmentCenter];
    [lastLaunch  setFont:[UIFont systemFontOfSize:14.0f]];
    //[self.view addSubview:lastLaunch];
    [self getShopInfo];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getShopInfo
{
    NSURL*url=[NSURL URLWithString:GetShopInfo];
    ASIFormDataRequest*request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:shopID forKey:@"shopID"];
    [request setCompletionBlock:^{
        SBJsonParser*parser=[[SBJsonParser alloc] init];
        NSDictionary*rootDic=[parser objectWithString:request.responseString];
        shopInfo=[[rootDic objectForKey:@"data"] objectAtIndex:0];
        [self setInfo];
    }];
    [request setFailedBlock:^{
        NSLog(@"InfoGetFail");
    }];
    [request startAsynchronous];
}
-(void)setInfo
{
    colorArray=[[NSMutableArray alloc] initWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor brownColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor cyanColor],nil];
    [nameLabel setText:[shopInfo objectForKey:@"shop_name"]];
    if ([[shopInfo objectForKey:@"shop_activity_info"] isEqualToString:@""]) {
        [statuLabel setText:@"本店暂无活动"];
    }else{
    [statuLabel setText:[shopInfo objectForKey:@"shop_activity_info"]];
    }
    NSString*string=[NSString stringWithFormat:@"%@,%@",[shopInfo objectForKey:@"shop_category_word"],[shopInfo objectForKey:@"shop_category_detail"]];
    [categoryLabel setText:string];
    [locationLabel setText:[shopInfo objectForKey:@"shop_address"]];
    [phoneLabel setText:[shopInfo objectForKey:@"shop_tel"]];
    //[lastLaunch setText:[shopInfo objectForKey:@"shop_last_launch_time"]];
//    [self getColor:nameLabel];
//    [self getColor:categoryLabel];
//    [self getColor:statuLabel];
//    [self getColor:localView];
//    [self getColor:phoneView];
}
-(void)callPhone:(id)sender
{
    NSString*string=phoneLabel.text;
    phoneAlter=[[UIAlertView alloc] initWithTitle:@"是否拨打" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [phoneAlter show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==phoneAlter) {
        if (buttonIndex==1) {
            NSString*number=[NSString stringWithFormat:@"tel://%@",phoneLabel.text];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        }
    }
}
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
-(void)getColor:(id)label
{
    int i=arc4random()%[colorArray count];
    [label setBackgroundColor:[colorArray objectAtIndex:i]];
    [colorArray removeObjectAtIndex:i];
}
@end
