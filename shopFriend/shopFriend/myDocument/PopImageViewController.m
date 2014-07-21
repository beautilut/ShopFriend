//
//  PopImageViewController.m
//  shopFriend
//
//  Created by Beautilut on 14-1-17.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "PopImageViewController.h"
#import "ShopNaviBar.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#define ZOOM_VIEW_TAG 9999
@interface PopImageViewController ()
{
    UIScrollView*imageScroll;
    UIImageView*imageView;
}
@end

@implementation PopImageViewController

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
    ShopNaviBar*navi=[[ShopNaviBar alloc] init];
    [navi openNaviShadow:YES];
    [self.view addSubview:navi];
    UIButton*backButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
    backButton.center=CGPointMake(5+15, navi.center.y+10);
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backTouchDown:) forControlEvents:UIControlEventTouchDown];
    [navi addSubview:backButton];
    [self.view setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:1]];
    imageScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, navi.frame.size.height, screenBounds.size.width, screenBounds.size.height-navi.frame.size.height)];
    [imageScroll setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:242.0/255.0 blue:225.0/255.0 alpha:1]];
    [self.view addSubview:imageScroll];
    [imageScroll setScrollEnabled:YES];
    [imageScroll setDelegate:self];
    
    SDWebImageManager*manager=[SDWebImageManager sharedManager];
    imageView=[[UIImageView alloc] init];
    [manager downloadWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
    {
        if (image)
        {
            [imageView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
            [imageView setImage:image];
            [imageView setTag:ZOOM_VIEW_TAG];
            float minZoom=imageScroll.frame.size.width/imageView.frame.size.width;
            [imageScroll setMinimumZoomScale:minZoom];
            [imageScroll setMaximumZoomScale:1.0];
            [imageScroll addSubview:imageView];
        }
    }];
    [self.view bringSubviewToFront:navi];
        //[NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:nil];
	// Do any additional setup after loading the view.
}
-(void)setImageUrl:(NSString*)url
{
    imageUrl=url;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backTouchDown:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScroll viewWithTag:ZOOM_VIEW_TAG];
}
@end
