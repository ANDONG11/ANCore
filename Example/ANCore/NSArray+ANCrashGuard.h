//
//  NSArray+ANCrashGuard.h
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSArray (ANCrashGuard)

/** 防护：
 *
 *  + (instancetype)arrayWithObjects:(const ObjectType _Nonnull [_Nonnull])objects count:(NSUInteger)cnt; 即 快速创建方式
 *  - (id)objectAtIndex:(NSUInteger)index
 *  - (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
 *  - (ObjectType)objectAtIndex:(NSUInteger)index;
 *  - (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx
 * - (void)getObjects:(ObjectType _Nonnull __unsafe_unretained [_Nonnull])objects range:(NSRange)range
 *
 */
+ (void)openCrashGuard;

@end

NS_ASSUME_NONNULL_END
