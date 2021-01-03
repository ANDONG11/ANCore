//
//  NSObject+ANUnrecognizedCrashGuard.h
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ANSwizzleHook.h"
#import "ANCrashException.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ANUnrecognizedCrashGuard)

+ (void)openUnrecognizedCrashGuard;

@end

NS_ASSUME_NONNULL_END
