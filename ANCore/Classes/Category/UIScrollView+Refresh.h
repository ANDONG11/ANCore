//
//  UIScrollView+Refresh.h
//  ANCore
//
//  Created by andong on 2021/1/12.
//  Copyright © 2021 andong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Refresh)

/// 下拉刷新normal
/// @param block 回调
- (void)headerWithNormalRefreshingBlock:(void(^)(void))block;

/// 上拉加载数据
/// @param block 回调
- (void)footerWithRefreshingBlock:(void(^)(void))block;

/// 上拉自动加载
/// @param block 回调
- (void)autoFooterWithRefreshingBlock:(void(^)(void))block;

/// 结束刷新数据
- (void)endRefreshing;

/// 结束刷新数据并展示已经到底
/// @param isNoMore 是否有更多的数据展示
- (void)endRefreshingWithNoMore:(BOOL)isNoMore;

/// 开始刷新
- (void)headerBeginRefreshing;

/// 开始加载
- (void)footerBeginRefreshing;

@end

NS_ASSUME_NONNULL_END
