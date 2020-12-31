//
//  NSMutableArray+ANCrashGuard.h
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (ANCrashGuard)

/** 防护：
 *
 *  - (id)objectAtIndex:(NSUInteger)index
 *  - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
 *  - (void)removeObjectAtIndex:(NSUInteger)index
 *  - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
 *  - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 *  - (NSArray<ObjectType> *)subarrayWithRange:(NSRange)range;
 *  - (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx
 *  - (void)addObject:(ObjectType)anObject;
 *  - (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;
 */
+ (void)openCrashGuard;

@end

NS_ASSUME_NONNULL_END
