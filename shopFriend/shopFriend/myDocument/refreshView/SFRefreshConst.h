//
//  SFRefreshConst.h
//  shopFriend
//
//  Created by Beautilut on 14-3-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#ifdef DEBUG
#define SFLog(...) NSLog(__VA_ARGS__)
#else
#define SFLog(...)
#endif

// 文字颜色
#define SFRefreshLabelTextColor [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]

extern const CGFloat SFRefreshViewHeight;
extern const CGFloat SFRefreshAnimationDuration;

extern NSString *const SFRefreshBundleName;
#define kSrcName(file) [SFRefreshBundleName stringByAppendingPathComponent:nil]

extern NSString *const SFRefreshFooterPullToRefresh;
extern NSString *const SFRefreshFooterReleaseToRefresh;
extern NSString *const SFRefreshFooterRefreshing;

extern NSString *const SFRefreshHeaderPullToRefresh;
extern NSString *const SFRefreshHeaderReleaseToRefresh;
extern NSString *const SFRefreshHeaderRefreshing;
extern NSString *const SFRefreshHeaderTimeKey;

extern NSString *const SFRefreshContentOffset;
extern NSString *const SFRefreshContentSize;
