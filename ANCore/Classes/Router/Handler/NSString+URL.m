//
//  NSString+URL.m
//  ZBMOM
//
//  Created by dong an on 2021/9/23.
//

#import "NSString+URL.h"

@implementation NSString (URL)

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters {
    /// 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    /// 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    /// 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        /// 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            /// 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            /// Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                /// 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    /// 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                /// 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        /// 单个参数
        
        /// 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        /// 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        /// 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        /// Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        /// 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

@end
