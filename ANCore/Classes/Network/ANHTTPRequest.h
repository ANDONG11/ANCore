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

/// 请求类型默认post
- (RequestMethodType)requestMethodType;


/// base请求地址
- (NSString *)baseUrl;


/// 请求地址
- (NSString *)requestUrl;


/// 请求参数
- (nullable id)requestArgument;


/// 请求头
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;


/// 图片数组(可上传多张图片)
/// 上传图片时必传参数
- (NSArray *)images;


/// 上传图片的质量 默认为1
- (CGFloat)compressionQuality;


/// 视频地址
/// 上传视频时必传参数 file://
- (NSURL *)filePathURL;

/// 上传图片视频时对应后端接受的名字
/// 必须重写此字段
- (NSString *)mediaName;


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

/// 下载
/// @param success 成功
/// @param error 服务器错误
/// @param progressHandle 进度
/// @param failure 网络请求失败
- (void)netRequestDownloadFileWithSuccess:(void (^)(id response))success
                                    error:(void(^)(void))error
                                 progress:(void (^)(NSProgress *progress))progressHandle
                                  failure:(void (^)(NSString *msg))failure;


/// 取消网络请求
- (void)netRequestCancel;




/// 网络请求成功（子类需重写此方法）
/// @param response 返回数据
/// @param success 成功回调
/// @param error   服务器返回错误
- (void)successWithResponse:(id)response  success:(void (^)(id))success error:(void(^)(void))error;


/// 网络请求失败（子类需重写此方法）
/// @param error 错误信息
/// @param failure 失败回调
- (void)errorWithResponse:(NSError *)error failure:(void (^)(NSString *))failure;

@end

NS_ASSUME_NONNULL_END
