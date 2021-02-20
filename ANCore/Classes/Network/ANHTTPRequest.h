//
//  ANHTTPRequest.h
//  ANCore
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/// 上传媒体类型
typedef enum : NSUInteger {
    
    /// 图片
    UploadMediaImageType,
    
    /// 视频
    UploadMediaVideoType
    
} UploadMediaType;

@interface ANHTTPRequest : NSObject

/// 请求类型
- (RequestMethodType)requestMethodType;

/// 请求基础地址
- (NSString *)baseUrl;

/// 请求地址
- (NSString *)requestUrl;

/// 请求参数
- (nullable id)requestArgument;

/// 请求头参数
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;


/// 上传图片时图片数组
- (NSArray *)images;


/// 上传视频时视频地址
- (NSURL *)filePathURL;


/// 网络请求
/// @param success 成功
/// @param error   服务器返回错误
/// @param failure 网络请求失败
- (void)netRequestWithSuccess:(void (^)(id response))success
                        error:(void(^)(void))error
                      failure:(void (^)(NSString *msg))failure;


/// 上传多媒体类型（图片，视频）
/// @param mediaType 当为图片时需要传images参数 当为视频时需要传filePathURL参数
/// @param success 成功
/// @param error   服务器返回错误
/// @param progressHandle 进度
/// @param failure 失败
- (void)netRequestUploadMedia:(UploadMediaType)mediaType
                      success:(void (^)(id response))success
                        error:(void(^)(void))error
                     progress:(void (^)(NSProgress *progress))progressHandle
                      failure:(void (^)(NSString * msg))failure;

/// 取消网络请求
- (void)netRequestCancel;

/// 网络请求成功
/// @param response 返回数据
/// @param success 回调
/// @param error   服务器返回错误
- (void)successWithResponse:(id)response  success:(void (^)(id))success error:(void(^)(void))error;


/// 网络请求失败
/// @param error 失败
/// @param failure 回调
- (void)errorWithResponse:(NSError *)error failure:(void (^)(NSString *))failure;

@end

NS_ASSUME_NONNULL_END
