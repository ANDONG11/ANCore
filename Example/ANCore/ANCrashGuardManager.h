//
//  ANCrashGuardManager.h
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger,ANCrashGuardType) {
    ANCrashGuardTypeNone = 0,
    ANCrashGuardTypeUnrecognizedSelector = 1 << 1,
    ANCrashGuardTypeKVOCrash = 1 << 2,
    ANCrashGuardTypeKVCCrash = 1 << 3,
    ANCrashGuardTypeNSTimer = 1 << 4,
    ANCrashGuardTypeNSNotification = 1 << 5,
    ANCrashGuardTypeNSNull = 1 << 6,
    
    ANCrashGuardTypeUINavigationController = 1 << 7,
    
    ANCrashGuardTypeNSStringContainer = 1 << 8,
    ANCrashGuardTypeDictionaryContainer = 1 << 9,
    ANCrashGuardTypeArrayContainer = 1 << 10,
    ANCrashGuardTypeNSAttributedStringContainer = 1 << 11,
    ANCrashGuardTypeNSSetContainer = 1 << 12,
    
    ANCrashGuardTypeNSUserDefaults = 1 << 13,
    ANCrashGuardTypeNSCache = 1 << 14,
    ANCrashGuardTypeNSNumber = 1 << 15,
    
    ANCrashGuardTypeAllExceptContainer = ANCrashGuardTypeUnrecognizedSelector | ANCrashGuardTypeKVOCrash | ANCrashGuardTypeKVCCrash | ANCrashGuardTypeNSTimer | ANCrashGuardTypeNSNotification | ANCrashGuardTypeNSNull | ANCrashGuardTypeUINavigationController | ANCrashGuardTypeNSUserDefaults | ANCrashGuardTypeNSCache | ANCrashGuardTypeNSNumber,
    
    ANCrashGuardTypeAllContainer = ANCrashGuardTypeNSStringContainer | ANCrashGuardTypeDictionaryContainer | ANCrashGuardTypeArrayContainer | ANCrashGuardTypeNSAttributedStringContainer | ANCrashGuardTypeNSSetContainer ,
    
    ANCrashGuardTypeAll = ANCrashGuardTypeAllContainer | ANCrashGuardTypeAllExceptContainer ,
};

@interface ANCrashGuardManager : NSObject

/**
 * 打开crash防护 ,默认守护所有的类型:MKCrashGuardTypeAll
 */
+ (void)openCrashGuard;

@end

NS_ASSUME_NONNULL_END
