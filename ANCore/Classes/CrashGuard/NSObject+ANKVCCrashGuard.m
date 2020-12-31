//
//  NSObject+ANKVCCrashGuard.m
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSObject+ANKVCCrashGuard.h"

@implementation NSObject (ANKVCCrashGuard)

+ (void)openKVCCrashGuard {
    
//    an_swizzleInstanceMethod([self class], @selector(setValue:forKey:),@selector(crashGuardSetValue:forKey:));
//    an_swizzleInstanceMethod([self class], @selector(setValue:forKeyPath:),@selector(crashGuardSetValue:forKeyPath:));
//    an_swizzleInstanceMethod([self class], @selector(setValue:forUndefinedKey:),@selector(crashGuardSetValue:forUndefinedKey:));
//    an_swizzleInstanceMethod([self class], @selector(setValuesForKeysWithDictionary:),@selector(crashGuardSetValuesForKeysWithDictionary:));
    
    [self an_swizzleInstanceMethod:@selector(setValue:forKey:) withSwizzleMethod:@selector(crashGuardSetValue:forKey:)];
    [self an_swizzleInstanceMethod:@selector(setValue:forKeyPath:) withSwizzleMethod:@selector(crashGuardSetValue:forKeyPath:)];
    [self an_swizzleInstanceMethod:@selector(setValue:forUndefinedKey:) withSwizzleMethod:@selector(crashGuardSetValue:forUndefinedKey:)];
    [self an_swizzleInstanceMethod:@selector(setValuesForKeysWithDictionary:) withSwizzleMethod:@selector(crashGuardSetValuesForKeysWithDictionary:)];
}

- (void)crashGuardSetValue:(id)value forKey:(NSString *)key {
    @try {
        [self crashGuardSetValue:value forKey:key];
    }
    @catch (NSException *exception) {
        crashExceptionHandle(exception);
    }
    @finally {
        
    }
}

- (void)crashGuardSetValue:(id)value forKeyPath:(NSString *)keyPath {
    @try {
        [self crashGuardSetValue:value forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        crashExceptionHandle(exception);
    }
    @finally {
        
    }
}

- (void)crashGuardSetValue:(id)value forUndefinedKey:(NSString *)key {
    @try {
        [self crashGuardSetValue:value forUndefinedKey:key];
    }
    @catch (NSException *exception) {
        crashExceptionHandle(exception);
    }
    @finally {
        
    }
}


- (void)crashGuardSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    @try {
        [self crashGuardSetValuesForKeysWithDictionary:keyedValues];
    }
    @catch (NSException *exception) {
        crashExceptionHandle(exception);
    }
    @finally {
        
    }
}


@end
