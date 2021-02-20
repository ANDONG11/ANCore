//
//  ANHTTPRequest.m
//  ANCore
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANHTTPRequest.h"

@implementation ANHTTPRequest

-(NSString *)baseUrl {
    return @"";
}

- (NSString *)requestUrl {
    return @"";
}

- (RequestMethodType)requestMethodType {
    return RequestMethodTypePOST;
}

- (id)requestArgument {
    return @{};
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return nil;
}

-(NSArray *)images {
    return @[];
}

-(NSURL *)filePathURL {
    return [NSURL URLWithString:@""];
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

    /// 根据媒体类型判断是否传入相应参数
    /// 如果没传入则直接崩溃
    switch (mediaType) {
        case UploadMediaImageType:
            NSAssert(overridImageMethod, @"上传图片时必须重写images方法传入图片数组");
            break;
        case UploadMediaVideoType:
            NSAssert(overridVideoMethod, @"上传视频时必须重写filePathURL传入视频地址");
            break;
            
        default:
            break;
    }

    
    [ANBaseRequest netRequestPOSTImageWithURLString:[self requestUrl]
                                             params:[self requestArgument]
                                            headers:[self requestHeaderFieldValueDictionary]
                                           formData:^(id<AFMultipartFormData> _Nonnull formData) {
        switch (mediaType) {
            case UploadMediaImageType:
            {
                for (UIImage *image in [self images]) {
                    NSData *imageData;
                    if (UIImagePNGRepresentation(image) == nil) {
                        imageData = UIImageJPEGRepresentation(image, 0.8);
                    } else {
                        imageData = UIImagePNGRepresentation(image);
                    }
                    [formData appendPartWithFileData:imageData name:@"image" fileName:[[self fileName] stringByAppendingString:@".png"] mimeType:@"image/png"];
                }
            }
                break;
            case UploadMediaVideoType:
            {
                [formData appendPartWithFileURL:[self filePathURL] name:@"video" fileName:[self fileName] mimeType:@"application/octet-stream" error:nil];
            }
                break;
                
            default:
                break;
        }
        
    } success:^(NSURLSessionTask * _Nullable task, id  _Nullable response) {
        [self successWithResponse:response success:success error:error];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error) {
        [self errorWithResponse:error failure:failure];
    } progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressHandle(progress);
            NSLog(@"%f",progress.fractionCompleted);
        });
    }];
}

- (NSString *)fileName {
    // 设置时间格式(给个时间便于区分)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark -取消网络请求
- (void)netRequestCancel {
    [ANBaseRequest cancelRequest];
}

#pragma mark - 网络请求成功返回
- (void)successWithResponse:(id)response success:(void (^)(id))success error:(void (^)(void))error {

}

#pragma mark - 网络请求失败
- (void)errorWithResponse:(NSError *)error failure:(void (^)(NSString *))failure {
    failure(@"请求失败");
}

@end
