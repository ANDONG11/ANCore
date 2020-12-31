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
// 请求成功回调
typedef void(^RequestManagerSuccessHandle)(NSURLSessionTask * _Nullable task, id _Nullable response);

// 请求失败回调
typedef void(^RequestManagerFailureHandle)(NSURLSessionTask * _Nullable task, NSError * _Nullable error);

// 进度回调
typedef void (^RequestManagerProgressHandle)(NSProgress * _Nonnull progress);

// 请求方式
typedef enum : NSUInteger {
  
  // GET请求
  RequestMethodTypeGET,
  
  // POST请求
  RequestMethodTypePOST,
  
  // PUT请求
  RequestMethodTypePUT,
  
  // DELETE请求
  RequestMethodTypeDELETE,
  
  // PATCH请求
  RequestMethodTypePATCH,
  
  // HEAD请求
  RequestMethodTypeHEAD
  
} RequestMethodType;

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
 @param successHandle 正确回调
 */
+ (void)netRequestDownloadFileWithURLString:(NSString *_Nullable)URLString successHandle:(RequestManagerSuccessHandle _Nullable )successHandle;
@end

NS_ASSUME_NONNULL_END
