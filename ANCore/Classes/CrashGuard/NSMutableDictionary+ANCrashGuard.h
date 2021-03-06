//
//  NSMutableDictionary+ANCrashGuard.h
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ANSwizzleHook.h"
#import "ANCrashException.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (ANCrashGuard)

/** 防护：
 *
 * - (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
 * - (void)removeObjectForKey:(id)aKey
 *
 */
+ (void)openCrashGuard;

@end

NS_ASSUME_NONNULL_END
