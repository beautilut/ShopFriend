//
//  ShopWinowView.m
//  shopFriend
//
//  Created by Beautilut on 14-3-23.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "ShopWinowView.h"

@implementation ShopWinowView
@synthesize scrollView,slideImages,pageControl;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    //[NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    UIImageView*backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,160,200)];
    [backImageView setCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/3)];
    [backImageView setImage:[UIImage imageNamed:@"shopWindowBack.png"]];
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
    scrollView.bounces=YES;
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.userInteractionEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    [scrollView addSubview:backImageView];
    [self addSubview:scrollView];
    slideImages=[[NSMutableArray alloc] init];
    return self;
}
//init With Array
-(void)updateArray:(NSArray*)array
{
    for (int i=0; i<[array count]; i++) {
        NSURL*url=[NSURL URLWithString:[array objectAtIndex:i]];
        WindowNumberObject*object=[[WindowNumberObject alloc] initWithNumber:[NSNumber numberWithInt:i] withURL:url withDelegate:self];
    }
}
-(void)imageDown:(WindowNumberObject*)object
{
    [slideImages addObject:object];
    [self shopWindowReload];
}
-(void)shopWindowReload
{
    if (slideImages.count>0) {
        
        for (id view in scrollView.subviews) {
            [view removeFromSuperview];
        }
//        [pageControl removeFromSuperview];
//        pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
//        [pageControl setCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height-10)];
//        [pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
//        [pageControl setPageIndicatorTintColor:[UIColor blackColor]];
//        pageControl.numberOfPages=[slideImages count];
//        pageControl.currentPage=0;
//        [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
//        [self addSubview:pageControl];
        [slideImages sortUsingComparator:^(id obj1, id obj2){
            if ([obj1 getCountNumber] > [obj2 getCountNumber]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 getCountNumber] < [obj2 getCountNumber]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        for (int i=0; i<[slideImages count]; i++) {
            WindowNumberObject*object=[slideImages objectAtIndex:i];
            UIImageView*imageView=[[UIImageView alloc] initWithImage:[object getImage]];
            [imageView setFrame:CGRectMake((320*i)+320, 0, 320, self.frame.size.height)];
            [scrollView addSubview:imageView];
        }
        //最前面一张
        WindowNumberObject*object=[slideImages objectAtIndex:slideImages.count-1];
        UIImageView*imageView=[[UIImageView alloc] initWithImage:[object getImage]];
        [imageView setFrame:CGRectMake(0, 0, 320,self.frame.size.height)];
        [scrollView addSubview:imageView];
        //最后一张
        object=[slideImages objectAtIndex:0];
        imageView=[[UIImageView alloc] initWithImage:[object getImage]];
        [imageView setFrame:CGRectMake(320*([slideImages count]+1), 0, 320,self.frame.size.height)];
        [scrollView addSubview:imageView];
        
        [scrollView setContentSize:CGSizeMake(320*([slideImages count]+2),self.frame.size.height)];
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView scrollRectToVisible:CGRectMake(320, 0, 320,self.frame.size.height) animated:NO];
    }
}
//pageControl
//-(void)turnPage
//{
//    int page = pageControl.currentPage; // 获取当前的page
//    [self.scrollView scrollRectToVisible:CGRectMake(320*(page+1),0,320,460) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
//}
//// 定时器 绑定的方法
//- (void)runTimePage
//{
//    int page = pageControl.currentPage; // 获取当前的page
//    page++;
//    page = page > slideImages.count-1 ? 0 : page ;
//    pageControl.currentPage = page;
//    [self turnPage];
//}

//scrollView
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth=self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    //pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(320 * [slideImages count],0,320,460) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([slideImages count]+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,460) animated:NO]; // 最后+1,循环第1页
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

@end
