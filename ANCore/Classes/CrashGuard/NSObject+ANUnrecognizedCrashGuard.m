//
//  NSObject+ANUnrecognizedCrashGuard.m
//  ANCore
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSObject+ANUnrecognizedCrashGuard.h"

@implementation NSObject (ANUnrecognizedCrashGuard)

+ (void)openUnrecognizedCrashGuard {
    an_swizzleClassMethod([self class], @selector(methodSignatureForSelector:), @selector(an_classMethodSignatureForSelector:));
    an_swizzleClassMethod([self class], @selector(forwardInvocation:), @selector(an_forwardClassInvocation:));
    
    an_swizzleInstanceMethod([self class], @selector(methodSignatureForSelector:), @selector(an_methodSignatureForSelector:));
    an_swizzleInstanceMethod([self class], @selector(forwardInvocation:), @selector(an_forwardInvocation:));
}

+ (NSMethodSignature*)an_classMethodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self an_classMethodSignatureForSelector:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

+ (void)an_forwardClassInvocation:(NSInvocation*)invocation {
    crashExceptionHandle([NSString stringWithFormat:@"forwardInvocation: Unrecognized static class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)]);
}


- (NSMethodSignature*)an_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* methodSignature = [self an_methodSignatureForSelector:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    return [self.class checkObjectSignatureAndCurrentClass:self.class];
}

- (void)an_forwardInvocation:(NSInvocation*)invocation {
    crashExceptionHandle([NSString stringWithFormat:@"forwardInvocation: Unrecognized instance class:%@ and selector:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector)]);
}


+ (NSMethodSignature *)checkObjectSignatureAndCurrentClass:(Class)currentClass {
    IMP originIMP = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    IMP currentClassIMP = class_getMethodImplementation(currentClass, @selector(methodSignatureForSelector:));
    
    // 已重写
    if (originIMP != currentClassIMP){
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}

@end
