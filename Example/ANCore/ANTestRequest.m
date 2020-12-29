//
//  ANTestRequest.m
//  ANCore_Example
//
//  Created by andong on 2020/12/29.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "ANTestRequest.h"

@implementation ANTestRequest {
    NSString *_test;
}

-(NSString *)requestUrl {
    return @"ssss";
}

-(id)requestArgument {
    NSMutableDictionary *params = [[super requestArgument] mutableCopy];
    [params setObject:_test forKey:@"test"];
    return params;
}

- (instancetype)initWithTest:(NSString *)test {
    if (self = [super init]) {
        _test = test;
    }
    return self;
}

@end
