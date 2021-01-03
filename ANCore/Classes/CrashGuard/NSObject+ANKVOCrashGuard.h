//
//  NSObject+ANKVOCrashGuard.h
//  ANCore_Example
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ANSwizzleHook.h"
#import "ANCrashException.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ANKVOCrashGuard)

/**
 * 防护：添加监听后没有清除、清除不存在的key、添加重复的key 3 种情况导致的 crash
 */
+ (void)openKVOCrashGuard;
@end

NS_ASSUME_NONNULL_END
