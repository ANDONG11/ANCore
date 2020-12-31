//
//  NSTimer+ANCrashGuard.m
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSTimer+ANCrashGuard.h"
#import "NSObject+ANSwizzleHook.h"
#import "ANCrashException.h"

@interface ANTimerObject : NSObject

@property(nonatomic, assign) NSTimeInterval ti;
@property(nonatomic, weak) id target;
@property(nonatomic, assign) SEL selector;
@property(nonatomic, assign) id userInfo;
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, copy) NSString *targetClassName;
@property(nonatomic, copy) NSString *targetMethodName;

@end

@implementation ANTimerObject

- (void)fireTimer {
    if (!self.target) {
        [self.timer invalidate];
        self.timer = nil;
        crashExceptionHandle([NSString stringWithFormat:@"Need invalidate timer from target:%@ method:%@",self.targetClassName,self.targetMethodName]);
        return;
    }
    if ([self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
#pragma clang diagnostic pop
    }
}

@end

@implementation NSTimer (ANCrashGuard)

+ (void)openCrashGuard {
    an_swizzleClassMethod([NSTimer class],
                          @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
                          @selector(guardScheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
}

+ (NSTimer*)guardScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)repeat {
    if (!repeat) {
        return [self guardScheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:repeat];
    }
    ANTimerObject* timerObject = [ANTimerObject new];
    timerObject.ti = ti;
    timerObject.target = aTarget;
    timerObject.selector = aSelector;
    timerObject.userInfo = userInfo;
    if (aTarget) {
        timerObject.targetClassName = [NSString stringWithCString:object_getClassName(aTarget) encoding:NSASCIIStringEncoding];
    }
    timerObject.targetMethodName = NSStringFromSelector(aSelector);
    NSTimer* timer = [NSTimer guardScheduledTimerWithTimeInterval:ti target:timerObject selector:@selector(fireTimer) userInfo:userInfo repeats:repeat];
    timerObject.timer = timer;
    return timer;
}

@end
