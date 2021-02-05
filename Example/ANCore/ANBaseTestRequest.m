//
//  ANBaseTestRequest.m
//  ANCore_Example
//
//  Created by andong on 2021/1/11.
//  Copyright © 2021 ANDONG11. All rights reserved.
//

#import "ANBaseTestRequest.h"

@implementation ANBaseTestRequest

-(NSString *)baseUrl {
    return @"123";
}
/// 设置基本参数
-(id)requestArgument {
    NSMutableDictionary *params = [[super requestArgument] mutableCopy];
    return params;
}

- (void)successWithResponse:(id)response success:(void (^)(id _Nonnull))success error:(nonnull void (^)(void))error
{
    success(@"");
}


-(void)errorWithResponse:(NSError *)error failure:(void (^)(NSString * _Nonnull))failure {
    failure(@"请求失败");
}

@end
