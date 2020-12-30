//
//  NSObject+ANSwizzleHook.m
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSObject+ANSwizzleHook.h"
#import <objc/runtime.h>


#pragma mark - C
void an_swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
    if (!cls) {
        return;
    }
    Method originalMethod = class_getClassMethod(cls, originSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzleSelector);
    NSCAssert(NULL != originalMethod,
               @"originSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(originSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
    NSCAssert(NULL != swizzledMethod,
               @"swizzleSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(swizzleSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    if (class_addMethod(metacls, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) ) {
        
        class_replaceMethod(metacls, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void an_swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
    if (!cls) {
        return;
    }
    Method originalMethod = class_getInstanceMethod(cls, originSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzleSelector);
     
    NSCAssert(NULL != originalMethod,
               @"originSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(originSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
    NSCAssert(NULL != swizzledMethod,
               @"swizzleSelector %@ not found in %@ methods of class %@.",
               NSStringFromSelector(swizzleSelector),
               class_isMetaClass(cls) ? @"class" : @"instance",
               cls);
     
    if (class_addMethod(cls, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) ) {
        
        class_replaceMethod(cls, swizzleSelector, method_getImplementation(originalMethod),  method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation NSObject (ANSwizzleHook)

+ (void)an_swizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector {
    an_swizzleClassMethod(self.class, originSelector, swizzleSelector);
}

- (void)an_swizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector {
    an_swizzleInstanceMethod(self.class, originSelector, swizzleSelector);
}



@end
