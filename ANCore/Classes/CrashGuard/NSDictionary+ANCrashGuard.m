//
//  NSDictionary+ANCrashGuard.m
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSDictionary+ANCrashGuard.h"
#import "NSObject+ANSwizzleHook.h"
#import "ANCrashException.h"

@implementation NSDictionary (ANCrashGuard)

+ (void)openCrashGuard {
    [NSDictionary an_swizzleClassMethod:@selector(dictionaryWithObject:forKey:) withSwizzleMethod:@selector(guardDictionaryWithObject:forKey:)];
    [NSDictionary an_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withSwizzleMethod:@selector(guardDictionaryWithObjects:forKeys:count:)];
    
    [NSDictionary an_swizzleInstanceMethod:@selector(initWithObjects:forKeys:count:) withSwizzleMethod:@selector(guardInitWithObjects:forKeys:count:)];
}

+ (instancetype)guardDictionaryWithObject:(id)object forKey:(id)key {
    if (object && key) {
        return [self guardDictionaryWithObject:object forKey:key];
    }
    crashExceptionHandle([NSString stringWithFormat:@"[NSDictionary dictionaryWithObject: ] invalid object:%@ and key:%@",object,key]);
    return nil;
}

+ (instancetype)guardDictionaryWithObjects:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt {
    NSInteger index = 0;
    id ks[cnt];
    id objs[cnt];
    for (NSInteger i = 0; i < cnt ; ++i) {
        if (keys[i] && objects[i]) {
            ks[index] = keys[i];
            objs[index] = objects[i];
            ++index;
        }else{
            crashExceptionHandle([NSString stringWithFormat:@"[NSDictionary dictionaryWithObjects: count: ] invalid keys:%@ and object:%@",keys[i],objects[i]]);
        }
    }
    return [self guardDictionaryWithObjects:objs forKeys:ks count:index];
}

- (instancetype)guardInitWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            crashExceptionHandle([NSString stringWithFormat:@"[NSDictionary initWithObjects: forKeys:  count: ] invalid keys:%@ and object:%@",keys[i],objects[i]]);
            continue;
        }
        if (!obj) {
            crashExceptionHandle([NSString stringWithFormat:@"[NSDictionary initWithObjects: forKeys: count: ] invalid keys:%@ and object:%@",keys[i],objects[i]]);
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self guardInitWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end
