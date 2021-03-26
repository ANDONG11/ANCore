//
//  OpenAppleAuth.m
//  ANCore
//
//  Created by 安东 on 2020/5/29.
//

#import "OpenAppleAuth.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface OpenAppleAuth () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end

@implementation OpenAppleAuth

+ (OpenAppleAuth *)sharedInstance {
    static OpenAppleAuth *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+ (void)appleAuthWithSuccess:(AppleAuthSuccess)success fail:(AppleAuthFail)failBlock API_AVAILABLE(ios(13.0)) {
    [[OpenAppleAuth sharedInstance] appleAuthWithSuccess:success fail:failBlock];
}

- (void)appleAuthWithSuccess:(AppleAuthSuccess)block fail:(AppleAuthFail)failblock API_AVAILABLE(ios(13.0)) {
    self.block = block;
    self.failBlock = failblock;

    /// 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
    ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    /// 创建新的AppleID 授权请求
    ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
    /// 在用户授权期间请求的联系信息
    appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    /// 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
    /// 设置授权控制器通知授权请求的成功与失败的代理
    authorizationController.delegate = self;
    /// 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
    authorizationController.presentationContextProvider = self;
    /// 在控制器初始化期间启动授权流
    [authorizationController performRequests];
}

#pragma mark- ASAuthorizationControllerDelegate
/// 授权成功
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        ASAuthorizationAppleIDCredential * credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        
        /// 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
        NSString * userID = credential.user;
        /// 苹果用户信息 如果授权过，可能无法再次获取该信息
        NSPersonNameComponents * fullName = credential.fullName;
        NSString * email = credential.email;
        /// 服务器验证需要使用的参数
        NSString * authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString * identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        /// 用于判断当前登录的苹果账号是否是一个真实用户，取值有：unsupported、unknown、likelyReal
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        
        NSString *name = [NSString stringWithFormat:@"%@%@",fullName.familyName,fullName.givenName];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:userID forKey:@"userId"];
        [params setObject:email ? email : @"" forKey:@"email"];
        [params setObject:name forKey:@"fullName"];
        [params setObject:identityToken forKey:@"identityToken"];
        [params setObject:@(realUserStatus) forKey:@"realUserStatus"];
        [params setObject:authorizationCode forKey:@"authorizationCode"];
        
        if (self.block) {
            self.block(params);
        }
    }
}

/// 授权失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    if (self.failBlock) {
        self.failBlock(errorMsg);
    }
    NSLog(@"%@", errorMsg);
}

/// 告诉代理应该在哪个window 展示内容给用户
- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return [UIApplication sharedApplication].windows.lastObject;
}



@end
