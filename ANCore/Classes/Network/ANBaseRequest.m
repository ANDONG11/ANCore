//
//  ANBaseRequest.m
//  ANCore
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANBaseRequest.h"


@implementation ANBaseRequest

#pragma mark - 网络请求
+ (void)netRequestWithMethodType:(RequestMethodType)methodType
                       URLString:(NSString *)URLString
                          params:(id)params
                         headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                         success:(RequestManagerSuccessHandle)success
                         failure:(RequestManagerFailureHandle)failure {

    ANHTTPSessionManager *manager = [ANHTTPSessionManager sharedInstance];
    
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    switch (methodType) {
        case RequestMethodTypeGET:
            [manager GET:URLString parameters:params headers:headers progress:nil success:success failure:failure];
            break;
        case RequestMethodTypePOST:
            [manager POST:URLString parameters:params headers:headers progress:nil success:success failure:failure];
            break;
        case RequestMethodTypePUT:
            [manager PUT:URLString parameters:params headers:headers success:success failure:failure];
            break;
        case RequestMethodTypePATCH:
            [manager PATCH:URLString parameters:params headers:headers success:success failure:failure];
            break;
        case RequestMethodTypeDELETE:
            [manager DELETE:URLString parameters:params headers:headers success:success failure:failure];
            break;
        case RequestMethodTypeHEAD:
            [manager HEAD:URLString parameters:params headers:headers success:^(NSURLSessionDataTask * _Nonnull task) {
                !success ?: success(task, nil);
            } failure:failure];
            break;
    }
}


#pragma mark - 上传多媒体类型（图片，视频）
+ (void)netRequestPOSTImageWithURLString:(NSString *)URLString
                                  params:(id)params
                                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                formData:(nullable void (^)(id<AFMultipartFormData> _Nonnull formData))formData
                                 success:(RequestManagerSuccessHandle)success
                                 failure:(RequestManagerFailureHandle)failure
                                progress:(RequestManagerProgressHandle)progress {
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    ANHTTPSessionManager *manager = [ANHTTPSessionManager sharedInstance];
    [manager POST:URLString parameters:params headers:headers constructingBodyWithBlock:formData progress:progress success:success failure:failure];
}


#pragma mark - 下载
+ (void)netRequestDownloadFileWithURLString:(NSString *)URLString
                                   progress:(RequestManagerProgressHandle)progress
                                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                          completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    ANHTTPSessionManager *manager = [ANHTTPSessionManager sharedInstance];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:progress destination:destination completionHandler:completionHandler];
    [downloadTask resume];
}


/// 取消网络请求
+ (void)cancelRequest {
    ANHTTPSessionManager *manager = [ANHTTPSessionManager sharedInstance];
    if ([manager.tasks count] > 0) {
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}

@end
