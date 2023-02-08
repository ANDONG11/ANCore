//
//  ANHTTPRequest.m
//  ANCore
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANHTTPRequest.h"

@implementation ANHTTPRequest

#pragma mark - 网络请求基础地址
- (NSString *)baseUrl {
    return @"";
}

#pragma mark - 请求地址
- (NSString *)requestUrl {
    return @"";
}

#pragma mark - 请求类型
- (RequestMethodType)requestMethodType {
    return RequestMethodTypePOST;
}

#pragma mark - 参数
- (id)requestArgument {
    return @{};
}

#pragma mark - 请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return nil;
}

#pragma mark - 上传多媒体类型-图片 必传参数图片数组
- (NSArray *)images {
    return @[];
}

#pragma mark - 上传多媒体类型-图片 图片上传质量
- (CGFloat)compressionQuality {
    return 1.0;
}

#pragma mark - 上传多媒体类型-视频 必传参数视频地址
- (NSURL *)filePathURL {
    return [NSURL URLWithString:@""];
}

#pragma mark - 上传图片视频时对应后台接收参数名
- (NSString *)mediaName {
    return @"";
}

#pragma mark - 网络请求
- (void)netRequestWithSuccess:(void (^)(id response))success
                        error:(void(^)(void))error
                      failure:(void (^)(NSString *msg))failure {
    NSString *urlString = [self requestUrl];
    urlString = [[self baseUrl] stringByAppendingString:urlString];
    [ANBaseRequest netRequestWithMethodType:[self requestMethodType]
                                  URLString:urlString
                                     params:[self requestArgument]
                                    headers:[self requestHeaderFieldValueDictionary]
                                    success:^(NSURLSessionTask * _Nullable task, id  _Nullable response) {
        [self successWithResponse:response success:success error:error];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error) {
        if (task.error.code == NSURLErrorCancelled) {
            return;
        }
        [self errorWithResponse:error failure:failure];
    }];
}

#pragma mark - 上传图片或视频
- (void)netRequestUploadMedia:(UploadMediaType)mediaType
                      success:(void (^)(id response))success
                        error:(void(^)(void))error
                     progress:(void (^)(NSProgress *progress))progressHandle
                      failure:(void (^)(NSString * msg))failure {
    NSString *urlString = [self requestUrl];
    urlString = [[self baseUrl] stringByAppendingString:urlString];
    /// 是否重写父类方法
    BOOL overridImageMethod = [self.class instanceMethodForSelector:@selector(images)] != [ANHTTPRequest instanceMethodForSelector:@selector(images)];
    BOOL overridVideoMethod = [self.class instanceMethodForSelector:@selector(filePathURL)] != [ANHTTPRequest instanceMethodForSelector:@selector(filePathURL)];
    BOOL overridNameMethod = [self.class instanceMethodForSelector:@selector(mediaName)] != [ANHTTPRequest instanceMethodForSelector:@selector(mediaName)];
    NSAssert(overridNameMethod, @"上传图片视频时必须传入mediaName参数");
    /// 根据媒体类型判断是否传入相应参数
    /// 如果没传入则直接崩溃
    switch (mediaType) {
        case UploadMediaImageType:
            NSAssert(overridImageMethod, @"上传图片时必须重写images方法传入图片数组");
            break;
        case UploadMediaVideoType:
            NSAssert(overridVideoMethod, @"上传视频时必须重写filePathURL传入视频地址");
            break;
        case UploadMediaFileType:
            NSAssert(overridVideoMethod, @"上传文件时必须重写filePathURL传入视频地址");
            break;
            
        default:
            break;
    }

    
    [ANBaseRequest netRequestPOSTImageWithURLString:urlString
                                             params:[self requestArgument]
                                            headers:[self requestHeaderFieldValueDictionary]
                                           formData:^(id<AFMultipartFormData> _Nonnull formData) {
        switch (mediaType) {
            case UploadMediaImageType:
            {
                /// 图片上传
                for (UIImage *image in [self images]) {
                    NSData *imageData = UIImageJPEGRepresentation(image, [self compressionQuality]);
                    [formData appendPartWithFileData:imageData
                                                name:[self mediaName]
                                            fileName:[[self fileName] stringByAppendingString:@".jpeg"]
                                            mimeType:@"image/jpeg"];
                }
            }
                break;
            case UploadMediaVideoType:
            {
                /// 视频上传
                [formData appendPartWithFileURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",[self filePathURL].path]]
                                           name:[self mediaName]
                                       fileName:[[self fileName] stringByAppendingString:@".mp4"]
                                       mimeType:@"video/mp4"
                                          error:nil];
            }
                break;
            case UploadMediaFileType:
            {
                /// 文件上传
                [formData appendPartWithFileURL:[self filePathURL]
                                           name:[self mediaName]
                                       fileName:[[self fileName] stringByAppendingString:[NSString stringWithFormat:@".%@",[self filePathURL].pathExtension]]
                                       mimeType:@"application/octet-stream"
                                          error:nil];
            }
                break;
                
            default:
                break;
        }
        
    } success:^(NSURLSessionTask * _Nullable task, id  _Nullable response) {
        if (mediaType == UploadMediaVideoType) {
            /// 视频上传成功后删除视频转码缓存
            if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePathURL].path]) {
                [[NSFileManager defaultManager] removeItemAtPath:[self filePathURL].path error:nil];
            }
        }
        [self successWithResponse:response success:success error:error];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error) {
        if (task.error.code == NSURLErrorCancelled) {
            return;
        }
        [self errorWithResponse:error failure:failure];
    } progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressHandle(progress);
            NSLog(@"%f",progress.fractionCompleted);
        });
    }];
}

#pragma mark - 下载
- (void)netRequestDownloadFileWithSuccess:(void (^)(id response))success
                                    error:(void(^)(void))error
                                 progress:(void (^)(NSProgress *progress))progressHandle
                                  failure:(void (^)(NSString *msg))failure {
    NSString *urlString = [self requestUrl];
    urlString = [[self baseUrl] stringByAppendingString:urlString];
    [ANBaseRequest netRequestDownloadFileWithURLString:urlString progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressHandle(progress);
            NSLog(@"%f",progress.fractionCompleted);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
//            NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            NSString *inputPath = [documentsDirectory stringByAppendingPathComponent:@"/model.scnassets.zip"];
//            NSError *zipError = nil;
//
//            [SSZipArchive unzipFileAtPath:inputPath toDestination:documentsDirectory overwrite:YES password:nil error:&zipError];
//
//            if( zipError ){
//              NSLog(@"Something went wrong while unzipping: %@", zipError.debugDescription);
//            }else {
//              NSLog(@"%@",inputPath);
//              NSError * error = nil ;
//              [[NSFileManager defaultManager ] removeItemAtPath :inputPath error :&error];
//              successHandle(nil,nil);
//            }
    }];
}

/// 文件名字
- (NSString *)fileName {
    /// 设置时间格式(给个时间便于区分)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark -取消网络请求
- (void)netRequestCancel {
    [ANBaseRequest cancelRequest];
}

#pragma mark - 网络请求成功返回 子类需重写此方法
- (void)successWithResponse:(id)response success:(void (^)(id))success error:(void (^)(void))error {

}

#pragma mark - 网络请求失败 子类需重写此方法
- (void)errorWithResponse:(NSError *)error failure:(void (^)(NSString *))failure {
    
}

@end
