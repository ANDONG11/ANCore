//
//  ANHook.m
//  Practice
//
//  Created by andong on 2020/12/23.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANHook.h"
#import <objc/runtime.h>

@implementation ANHook

+ (void)hookClass:(Class)classObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    
    Class class = classObject;
    
    Method fromMethod = class_getInstanceMethod(class, fromSelector);
    
    Method toMethod = class_getInstanceMethod(class, toSelector);
    
    /// 返回成功则被替换方法toMethod 没被实现
    if (class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        /// 进行方法替换
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        /// 交换imp指针
        method_exchangeImplementations(fromMethod, toMethod);
    }
    
}

@end
