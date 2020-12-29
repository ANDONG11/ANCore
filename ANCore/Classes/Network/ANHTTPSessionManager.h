//
//  ANHTTPSessionManager.h
//  Practice
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANHTTPSessionManager : AFHTTPSessionManager


/// 初始化session manager并设置请求格式
+(instancetype)sharedInstance;


/// 是否有网络连接
+ (BOOL)netWorkReachability;
@end

NS_ASSUME_NONNULL_END
