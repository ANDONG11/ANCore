//
//  ANBaseRequest.h
//  ANCore
//
//  Created by andong on 2020/12/28.
//  Copyright © 2020 andong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN
/// 请求成功回调
typedef void(^RequestManagerSuccessHandle)(NSURLSessionTask * _Nullable task, id _Nullable response);

/// 请求失败回调
typedef void(^RequestManagerFailureHandle)(NSURLSessionTask * _Nullable task, NSError * _Nullable error);

/// 进度回调
typedef void (^RequestManagerProgressHandle)(NSProgress * _Nonnull progress);

/// 请求方式
typedef NS_ENUM(NSUInteger, RequestMethodType) {
  
  /// GET请求
  RequestMethodTypeGET,
  
  /// POST请求
  RequestMethodTypePOST,
  
  /// PUT请求
  RequestMethodTypePUT,
  
  /// DELETE请求
  RequestMethodTypeDELETE,
  
  /// PATCH请求
  RequestMethodTypePATCH,
  
  /// HEAD请求
  RequestMethodTypeHEAD
  
};

@interface ANBaseRequest : NSObject

/**
 请求数据

 @param methodType 请求方式
 @param URLString URL地址
 @param params 参数
 @param success 正确回调
 @param failure 失败回调
 */
+ (void)netRequestWithMethodType:(RequestMethodType)methodType
                       URLString:(NSString *_Nullable)URLString
                          params:(id _Nullable)params
                         headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                         success:(RequestManagerSuccessHandle _Nullable )success
                         failure:(RequestManagerFailureHandle _Nullable )failure;


/**
 上传多媒体类型
 
 @param URLString 请求地址
 @param params 参数
 @param success 正确回调
 @param failure 失败回调
 @param progress 进度回调
 */
+ (void)netRequestPOSTImageWithURLString:(NSString *_Nullable)URLString
                                  params:(id _Nullable)params
                                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                                formData:(nullable void (^)(id<AFMultipartFormData> _Nonnull formData))formData
                                 success:(RequestManagerSuccessHandle _Nullable )success
                                 failure:(RequestManagerFailureHandle _Nullable )failure
                                progress:(RequestManagerProgressHandle _Nullable)progress;




/**
 下载文件
 
 @param URLString 请求地址
 @param progress 进度
 @param destination 为确定下载文件的目的地而执行的块对象
 @param completionHandler 任务完成时要执行的块。此块没有返回值，并接受三个参数：服务器响应、下载文件的路径以及描述发生的网络或解析错误（如果有）的错误。
 */
+ (void)netRequestDownloadFileWithURLString:(NSString *)URLString
                                   progress:(RequestManagerProgressHandle)progress
                                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                          completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/// 取消网络请求
+ (void)cancelRequest;


@end

NS_ASSUME_NONNULL_END
