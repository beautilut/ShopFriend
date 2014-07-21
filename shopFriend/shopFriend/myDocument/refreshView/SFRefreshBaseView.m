//
//  SFRefreshBaseView.m
//  shopFriend
//
//  Created by Beautilut on 14-3-5.
//  Copyright (c) 2014年 beautilut design. All rights reserved.
//

#import "SFRefreshBaseView.h"
#import "SFRefreshConst.h"
@interface  SFRefreshBaseView()
{
    BOOL _hasInitInset;
}
/**
 交给子类去实现
 */
// 合理的Y值
- (CGFloat)validY;
// view的类型
- (SFRefreshViewType)viewType;
@end

@implementation SFRefreshBaseView

#pragma mark 创建一个UILabel
- (UILabel *)labelWithFontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:size];
    label.textColor = SFRefreshLabelTextColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark - 初始化方法
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        self.scrollView = scrollView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_hasInitInset) {
        _scrollViewInitInset = _scrollView.contentInset;
        
        [self observeValueForKeyPath:SFRefreshContentSize ofObject:nil change:nil context:nil];
        
        _hasInitInset = YES;
        
        if (_state == SFRefreshStateWillRefreshing) {
            [self setState:SFRefreshStateRefreshing];
        }
    }
}

#pragma mark 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.时间标签
        [self addSubview:_lastUpdateTimeLabel = [self labelWithFontSize:12]];
        
        // 3.状态标签
        [self addSubview:_statusLabel = [self labelWithFontSize:13]];
        
        // 4.箭头图片
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSrcName(@"arrow.png")]];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage = arrowImage];
        
        // 5.指示器
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = arrowImage.bounds;
        activityView.autoresizingMask = arrowImage.autoresizingMask;
        [self addSubview:_activityView = activityView];
        
        // 6.设置默认状态
        [self setState:SFRefreshStateNormal];
    }
    return self;
}
#pragma mark 设置frame
- (void)setFrame:(CGRect)frame
{
    frame.size.height = SFRefreshViewHeight;
    [super setFrame:frame];
    
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    if (w == 0 || _arrowImage.center.y == h * 0.5) return;
    
    CGFloat statusX = 0;
    CGFloat statusY = 5;
    CGFloat statusHeight = 20;
    CGFloat statusWidth = w;
    // 1.状态标签
    _statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    // 2.时间标签
    CGFloat lastUpdateY = statusY + statusHeight + 5;
    _lastUpdateTimeLabel.frame = CGRectMake(statusX, lastUpdateY, statusWidth, statusHeight);
    
    // 3.箭头
    CGFloat arrowX = w * 0.5 - 100;
    _arrowImage.center = CGPointMake(arrowX, h * 0.5);
    
    // 4.指示器
    _activityView.center = _arrowImage.center;
}
- (void)setBounds:(CGRect)bounds
{
    bounds.size.height = SFRefreshViewHeight;
    [super setBounds:bounds];
}

#pragma mark - UIScrollView相关
#pragma mark 设置UIScrollView
- (void)setScrollView:(UIScrollView *)scrollView
{
    // 移除之前的监听器
    [_scrollView removeObserver:self forKeyPath:SFRefreshContentOffset context:nil];
    // 监听contentOffset
    [scrollView addObserver:self forKeyPath:SFRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
    
    // 设置scrollView
    _scrollView = scrollView;
    [_scrollView addSubview:self];
}
#pragma mark 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![SFRefreshContentOffset isEqualToString:keyPath]) return;
    
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
        || _state == SFRefreshStateRefreshing) return;
    
    // scrollView所滚动的Y值 * 控件的类型（头部控件是-1，尾部控件是1）
    CGFloat offsetY = _scrollView.contentOffset.y * self.viewType;
    CGFloat validY = self.validY;
    if (offsetY <= validY) return;
    
    if (_scrollView.isDragging) {
        CGFloat validOffsetY = validY + SFRefreshViewHeight;
        if (_state == SFRefreshStatePulling && offsetY <= validOffsetY) {
            // 转为普通状态
            [self setState:SFRefreshStateNormal];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:SFRefreshStateNormal];
            }
            
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, SFRefreshStateNormal);
            }
        } else if (_state == SFRefreshStateNormal && offsetY > validOffsetY) {
            // 转为即将刷新状态
            [self setState:SFRefreshStatePulling];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:SFRefreshStatePulling];
            }
            
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, SFRefreshStatePulling);
            }
        }
    } else { // 即将刷新 && 手松开
        if (_state == SFRefreshStatePulling) {
            // 开始刷新
            [self setState:SFRefreshStateRefreshing];
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshView:stateChange:)]) {
                [_delegate refreshView:self stateChange:SFRefreshStateRefreshing];
            }
            
            // 回调
            if (_refreshStateChangeBlock) {
                _refreshStateChangeBlock(self, SFRefreshStateRefreshing);
            }
        }
    }
}

#pragma mark 设置状态
- (void)setState:(SFRefreshState)state
{
    if (_state != SFRefreshStateRefreshing) {
        // 存储当前的contentInset
        _scrollViewInitInset = _scrollView.contentInset;
    }
    
    // 1.一样的就直接返回
    if (_state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
		case SFRefreshStateNormal: // 普通状态
            // 显示箭头
            _arrowImage.hidden = NO;
            // 停止转圈圈
			[_activityView stopAnimating];
            
            // 说明是刚刷新完毕 回到 普通状态的
            if (SFRefreshStateRefreshing == _state) {
                // 通知代理
                if ([_delegate respondsToSelector:@selector(refreshViewEndRefreshing:)]) {
                    [_delegate refreshViewEndRefreshing:self];
                }
                
                // 回调
                if (_endStateChangeBlock) {
                    _endStateChangeBlock(self);
                }
            }
            
			break;
            
        case SFRefreshStatePulling:
            break;
            
		case SFRefreshStateRefreshing:
            // 开始转圈圈
			[_activityView startAnimating];
            // 隐藏箭头
			_arrowImage.hidden = YES;
            _arrowImage.transform = CGAffineTransformIdentity;
            
            // 通知代理
            if ([_delegate respondsToSelector:@selector(refreshViewBeginRefreshing:)]) {
                [_delegate refreshViewBeginRefreshing:self];
            }
            
            // 回调
            if (_beginRefreshingBlock) {
                _beginRefreshingBlock(self);
            }
			break;
        default:
            break;
	}
    
    // 3.存储状态
    _state = state;
}
#pragma mark - 状态相关
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return SFRefreshStateRefreshing == _state;
}
#pragma mark 开始刷新
- (void)beginRefreshing
{
    if (self.window) {
        [self setState:SFRefreshStateRefreshing];
    } else {
        _state = SFRefreshStateWillRefreshing;
    }
}
#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = self.viewType == SFRefreshViewTypeFooter ? 0.3 : 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setState:SFRefreshStateNormal];
    });
}

#pragma mark - 随便实现
- (CGFloat)validY { return 0;}
- (SFRefreshViewType)viewType {return SFRefreshViewTypeHeader;}
- (void)free
{
    [_scrollView removeObserver:self forKeyPath:SFRefreshContentOffset];
}
- (void)removeFromSuperview
{
    [self free];
    _scrollView = nil;
    [super removeFromSuperview];
}
- (void)endRefreshingWithoutIdle
{
    [self endRefreshing];
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
