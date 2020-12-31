//
//  ANCrashGuardManager.m
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "ANCrashGuardManager.h"
#import "NSArray+ANCrashGuard.h"
#import "NSMutableArray+ANCrashGuard.h"
#import "NSObject+ANUnrecognizedCrashGuard.h"
#import "NSDictionary+ANCrashGuard.h"
#import "NSMutableDictionary+ANCrashGuard.h"
#import "NSString+ANCrashGuard.h"

@implementation ANCrashGuardManager

#pragma mark - 开启所有崩溃防护
+ (void)openCrashGuard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [NSArray openCrashGuard];
        [NSMutableArray openCrashGuard];
        
        [NSObject openUnrecognizedCrashGuard];
        
        [NSDictionary openCrashGuard];
        [NSMutableDictionary openCrashGuard];
        
        [NSString openCrashGuard];
    });
}
@end
