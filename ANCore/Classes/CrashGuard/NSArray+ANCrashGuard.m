//
//  NSArray+ANCrashGuard.m
//  ANCore
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSArray+ANCrashGuard.h"

@implementation NSArray (ANCrashGuard)

+ (void)openCrashGuard {
    
    /// 交换类方法
    [NSArray an_swizzleClassMethod:@selector(arrayWithObject:) withSwizzleMethod:@selector(guardArrayWithObject:)];
    [NSArray an_swizzleClassMethod:@selector(arrayWithObjects:count:) withSwizzleMethod:@selector(guardArrayWithObjects:count:)];
    
    /// 交换对象方法
    Class __NSArray = NSClassFromString(@"__NSArrayI");
    
    [__NSArray an_swizzleInstanceMethod:@selector(objectsAtIndexes:) withSwizzleMethod:@selector(guardObjectsAtIndexes:)];
    [__NSArray an_swizzleInstanceMethod:@selector(objectAtIndex:) withSwizzleMethod:@selector(guardObjectAtIndex:)];
    [__NSArray an_swizzleInstanceMethod:@selector(objectAtIndexedSubscript:) withSwizzleMethod:@selector(guardObjectAtIndexedSubscript:)];
    [__NSArray an_swizzleInstanceMethod:@selector(getObjects:range:) withSwizzleMethod:@selector(guardGetObjects:range:)];
    [__NSArray an_swizzleInstanceMethod:@selector(subarrayWithRange:) withSwizzleMethod:@selector(guardSubarrayWithRange:)];
    
//    an_swizzleInstanceMethod(__NSArray,@selector(objectsAtIndexes:),@selector(guardObjectsAtIndexes:));
//    an_swizzleInstanceMethod(__NSArray,@selector(objectAtIndex:),@selector(guardObjectAtIndex:));
//    an_swizzleInstanceMethod(__NSArray,@selector(objectAtIndexedSubscript:),@selector(guardObjectAtIndexedSubscript:));
//    an_swizzleInstanceMethod(__NSArray,@selector(getObjects:range:),@selector(guardGetObjects:range:));
//    an_swizzleInstanceMethod(__NSArray,@selector(subarrayWithRange:),@selector(guardSubarrayWithRange:));
}

#pragma mark - 交换类方法
+ (instancetype)guardArrayWithObject:(id)anObject {
    if (anObject) {
        return [self guardArrayWithObject:anObject];
    }
    crashExceptionHandle(@"[NSArray arrayWithObject:] object is nil");
    return nil;
}

+ (instancetype)guardArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    NSInteger index = 0;
    id objs[cnt];
    for (NSInteger i = 0; i < cnt ; ++i) {
        if (objects[i]) {
            objs[index++] = objects[i];
        }else{
            crashExceptionHandle([NSString stringWithFormat:@"[NSArray arrayWithObjects: count: ] invalid index object:%tu total:%tu",i,cnt]);
        }
    }
    return [self guardArrayWithObjects:objs count:index];
}

#pragma mark - 交换instance
- (NSArray *)guardSubarrayWithRange:(NSRange)range {
    if (range.location + range.length <= self.count){
        return [self guardSubarrayWithRange:range];
    }else if (range.location < self.count){
        return [self guardSubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    crashExceptionHandle([NSString stringWithFormat:@"[NSArray subarrayWithRange: ] invalid range location:%tu length:%tu",range.location,range.length]);
    return nil;
}

- (id)guardObjectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self guardObjectAtIndexedSubscript:index];
    }
    crashExceptionHandle([NSString stringWithFormat:@"[NSArray objectAtIndexedSubscript: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
}

- (id)guardObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self guardObjectAtIndex:index];
    }
    crashExceptionHandle([NSString stringWithFormat:@"[NSArray objectAtIndex: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
}

- (NSArray *)guardObjectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self guardObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        crashExceptionHandle(exception);
    } @finally {
        return returnArray;
    }
}

- (void)guardGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self guardGetObjects:objects range:range];
    } @catch (NSException *exception) {
        crashExceptionHandle(exception);
    } @finally {
    }
}
 
@end
