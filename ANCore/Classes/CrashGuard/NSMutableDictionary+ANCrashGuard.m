//
//  NSMutableDictionary+ANCrashGuard.m
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSMutableDictionary+ANCrashGuard.h"

@implementation NSMutableDictionary (ANCrashGuard)

+ (void)openCrashGuard {
    an_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(guardSetObject:forKey:));
    an_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), @selector(guardRemoveObjectForKey:));
    an_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(guardSetObject:forKeyedSubscript:));
}

- (void)guardSetObject:(id)object forKey:(id)key {
    if (object && key) {
        [self guardSetObject:object forKey:key];
    } else {
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableDictionary setObject: forKey: ] invalid object:%@ and key:%@  dict:%@",object,key,self]);
    }
}

- (void)guardRemoveObjectForKey:(id)key {
    if (key) {
        [self guardRemoveObjectForKey:key];
    } else {
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableDictionary removeObjectForKey: ] nil key  dict:%@",self]);
    }
}

- (void)guardSetObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        [self guardSetObject:object forKeyedSubscript:key];
    } else {
        crashExceptionHandle([NSString stringWithFormat:@"[NSMutableDictionary setObject: forKeyedSubscript: ] object:%@ and forKeyedSubscript:%@  dict:%@",object,key,self]);
    }
}


@end
