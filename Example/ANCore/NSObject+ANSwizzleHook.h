//
//  NSObject+ANSwizzleHook.h
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

void an_swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector);
void an_swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector);
void an_swizzleKVODeallocIfNeeded(Class class);

@interface NSObject (ANSwizzleHook)

+ (void)an_swizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;
- (void)an_swizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;

@end

NS_ASSUME_NONNULL_END
