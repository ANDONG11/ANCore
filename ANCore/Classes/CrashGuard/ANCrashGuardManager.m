//
//  ANCrashGuardManager.m
//  ANCore
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "ANCrashGuardManager.h"
#import "NSArray+ANCrashGuard.h"
#import "NSMutableArray+ANCrashGuard.h"
#import "NSObject+ANUnrecognizedCrashGuard.h"
#import "NSObject+ANKVCCrashGuard.h"
#import "NSDictionary+ANCrashGuard.h"
#import "NSMutableDictionary+ANCrashGuard.h"
#import "NSString+ANCrashGuard.h"
#import "NSTimer+ANCrashGuard.h"
#import "NSObject+ANKVOCrashGuard.h"

@implementation ANCrashGuardManager

#pragma mark - 开启所有崩溃防护
+ (void)openCrashGuard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [NSArray openCrashGuard];
        [NSMutableArray openCrashGuard];
        
        [NSObject openUnrecognizedCrashGuard];
        [NSObject openKVCCrashGuard];
//        [NSObject openKVOCrashGuard];
        
        [NSDictionary openCrashGuard];
        [NSMutableDictionary openCrashGuard];
        
        [NSString openCrashGuard];
        
        [NSTimer openCrashGuard];
    });
}

/**
 * 注册 crash 信息的回调对象
 */
+ (void)registerCrashHandle:(id<ANCrashExceptionDelegate>)crashHandle {
    [ANCrashException shareException].delegate = crashHandle;
}

/**
 * 开启 log
 * @param isLog 是否开启log
 */
+ (void)printLog:(BOOL)isLog {
    [ANCrashException shareException].printLog = isLog;
}

@end
