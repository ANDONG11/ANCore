//
//  OpenAppleAuth.h
//  ANCore
//
//  Created by 安东 on 2020/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AppleAuthSuccess)(NSDictionary *params);
typedef void(^AppleAuthFail)(NSString *msg);

@interface OpenAppleAuth : NSObject 


@property (nonatomic, copy) AppleAuthSuccess block;
@property (nonatomic, copy) AppleAuthFail failBlock;

/// 苹果登录授权
/// @param success 成功
/// @param failBlock 失败
+ (void)appleAuthWithSuccess:(AppleAuthSuccess)success fail:(AppleAuthFail)failBlock;

@end

NS_ASSUME_NONNULL_END
