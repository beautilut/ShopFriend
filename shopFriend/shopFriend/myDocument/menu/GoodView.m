//
//  GoodView.m
//  shopFriend
//
//  Created by Beautilut on 14-3-26.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "GoodView.h"
#import <Accelerate/Accelerate.h>
#import <CommonCrypto/CommonDigest.h>
#define imageScrollWidth 248
#define imageScrollHeight 150
@implementation GoodView
@synthesize pageControl,imageScroller,menuImageArray;
+(GoodView*)sharedGoodView
{
    static GoodView *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedSVC=[[self alloc] init];
    });
    return sharedSVC;
}
- (id)init
{
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    self=[super initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    if (self) {
        manager=[[SDWebImageManager alloc] init];
    }
    return self;
}
-(void)setMenuArray:(NSArray*)menuArray withShopID:(NSString*)shopID;
{
    [manager cancelAll];
    menuImageArray=[[NSMutableArray alloc] init];
    NSDictionary*menuDic=[menuArray objectAtIndex:0];
    [self backDefault:menuDic];
    NSString*key=[menuArray objectAtIndex:1];
    NSNumber*imageCount=[menuDic objectForKey:@"good_photo_count"];
    for (int i=0; i<[imageCount intValue]; i++) {
        NSString*md5=[self md5:[menuDic objectForKey:@"good_name"]];
        NSString*string=[NSString stringWithFormat:@"%@/menu/%@/%@%d.jpg",shopID,key,md5,i];
        NSURL*url=[NSURL URLWithString:SHOP_MENU_PICK(string)];
        WindowNumberObject*object=[[WindowNumberObject alloc] initWithNumber:[NSNumber numberWithInt:i] withURL:url withDelegate:self];
        }
}
-(void)imageDown:(WindowNumberObject *)object
{
    [menuImageArray addObject:object];
    [self imageArrayReload];
}
-(void)backDefault:(NSDictionary*)menuDic
{
    self.clipsToBounds=TRUE;
    UIView*backView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [backView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:backView];
    overView= [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [overView addTarget:self
                 action:@selector(dismiss)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:overView];
    
    deepView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
    [deepView setCenter:CGPointMake(self.center.x, self.center.y-50)];
    [deepView setBackgroundColor:[UIColor whiteColor]];
    deepView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    deepView.layer.borderWidth = 1.0f;
    [self addSubview:deepView];
    deepView.layer.masksToBounds=YES;
    deepView.layer.cornerRadius = 6.0;
    
    UILabel*nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [nameLabel setCenter:CGPointMake(deepView.frame.size.width/2, 15)];
    [nameLabel setText:[menuDic objectForKey:@"good_name"]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setTextColor:[UIColor orangeColor]];
    [deepView addSubview:nameLabel];
    
    self.imageScroller=[[UIScrollView alloc] initWithFrame:CGRectMake(1, 30, imageScrollWidth, imageScrollHeight)];
    imageScroller.bounces=YES;
    imageScroller.pagingEnabled=YES;
    imageScroller.delegate=self;
    imageScroller.userInteractionEnabled=YES;
    imageScroller.showsHorizontalScrollIndicator=NO;
    [imageScroller setBackgroundColor:[UIColor whiteColor]];
    [deepView addSubview:imageScroller];
    
    UILabel*priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,180, deepView.frame.size.width-20, 30)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    float floatNumber=[[menuDic objectForKey:@"good_price"] floatValue];
    NSString *pricestring = [formatter stringFromNumber:[NSNumber numberWithFloat:floatNumber]];
    NSString*price=[NSString stringWithFormat:@"%@",pricestring];
    [priceLabel setText:price];
    [priceLabel setTextColor:[UIColor redColor]];
    [deepView addSubview:priceLabel];
    
    infoText=[[UITextView alloc] initWithFrame:CGRectMake(10, 210, deepView.frame.size.width-20, 90)];
    NSString*string;
    if ([menuDic objectForKey:@"good_info"]!=NULL) {
        string=[NSString stringWithFormat:@"简介:%@",[menuDic objectForKey:@"good_info"]];
    }else{
        string=[NSString stringWithFormat:@"简介:暂无。"];
    }
    [infoText setEditable:NO];
    [infoText setSelectable:NO];
    [infoText setText:string];
    [deepView addSubview:infoText];
}
-(void)imageArrayReload
{
    for (id view in imageScroller.subviews) {
        [view removeFromSuperview];
    }
    [pageControl removeFromSuperview];
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
    [pageControl setCenter:CGPointMake(imageScroller.frame.size.width/2,170)];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    pageControl.numberOfPages=[menuImageArray count];
    pageControl.currentPage=0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [deepView addSubview:pageControl];
    [menuImageArray sortUsingComparator:^(id obj1,id obj2){
        if ([obj1 getCountNumber] > [obj2 getCountNumber]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 getCountNumber] < [obj2 getCountNumber]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    for (int i=0; i<[menuImageArray count]; i++) {
        WindowNumberObject*object=[menuImageArray objectAtIndex:i];
        UIImageView*imageView=[[UIImageView alloc] initWithImage:[object getImage]];
        imageView.frame=CGRectMake((imageScrollWidth*i)+imageScrollWidth, 0,imageScrollWidth, imageScrollHeight);
        [imageScroller addSubview:imageView];
    }
    WindowNumberObject*object=[menuImageArray objectAtIndex:menuImageArray.count-1];
    UIImageView*imageView=[[UIImageView alloc] initWithImage:[object getImage]];
    imageView.frame=CGRectMake(0, 0, imageScrollWidth, imageScrollHeight);
    [imageScroller addSubview:imageView];
    
    object=[menuImageArray objectAtIndex:0];
    imageView=[[UIImageView alloc] initWithImage:[object getImage]];
    imageView.frame=CGRectMake(imageScrollWidth*([menuImageArray count]+1), 0, imageScrollWidth, imageScrollHeight);
    [imageScroller addSubview:imageView];
    
    [imageScroller setContentSize:CGSizeMake(imageScrollWidth*([menuImageArray count]+2),imageScrollHeight)];
    [imageScroller setContentOffset:CGPointMake(0, 0)];
    [self.imageScroller scrollRectToVisible:CGRectMake(imageScrollWidth, 0, imageScrollWidth , imageScrollHeight) animated:NO];
}
-(void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [self.imageScroller scrollRectToVisible:CGRectMake(imageScrollWidth*(page+1),0,imageScrollWidth,imageScrollHeight) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.imageScroller.frame.size.width;
    int page = floor((self.imageScroller.contentOffset.x - pagewidth/([menuImageArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.imageScroller.frame.size.width;
    int currentPage = floor((self.imageScroller.contentOffset.x - pagewidth/ ([menuImageArray count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.imageScroller scrollRectToVisible:CGRectMake(imageScrollWidth * [menuImageArray count],0,imageScrollWidth,imageScrollHeight) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([menuImageArray count]+1))
    {
        [self.imageScroller scrollRectToVisible:CGRectMake(imageScrollWidth,0,imageScrollWidth,imageScrollHeight) animated:NO]; // 最后+1,循环第1页
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark methods
#pragma mark - animation
-(void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)dismiss
{
    [self fadeOut];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            //[nameField resignFirstResponder];
            //[passwordField resignFirstResponder];
            [self removeFromSuperview];
        }
    }];
}
#pragma mark - blur
-(void)setBlurImage:(UIImage*)image
{
    backImage=[self blurryImage:image withBlurLevel:0.3f];
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
-(void)selfsetBack:(UIImage*)image
{
    overView.layer.contents=(id)backImage.CGImage;
}
-(NSString*)md5:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSString*string=[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
    return [string lowercaseString];
}
@end
