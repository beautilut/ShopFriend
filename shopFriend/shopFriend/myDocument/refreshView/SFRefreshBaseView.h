//
//  SFRefreshBaseView.h
//  shopFriend
//
//  Created by Beautilut on 14-3-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import <UIKit/UIKit.h>
// 控件的刷新状态
typedef enum {
    SFRefreshStatePulling = 1, // 松开就可以进行刷新的状态
	SFRefreshStateNormal = 2, // 普通状态
	SFRefreshStateRefreshing = 3, // 正在刷新中的状态
    SFRefreshStateWillRefreshing = 4
} SFRefreshState;
// 控件的类型
typedef enum {
    SFRefreshViewTypeHeader = -1, // 头部控件
    SFRefreshViewTypeFooter = 1 // 尾部控件
} SFRefreshViewType;

@class SFRefreshBaseView;
/**
 回调的Block定义
 */
// 开始进入刷新状态就会调用
typedef void (^BeginRefreshingBlock)(SFRefreshBaseView *refreshView);
// 刷新完毕就会调用
typedef void (^EndRefreshingBlock)(SFRefreshBaseView *refreshView);
// 刷新状态变更就会调用
typedef void (^RefreshStateChangeBlock)(SFRefreshBaseView *refreshView, SFRefreshState state);
/**
 代理的协议定义
 */
@protocol SFRefreshBaseViewDelegate <NSObject>
@optional
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(SFRefreshBaseView *)refreshView;
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(SFRefreshBaseView *)refreshView;
// 刷新状态变更就会调用
- (void)refreshView:(SFRefreshBaseView *)refreshView stateChange:(SFRefreshState)state;
@end

@interface SFRefreshBaseView : UIView
{
    // 父控件一开始的contentInset
    UIEdgeInsets _scrollViewInitInset;
    // 父控件
    __weak UIScrollView *_scrollView;
    
    // 子控件
    __weak UILabel *_lastUpdateTimeLabel;
	__weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
	__weak UIActivityIndicatorView *_activityView;
    
    // 状态
    SFRefreshState _state;
}
// 构造方法
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
// 设置要显示的父控件
@property (nonatomic, weak) UIScrollView *scrollView;

// 内部的控件
@property (nonatomic, weak, readonly) UILabel *lastUpdateTimeLabel;
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, weak, readonly) UIImageView *arrowImage;

// Block回调
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, copy) RefreshStateChangeBlock refreshStateChangeBlock;
@property (nonatomic, copy) EndRefreshingBlock endStateChangeBlock;
// 代理
@property (nonatomic, weak) id<SFRefreshBaseViewDelegate> delegate;

// 是否正在刷新
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
// 开始刷新
- (void)beginRefreshing;
// 结束刷新
- (void)endRefreshing;
// 不静止地结束刷新
- (void)endRefreshingWithoutIdle;
// 结束使用、释放资源
- (void)free;

/**
 交给子类去实现 和 调用
 */
- (void)setState:(SFRefreshState)state;
@end
