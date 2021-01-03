//
//  NSTimer+ANCrashGuard.h
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ANSwizzleHook.h"
#import "ANCrashException.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ANCrashGuard)

/**
 * 防护 强引用 以及 target 提前销毁
 *
 */
+ (void)openCrashGuard;

@end

NS_ASSUME_NONNULL_END
