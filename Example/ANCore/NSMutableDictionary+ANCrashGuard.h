//
//  NSMutableDictionary+ANCrashGuard.h
//  ANCore_Example
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>

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
