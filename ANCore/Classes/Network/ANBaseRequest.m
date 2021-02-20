//
//  ANBaseRequest.m
//  ANCore
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANBaseRequest.h"


@implementation ANBaseRequest

/**
 请求数据
 
 @param methodType 请求方式
 @param URLString URL地址
 @param params 参数
 @param success 正确回调
 @param failure 失败回调
 */
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


/**
 上传多媒体类型
 
 @param URLString 请求地址
 @param params 参数
 @param success 正确回调
 @param failure 失败回调
 */
+ (void)netRequestPOSTImageWithURLString:(NSString *)URLString
                                  params:(id)params
                                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                formData:(nullable void (^)(id<AFMultipartFormData> _Nonnull formData))formData
                                 success:(RequestManagerSuccessHandle)success
                                 failure:(RequestManagerFailureHandle)failure
                                progress:(RequestManagerProgressHandle)progress {
    
    ANHTTPSessionManager *manager = [ANHTTPSessionManager sharedInstance];
    [manager POST:URLString parameters:params headers:headers constructingBodyWithBlock:formData progress:progress success:success failure:failure];
}


/**
 下载文件
 
 @param URLString 请求地址
 @param successHandle 正确回调
 */
+ (void)netRequestDownloadFileWithURLString:(NSString *)URLString successHandle:(RequestManagerSuccessHandle)successHandle {

    ANHTTPSessionManager *manager = [ANHTTPSessionManager sharedInstance];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //    NSString *documentsDirectory = [paths objectAtIndex:0];
        //    NSString *inputPath = [documentsDirectory stringByAppendingPathComponent:@"/model.scnassets.zip"];
        //    NSError *zipError = nil;
        
        //    [SSZipArchive unzipFileAtPath:inputPath toDestination:documentsDirectory overwrite:YES password:nil error:&zipError];
        //
        //    if( zipError ){
        //      NSLog(@"Something went wrong while unzipping: %@", zipError.debugDescription);
        //    }else {
        //      NSLog(@"%@",inputPath);
        //      NSError * error = nil ;
        //      [[NSFileManager defaultManager ] removeItemAtPath :inputPath error :&error];
        //      successHandle(nil,nil);
        //    }
    }];
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
