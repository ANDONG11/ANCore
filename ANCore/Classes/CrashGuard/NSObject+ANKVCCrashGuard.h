//
//  NSObject+ANKVCCrashGuard.h
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ANSwizzleHook.h"
#import "ANCrashException.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ANKVCCrashGuard)

/** 防护
 * - (void)setValue:(nullable id)value forKey:(NSString *)key;
 * - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;
 * - (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;
 * - (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues;
 */
+ (void)openKVCCrashGuard;

@end

NS_ASSUME_NONNULL_END
