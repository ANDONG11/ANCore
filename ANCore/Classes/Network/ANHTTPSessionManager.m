//
//  ANHTTPSessionManager.m
//  Practice
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANHTTPSessionManager.h"

@implementation ANHTTPSessionManager

static ANHTTPSessionManager *_instance = nil;

static NSString *baseUrl = @"";


+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ANHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
        // 申明请求的数据是json类型
        _instance.requestSerializer  = [AFJSONRequestSerializer serializer];
        // 申明返回的结果类型
        _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 如果报接受类型不一致请替换一致text/html或别的
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/json", @"text/javascript",@"text/html",
                                                             @"text/plain",@"text/xml", nil];
        
        // 设置网络超时时间为30s，默认为60s
        _instance.requestSerializer.timeoutInterval = 30.f;
        // 采用https请求
        _instance.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _instance.securityPolicy.allowInvalidCertificates = YES;
        _instance.securityPolicy.validatesDomainName = NO;
    });
    
    return _instance;
}

+ (BOOL)netWorkReachability {
  __block BOOL netState = NO;
  
  // 监控网络状态变化
  NSOperationQueue *operationQueue = _instance.operationQueue;
  [_instance.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    switch (status) {
      case AFNetworkReachabilityStatusReachableViaWWAN:
      case AFNetworkReachabilityStatusReachableViaWiFi:
        [operationQueue setSuspended:NO];
        netState = YES;
        break;
      case AFNetworkReachabilityStatusNotReachable:
      default:
        [operationQueue setSuspended:YES];
        netState = NO;
        break;
    }
  }];
  
  [_instance.reachabilityManager startMonitoring];
  
  return netState;
}

@end
