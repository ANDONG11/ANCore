//
//  UIScrollView+Refresh.m
//  ANCore
//
//  Created by andong on 2021/1/12.
//  Copyright © 2021 andong. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <MJRefresh/MJRefresh.h>

@implementation UIScrollView (Refresh)


/// 下拉刷新normal
- (void)headerWithNormalRefreshingBlock:(void(^)(void))block {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (block) block();
    }];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
    [header.stateLabel setFont:[UIFont systemFontOfSize:13.0f]];
    self.mj_header = header;
}

/// 上拉加载
- (void)footerWithRefreshingBlock:(void(^)(void))block {
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (block) block();
    }];
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 我是有底线的哦！—" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
    [footer.stateLabel setFont:[UIFont systemFontOfSize:13.0f]];
    self.mj_footer = footer;
}

/// 上拉自动加载
- (void)autoFooterWithRefreshingBlock:(void(^)(void))block {
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        if (block) block();
    }];
    self.mj_footer = footer;
}

/// 结束刷新数据
- (void)endRefreshing {
    [self headerEndRefreshing];
    [self footerEndRefreshing];
}

/// 结束刷新数据并展示已经到底
- (void)endRefreshingWithNoMore:(BOOL)isNoMore {
    [self headerEndRefreshing];
    [self footerIsNoMoreData:isNoMore];
}


/// 开始刷新
- (void)headerBeginRefreshing {
    [self.mj_header beginRefreshing];
    self.mj_footer.hidden = YES;
}

- (void)headerEndRefreshing {
    [self.mj_header endRefreshing];
    self.mj_footer.hidden = NO;
}

- (void)footerBeginRefreshing {
    [self.mj_footer beginRefreshing];
}

- (void)footerEndRefreshing {
    [self.mj_footer endRefreshing];
}


- (void)footerIsNoMoreData:(BOOL)isNoMore {
    if (isNoMore) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mj_footer resetNoMoreData];
    }
}

@end
