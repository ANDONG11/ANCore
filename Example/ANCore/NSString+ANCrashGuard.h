//
//  NSString+ANCrashGuard.h
//  ANCore_Example
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ANCrashGuard)

/** 防护
 *
 *  - (unichar)characterAtIndex:(NSUInteger)index
 *  - (NSString *)substringFromIndex:(NSUInteger)from
 *  - (NSString *)substringToIndex:(NSUInteger)to {
 *  - (NSString *)substringWithRange:(NSRange)range {
 *  - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
 *  - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
 *  - (NSString *)stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
 *  + (nullable instancetype)stringWithUTF8String:(const char *)nullTerminatedCString;
 *  + (nullable instancetype)stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc;
 *  - (nullable instancetype)initWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding;
 *  - (instancetype)initWithString:(NSString *)aString;
 */
+ (void)openCrashGuard;

@end

NS_ASSUME_NONNULL_END
