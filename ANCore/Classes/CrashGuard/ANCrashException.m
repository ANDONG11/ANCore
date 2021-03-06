//
//  ANCrashException.m
//  ANCore
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "ANCrashException.h"
#import <objc/runtime.h>
#import <mach-o/dyld.h>

#ifdef DEBUG
#define ANCrashGuardLog(fmt, ...) NSLog((@"CrashGuardLog:" fmt), ##__VA_ARGS__)
#else
#define ANCrashGuardLog(...)
#endif

__attribute__((overloadable)) void crashExceptionHandle(NSException* exceptionMessage) {
    [[ANCrashException shareException] handleCrashInException:exceptionMessage extraInfo:nil];
}
__attribute__((overloadable)) void crashExceptionHandle(NSException* exceptionMessage,NSString* extraInfo) {
    [[ANCrashException shareException] handleCrashInException:exceptionMessage extraInfo:extraInfo];
}
__attribute__((overloadable)) void crashExceptionHandle(NSString* exceptionMessage) {
    [[ANCrashException shareException] handleCrashException:exceptionMessage extraInfo:@{}];
}

__attribute__((overloadable)) void crashExceptionHandle(NSString* exceptionMessage,NSString* extraInfo) {
    [[ANCrashException shareException] handleCrashException:exceptionMessage extraInfo:@{@"description":extraInfo?extraInfo:@"nothing"}];
}

@implementation ANCrashException

static ANCrashException *_manager;

+ (instancetype)shareException {
    if(_manager){
        return _manager;
    }else{
        _manager = [[ANCrashException alloc]init];
    }
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}


#pragma mark - private
- (void)handleCrashInException:(nonnull NSException *)exception extraInfo:(nullable NSString*)extraInfo {
    if (!exception) {
        return;
    }
    // errorName
    NSString *errorName = exception.name;
    // errorReason
    NSString *errorReason = exception.reason;
    // errorReason 可能为 -[__NSCFConstantString avoidCrashCharacterAtIndex:]: Range or index out of bounds 将avoidCrash去掉
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"avoidCrash" withString:@""];
    [self handleCrashException:errorReason extraInfo:@{
                                                @"ErrorName":errorName,
                                                @"errorReason":errorReason,
                                                @"description":extraInfo?extraInfo:@"nothing"
                                                }];
}

- (void)handleCrashException:(nonnull NSString *)exceptionMessage extraInfo:(nullable NSDictionary*)extraInfo {
    if (!exceptionMessage) {
        return;
    }
    // 堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    // 获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [ANCrashException getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"crash 定位失败,请结合函数调用栈来排查";
    }
    // errorPlace
    NSString *errorPlace = [NSString stringWithFormat:@"%@",mainCallStackSymbolMsg];
    // loadAddress & slideAddress
    NSString *callStackString = [NSString stringWithFormat:@"%@",callStackSymbolsArr];
    uintptr_t loadAddress =  get_load_address();
    uintptr_t slideAddress =  get_slide_address();
    NSDictionary *exdic = @{
        @"ErrorPlace":errorPlace,
        @"LoadAddress":@(loadAddress),
        @"SlideAddress":@(slideAddress),
        @"description":exceptionMessage,
        @"callStack":callStackString
    };
    if ([self.delegate respondsToSelector:@selector(handleCrashException:extraInfo:)]){
        [self.delegate handleCrashException:exceptionMessage extraInfo:exdic];
    }
    
    if(self.printLog){
        ANCrashGuardLog(@"==================== MKCrashGuard Start=========================");
        ANCrashGuardLog(@"ErrorPlace:%@",errorPlace);
        ANCrashGuardLog(@"Description:%@",exceptionMessage);
        ANCrashGuardLog(@"CallStack:%@",callStackString);
        ANCrashGuardLog(@"==================== MKCrashGuard End============================");
    }
    
}



/**
 Get application base address,the application different base address after started
 @return base address
 */
uintptr_t get_load_address(void) {
    const struct mach_header *exe_header = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            exe_header = header;
            break;
        }
    }
    return (uintptr_t)exe_header;
}
/**
 Address Offset
 @return slide address
 */
uintptr_t get_slide_address(void) {
    uintptr_t vmaddr_slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return (uintptr_t)vmaddr_slide;
}

// 可能 crash 的地方
+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    // mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    // 匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString *tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                // get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                // filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    return mainCallStackSymbolMsg;
}
 
@end
