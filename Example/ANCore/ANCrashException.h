//
//  ANCrashException.h
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((overloadable)) void crashExceptionHandle(NSException *exception);
__attribute__((overloadable)) void crashExceptionHandle(NSException *exception,NSString *extraInfo);
__attribute__((overloadable)) void crashExceptionHandle(NSString *exceptionMessage);
__attribute__((overloadable)) void crashExceptionHandle(NSString *exceptionMessage,NSString *extraInfo);

@interface ANCrashException : NSObject

+ (instancetype)shareException;
//@property(nonatomic,readwrite,weak) id<MKExceptionHandle> delegate;

- (void)handleCrashInException:(nonnull NSException *)exceptionMessage extraInfo:(nullable NSString *)extraInfo;
- (void)handleCrashException:(nonnull NSString *)exceptionMessage extraInfo:(nullable NSDictionary*)extraInfo;

@end

NS_ASSUME_NONNULL_END
