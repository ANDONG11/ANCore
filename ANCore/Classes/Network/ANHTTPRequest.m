//
//  ANHTTPRequest.m
//  Practice
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANHTTPRequest.h"

@implementation ANHTTPRequest

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
- (void)netRequestWithSuccess:(void (^)(id response))success failure:(void (^)(NSString *msg))failure {

    [ANBaseRequest netRequestWithMethodType:[self requestMethodType]
                                  URLString:[self requestUrl]
                                     params:[self requestArgument]
                                    headers:[self requestHeaderFieldValueDictionary]
                                    success:^(NSURLSessionTask * _Nullable task, id  _Nullable response) {
        [self successWithResponse:response successBlock:success];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error) {
        [self errorWithResponse:error];
    }];
}

#pragma mark - 上传图片或视频
- (void)netRequestUploadMedia:(UploadMediaType)mediaType
                      success:(void (^)(id response))success
                     progress:(void (^)(NSProgress *progress))progressHandle
                      failure:(void (^)(NSString * msg))failure {
    

    BOOL overridImageMethod = [self.class instanceMethodForSelector:@selector(images)] != [ANHTTPRequest instanceMethodForSelector:@selector(images)];
    BOOL overridVideoMethod = [self.class instanceMethodForSelector:@selector(filePathURL)] != [ANHTTPRequest instanceMethodForSelector:@selector(filePathURL)];

    if (!overridImageMethod && mediaType == UploadMediaImageType) {
        NSLog(@"上传图片时必须重写images方法传入图片数组");
        return;
    }
    
    if (!overridVideoMethod && mediaType == UploadMediaVideoType) {
        NSLog(@"上传视频时必须重写filePathURL传入视频地址");
        return;
    }
    
    [ANBaseRequest netRequestPOSTImageWithURLString:[self requestUrl]
                                             params:[self requestArgument]
                                            headers:[self requestHeaderFieldValueDictionary]
                                           formData:^(id<AFMultipartFormData> _Nonnull formData) {
        switch (mediaType) {
            case UploadMediaImageType:
            {
                for (UIImage *image in [self images]) {
                    // 设置时间格式(给个时间便于区分)
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *fileName = [formatter stringFromDate:[NSDate date]];
                    NSData *imageData;
                    if (UIImagePNGRepresentation(image) == nil) {
                        imageData = UIImageJPEGRepresentation(image, 0.8);
                    } else {
                        imageData = UIImagePNGRepresentation(image);
                    }
                    [formData appendPartWithFileData:imageData name:@"image" fileName:[fileName stringByAppendingString:@".png"] mimeType:@"image/png"];
                }
            }
                break;
            case UploadMediaVideoType:
            {
                // 设置时间格式(给个时间便于区分)
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *fileName = [formatter stringFromDate:[NSDate date]];
                [formData appendPartWithFileURL:[self filePathURL] name:@"video" fileName:fileName mimeType:@"application/octet-stream" error:nil];
            }
                break;
                
            default:
                break;
        }
        
    } success:^(NSURLSessionTask * _Nullable task, id  _Nullable response) {
        [self successWithResponse:response successBlock:success];
    } failure:^(NSURLSessionTask * _Nullable task, NSError * _Nullable error) {
        [self errorWithResponse:error];
    } progress:^(NSProgress * _Nonnull progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progressHandle(progress);
            NSLog(@"%f",progress.fractionCompleted);
        });
    }];
}

#pragma mark - 网络请求成功返回
- (void)successWithResponse:(id)responseObject successBlock:(void (^)(id response))block {
  NSData *data = responseObject;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  int code = [dic[@"code"] intValue];
  if (code == 200) {
    block(dic[@"data"]);
  }  else {
//    [self errorCodeShowWithCode:code errorMsg:dic[@"message"]];
  }
}

#pragma mark - 网络请求失败
- (void)errorWithResponse:(NSError *)error {
//  NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//  NSString * text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//  if ([CommonUtil checkStringIsValided:text]) {
//    NSDictionary *dic = [self dictionaryWithJsonString:text];
//    text = [NSString stringWithFormat:@"远程服务器连接失败，错误码%@",dic[@"status"]];
//  } else {
//    text = error.localizedDescription;
//  }
//  [ProgressHUDManager showHUDAutoHiddenWithError:text];
//  self.failureBlock();
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
  if (jsonString == nil) {
    return nil;
  }
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  if(err) {
    NSLog(@"json解析失败：%@",err);
    return nil;
  }
  return dic;
}

@end
