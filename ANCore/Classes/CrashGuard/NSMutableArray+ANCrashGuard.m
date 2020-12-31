//
//  NSMutableArray+ANCrashGuard.m
//  ANCore
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSMutableArray+ANCrashGuard.h"

@implementation NSMutableArray (ANCrashGuard)

+ (void)openCrashGuard {
    
    Class __NSArrayM = NSClassFromString(@"__NSArrayM");
    
    an_swizzleInstanceMethod(__NSArrayM, @selector(objectAtIndex:), @selector(_guardObjectAtIndex:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(subarrayWithRange:), @selector(guardSubarrayWithRange:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(objectAtIndexedSubscript:), @selector(guardObjectAtIndexedSubscript:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(addObject:), @selector(guardAddObject:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(insertObject:atIndex:), @selector(guardInsertObject:atIndex:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(removeObjectAtIndex:), @selector(guardRemoveObjectAtIndex:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(replaceObjectAtIndex:withObject:), @selector(guardReplaceObjectAtIndex:withObject:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(setObject:atIndexedSubscript:), @selector(guardSetObject:atIndexedSubscript:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(removeObjectsInRange:), @selector(guardRemoveObjectsInRange:));
    an_swizzleInstanceMethod(__NSArrayM, @selector(getObjects:range:), @selector(guardGetObjects:range:));
}


- (void)guardAddObject:(id)anObject {
    if (anObject) {
        [self guardAddObject:anObject];
    } else {
        crashExceptionHandle(@"[NSMutableArray addObject: ] nil object");
    }
}

- (id)_guardObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self _guardObjectAtIndex:index];
    }
    crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray objectAtIndex: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
}

- (id)guardObjectAtIndexedSubscript:(NSInteger)index {
    if (index < self.count) {
        return [self guardObjectAtIndexedSubscript:index];
    }
    crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray objectAtIndexedSubscript: ] invalid index:%tu total:%tu",index,self.count]);
    return nil;
}

- (void)guardInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        [self guardInsertObject:anObject atIndex:index];
    }else{
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray insertObject: atIndex: ] invalid index:%tu total:%tu insert object:%@",index,self.count,anObject]);
    }
}

- (void)guardRemoveObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self guardRemoveObjectAtIndex:index];
    }else{
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray removeObjectAtIndex: ] invalid index:%tu total:%tu",index,self.count]);
    }
}

- (void)guardReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < self.count && anObject) {
        [self guardReplaceObjectAtIndex:index withObject:anObject];
    }else{
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray replaceObjectAtIndex: withObject: ] invalid index:%tu total:%tu replace object:%@",index,self.count,anObject]);
    }
}

- (void)guardSetObject:(id)object atIndexedSubscript:(NSUInteger)index {
    if (index <= self.count && object) {
        [self guardSetObject:object atIndexedSubscript:index];
    }else{
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray setObject: atIndexedSubscript: ] invalid object:%@ atIndexedSubscript:%tu total:%tu",object,index,self.count]);
    }
}

- (void)guardRemoveObjectsInRange:(NSRange)range {
    if (range.location + range.length <= self.count) {
        [self guardRemoveObjectsInRange:range];
    }else{
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray removeObjectsInRange: ] invalid range location:%tu length:%tu",range.location,range.length]);
    }
}

- (NSArray *)guardSubarrayWithRange:(NSRange)range {
    if (range.location + range.length <= self.count){
        return [self guardSubarrayWithRange:range];
    }else if (range.location < self.count){
        return [self guardSubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    crashExceptionHandle([NSString stringWithFormat:@"[NSMutableArray subarrayWithRange: ] invalid range location:%tu length:%tu",range.location,range.length]);
    return nil;
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
