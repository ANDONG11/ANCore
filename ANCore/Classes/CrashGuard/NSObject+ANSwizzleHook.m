//
//  NSObject+ANSwizzleHook.m
//  ANCore
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "NSObject+ANSwizzleHook.h"


static const void *anKVODeallocAssociatedKey = &anKVODeallocAssociatedKey;

#pragma mark - C
//void an_swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
//    if (!cls) {
//        return;
//    }
//    Method originalMethod = class_getClassMethod(cls, originSelector);
//    Method swizzledMethod = class_getClassMethod(cls, swizzleSelector);
//    NSCAssert(NULL != originalMethod,
//               @"originSelector %@ not found in %@ methods of class %@.",
//               NSStringFromSelector(originSelector),
//               class_isMetaClass(cls) ? @"class" : @"instance",
//               cls);
//    NSCAssert(NULL != swizzledMethod,
//               @"swizzleSelector %@ not found in %@ methods of class %@.",
//               NSStringFromSelector(swizzleSelector),
//               class_isMetaClass(cls) ? @"class" : @"instance",
//               cls);
//    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
//    if (class_addMethod(metacls, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) ) {
//
//        class_replaceMethod(metacls, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//void an_swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector) {
//    if (!cls) {
//        return;
//    }
//    Method originalMethod = class_getInstanceMethod(cls, originSelector);
//    Method swizzledMethod = class_getInstanceMethod(cls, swizzleSelector);
//
//    NSCAssert(NULL != originalMethod,
//               @"originSelector %@ not found in %@ methods of class %@.",
//               NSStringFromSelector(originSelector),
//               class_isMetaClass(cls) ? @"class" : @"instance",
//               cls);
//    NSCAssert(NULL != swizzledMethod,
//               @"swizzleSelector %@ not found in %@ methods of class %@.",
//               NSStringFromSelector(swizzleSelector),
//               class_isMetaClass(cls) ? @"class" : @"instance",
//               cls);
//
//    if (class_addMethod(cls, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) ) {
//
//        class_replaceMethod(cls, swizzleSelector, method_getImplementation(originalMethod),  method_getTypeEncoding(originalMethod));
//
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}

//BOOL an_requiresDeallocSwizzle(Class class) {
//    BOOL swizzled = NO;
//    for ( Class currentClass = class; !swizzled && currentClass != nil; currentClass = class_getSuperclass(currentClass) ) {
//        swizzled = [objc_getAssociatedObject(currentClass, anKVODeallocAssociatedKey) boolValue];
//    }
//    return !swizzled;
//}
//
//void an_swizzleKVODeallocIfNeeded(Class class) {
//    static SEL deallocSEL = NULL;
//    static SEL cleanupSEL = NULL;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        deallocSEL = sel_getUid("dealloc");
//        cleanupSEL = sel_getUid("mk_cleanKVO");
//    });
//    @synchronized (class) {
//        if ( !an_requiresDeallocSwizzle(class) ) {
//            return;
//        }
//        objc_setAssociatedObject(class, anKVODeallocAssociatedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    Method dealloc = NULL;
//    unsigned int count = 0;
//    Method* method = class_copyMethodList(class, &count);
//    for (unsigned int i = 0; i < count; i++) {
//        if (method_getName(method[i]) == deallocSEL) {
//            dealloc = method[i];
//            break;
//        }
//    }
//    if ( dealloc == NULL ) {
//        Class superclass = class_getSuperclass(class);
//        class_addMethod(class, deallocSEL, imp_implementationWithBlock(^(__unsafe_unretained id self) {
//            ((void(*)(id, SEL))objc_msgSend)(self, cleanupSEL);
//            struct objc_super superStruct = (struct objc_super){ self, superclass };
//            ((void (*)(struct objc_super*, SEL))objc_msgSendSuper)(&superStruct, deallocSEL);
//        }), method_getTypeEncoding(dealloc));
//    }else{
//        __block IMP deallocIMP = method_setImplementation(dealloc, imp_implementationWithBlock(^(__unsafe_unretained id self) {
//            ((void(*)(id, SEL))objc_msgSend)(self, cleanupSEL);
//            ((void(*)(id, SEL))deallocIMP)(self, deallocSEL);
//        }));
//    }
//}


@implementation NSObject (ANSwizzleHook)

+ (void)an_swizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector {
//    an_swizzleClassMethod(self.class, originSelector, swizzleSelector);
    Class cls = self.class;
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

- (void)an_swizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector {
//    an_swizzleInstanceMethod(self.class, originSelector, swizzleSelector);
    Class cls = self.class;
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



@end
