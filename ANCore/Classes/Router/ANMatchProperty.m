//
//  ANMatchProperty.m
//  Practice
//
//  Created by andong on 2020/12/25.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANMatchProperty.h"
#import <objc/runtime.h>

@implementation ANMatchProperty

+ (void)matchProperty:(id)obj params:(NSDictionary *)params {
    
    Class baseClass = [obj class];
    Class superClass = baseClass;
  
    do {
        baseClass = superClass;
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(baseClass, &propertyCount);
        
        for (int i = 0; i < propertyCount; i++) {
            @autoreleasepool {
                objc_property_t property = properties[i];
                
                /// 取出属性名称
                NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
                /// 如果参数列表中不包含当前属性则跳过当前属性
                if (![params.allKeys containsObject:propertyName]) {
                    continue;
                }
                
                /// 取出当前属性对应的值
                id value = params[propertyName];
                
                NSString *attributeString = [NSString stringWithUTF8String:property_getAttributes(property)];
                NSString *typeString = [[attributeString componentsSeparatedByString:@","] firstObject];
                /// 类名, 非基础类型
                NSString *classNameString = [[self class] getClassNameFromAttributeString:typeString];
                

                /// 字符串
                if ([value isKindOfClass:[NSString class]]) {
                    if ([classNameString isEqualToString:@"NSString"]) {
                        [[self class] assign:obj param:propertyName value:value type:typeString];
                    }
                    else if ([classNameString isEqualToString:@"NSMutableString"]) {
                        [[self class] assign:obj param:propertyName value:[NSMutableString stringWithString:value] type:typeString];
                    }
                }
                
                // 空
                else if ([value isKindOfClass:[NSNull class]]) {
                    continue;
                }
                // 其它(Block等)
                else {
                    [[self class] assign:obj param:propertyName value:value type:typeString];
                    continue;
                }
            }
        }
        
        free(properties);
        superClass = class_getSuperclass(baseClass);
    } while (superClass != baseClass && superClass != [NSObject class]);
}

+ (NSString *)getClassNameFromAttributeString:(NSString *)attributeString {
    NSString *className = nil;
    NSScanner *scanner = [NSScanner scannerWithString: attributeString];
    [scanner scanUpToString:@"T" intoString: nil];
    [scanner scanString:@"T" intoString:nil];
    if ([scanner scanString:@"@\"" intoString: &className]) {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                intoString:&className];
    }
    return className;
}

+ (void)assign:(id)obj param:(NSString *)name value:(id)v type:(NSString *)type {
    if (!name || name.length == 0) {
        return;
    }
    /// 获取方法名
    NSString *selName = [NSString stringWithFormat:@"set%@%@:", [[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]];
    SEL sel = NSSelectorFromString(selName);
    if ([obj respondsToSelector:sel]) {
        IMP imp = [obj methodForSelector:sel];
        if ([type isEqualToString:@"Td"]) {
            void (*func)(id, SEL, double) = (void *)imp;
            func(obj, sel, [v doubleValue]);
        } else if ([type isEqualToString:@"Ti"]) {
            void (*func)(id, SEL, int) = (void *)imp;
            func(obj, sel, [v intValue]);
        } else if ([type isEqualToString:@"Tf"]) {
            void (*func)(id, SEL, float) = (void *)imp;
            func(obj, sel, [v floatValue]);
        } else if ([type isEqualToString:@"Tl"]) {
            void (*func)(id, SEL, long) = (void *)imp;
            func(obj, sel, [v longValue]);
        } else if ([type isEqualToString:@"Tc"]) {
            void (*func)(id, SEL, char) = (void *)imp;
            func(obj, sel, [v charValue]);
        } else if ([type isEqualToString:@"Ts"]) {
            void (*func)(id, SEL, short) = (void *)imp;
            func(obj, sel, [v shortValue]);
        } else if ([type isEqualToString:@"TI"]) {
            void (*func)(id, SEL, unsigned int) = (void *)imp;
            func(obj, sel, [v unsignedIntValue]);
        } else if ([type isEqualToString:@"Tq"]) {
            void (*func)(id, SEL, long long) = (void *)imp;
            func(obj, sel, [v longLongValue]);
        } else if ([type isEqualToString:@"TQ"]) {
            void (*func)(id, SEL, unsigned long long) = (void *)imp;
            func(obj, sel, [v unsignedLongLongValue]);
        } else if ([type isEqualToString:@"TB"]) {
            void (*func)(id, SEL, BOOL) = (void *)imp;
            func(obj, sel, [v boolValue]);
        } else {
            void (*func)(id, SEL, id) = (void *)imp;
            func(obj, sel, v);
        }
    }
}


@end
