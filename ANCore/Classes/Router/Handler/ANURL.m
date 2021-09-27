//
//  ANURL.m
//  ZBMOM
//
//  Created by dong an on 2021/9/23.
//

#import "ANURL.h"
#import "NSString+URL.h"

@interface ANURL ()

@property (nonatomic, copy) NSString *incomingString;

@end

@implementation ANURL

- (instancetype)initWithString:(NSString *)string {
    
    [self parseURLFromString:string];
    
    return self;
}


- (void)parseURLFromString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]] || [string length] == 0) {
        self.incomingString = string;
        return;
    }
    self.incomingString = string;
    NSRange range = [string rangeOfString:@"://"];
    if (range.location == NSNotFound) {
        range = [string rangeOfString:@":/"];
    }
    if (range.location == NSNotFound) {
        // URL格式错误(scheme检测失败)
        return;
    }
    
    // 协议
    self.aScheme = [string substringToIndex:range.location];
    
    // 参数列表
    self.aQuery = [string getURLParameters];
    
    // 去除协议头
    string = [string substringFromIndex:range.location + range.length];
    
    // 去除参数列表
    NSRange questionRange = [string rangeOfString:@"?"];
    if (questionRange.location != NSNotFound) {
        string = [string substringToIndex:questionRange.location];
    }
    
    // 域和地址
    NSRange bslashRange = [string rangeOfString:@"/"];
    if (bslashRange.location != NSNotFound) {
        self.aHost = [string substringToIndex:bslashRange.location];
        self.aPath = [string substringFromIndex:bslashRange.location + bslashRange.length];
    } else {
        self.aHost = string;
        self.aPath = @"";
    }
}

- (NSString *)urlString {
    NSString *urlString = [self generateURLString];
    if (urlString && [urlString length] > 0) {
        return urlString;
    }
    return self.incomingString;
}

- (NSString *)generateURLString {
    if (![self.scheme isKindOfClass:[NSString class]] || [self.scheme length] == 0) {
        return nil;
    }
    if (![self.host isKindOfClass:[NSString class]] || [self.host length] == 0) {
        return nil;
    }
    
    NSMutableString *finalURL = [NSMutableString new];
    NSString *url = [NSString stringWithFormat:@"%@://%@", self.scheme, self.host];
    [finalURL appendString:url];
    
    NSArray *params = [self queryparams];
    if (params && [params count] > 0) {
        [finalURL appendString:@"?"];
        [finalURL appendString:[params componentsJoinedByString:@"&"]];
    }
    return [NSString stringWithString:finalURL];
}

- (NSArray *)queryparams {
    if (![self.query isKindOfClass:[NSDictionary class]] || [self.aQuery count] == 0) {
        return nil;
    }
    NSMutableArray *params = [NSMutableArray new];
    NSString *paramRegex = @"[a-zA-Z_][a-zA-Z0-9_]{0,}";
    NSPredicate *paramPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", paramRegex];
    [self.aQuery enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([paramPredicate evaluateWithObject:key]) {
            if ([obj isKindOfClass:[NSString class]] && [obj length] > 0) {
                // 字符串
                [params addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
            } else if ([obj isKindOfClass:[NSNumber class]]) {
                // 数字
                NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
                NSString *str = [formater stringFromNumber:obj];
                if (str && str.length > 0) {
                    [params addObject:[NSString stringWithFormat:@"%@=%@", key, str]];
                }
            } else if ([obj isKindOfClass:[NSArray class]] && [obj count] > 0) {
                // 数组(子项只取字符串/数字)
                [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                    if ([obj1 isKindOfClass:[NSString class]] && [obj1 length] > 0) {
                        [params addObject:[NSString stringWithFormat:@"%@=%@", key, obj1]];
                    } else if ([obj1 isKindOfClass:[NSNumber class]]) {
                        NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
                        NSString *str = [formater stringFromNumber:obj1];
                        if (str && str.length > 0) {
                            [params addObject:[NSString stringWithFormat:@"%@=%@", key, str]];
                        }
                    }
                }];
            }
        }
    }];
    return [NSArray arrayWithArray:params];
}


@end
