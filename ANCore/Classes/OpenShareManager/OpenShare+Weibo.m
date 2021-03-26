//
//  OpenShare+Weibo.m
//  ANCore
//
//  Created by dong an on 2021/3/25.
//  Copyright © 2021 andong. All rights reserved.
//

#import "OpenShare+Weibo.h"

@implementation OpenShare (Weibo)

static NSString *scheme = @"Weibo";

#pragma mark - 连接微博
+ (void)connectWeiboWithAppKey:(NSString *)appKey {
    [self set:scheme Keys:@{@"appKey":appKey}];
}

+ (void)connectWeiboWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURI:(NSString *)redirectURI {
    [self set:scheme Keys:@{@"appKey":appKey,
                            @"appSecret":appSecret,
                            @"redirectURI":redirectURI}];
}

#pragma mark - 是否安装微博
+ (BOOL)isWeiboInstalled {
    return [self canOpen:@"weibosdk://request"];
}

+ (void)shareToWeibo:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail{
    NSLog(@"=====%@",msg);
    if (![self beginShare:scheme Message:msg Success:success Fail:fail]) {
        return;
    }
    NSDictionary *message;
    if ([msg isEmpty:@[@"link" ,@"image"] AndNotEmpty:@[@"title"] ]) {
        /// text类型分享
        message= @{
                   @"__class" : @"WBMessageObject",
                   @"text" :msg.title
                   };
    }else if ([msg isEmpty:@[@"link" ] AndNotEmpty:@[@"title",@"image"] ]) {
        /// 图片类型分享
        message=@{
                  @"__class" : @"WBMessageObject",
                  @"imageObject":@{
                          @"imageData":[self dataWithImage:msg.image]
                          },
                  @"text" : msg.title
                  };
        
    } else if ([msg isEmpty:@[] AndNotEmpty:@[@"title",@"link" ,@"image"] ]) {
        /// 链接类型分享
        message=@{
                  @"__class" : @"WBMessageObject",
                  @"mediaObject":@{
                          @"__class" : @"WBWebpageObject",
                          @"description": msg.desc?:msg.title,
                          @"objectID" : @"identifier1",
                          @"thumbnailData":msg.thumbnail ? [self dataWithImage:msg.thumbnail] : [self dataWithImage:msg.image  scale:CGSizeMake(100, 100)],
                          @"title": msg.title,
                          @"webpageUrl":msg.link
                          }
                  
                  };
    }
    NSString *uuid=[[NSUUID UUID] UUIDString];
    NSArray *messageData=@[
                           @{@"transferObject":[NSKeyedArchiver archivedDataWithRootObject:@{
                                                                                             @"__class" :@"WBSendMessageToWeiboRequest",
                                                                                             @"message":message,
                                                                                             @"requestID" :uuid,
                                                                                             }]},
                           @{@"userInfo":[NSKeyedArchiver archivedDataWithRootObject:@{}]},
                           
                           @{@"app":[NSKeyedArchiver archivedDataWithRootObject:@{ @"appKey" : [self keyFor:scheme][@"appKey"],@"bundleID" : [self CFBundleIdentifier]}]}
                           ];
    [UIPasteboard generalPasteboard].items=messageData;
    [self openURL:[NSString stringWithFormat:@"weibosdk://request?id=%@&sdkversion=003013000",uuid]];
}

+ (void)weiboAuth:(NSString*)scope redirectURI:(NSString*)redirectURI success:(authSuccess)success fail:(authFail)fail {
    if (![self beginAuth:scheme Success:success Fail:fail]) {
        return;
    }
    if (![self isWeiboInstalled]) {
        NSString *oauthURL = [NSString stringWithFormat:@"https://open.weibo.cn/oauth2/authorize?client_id=%@&response_type=code&redirect_uri=%@&scope=all", [OpenShare keyFor:@"Weibo"][@"appKey"], [OpenShare keyFor:@"Weibo"][@"redirectURI"]];
        [OpenShare shared].authSuccess = success;
        [OpenShare shared].authFail = fail;
        [[OpenShare shared] addWebViewByURL:[NSURL URLWithString:oauthURL]];
    }

    NSString *uuid=[[NSUUID UUID] UUIDString];
    NSArray *authData=@[
                        @{@"transferObject":[NSKeyedArchiver archivedDataWithRootObject:@{
                                                                                          @"__class" :@"WBAuthorizeRequest",
                                                                                          @"redirectURI":redirectURI,
                                                                                          @"requestID" :uuid,
                                                                                          @"scope": scope?:@"all"
                                                                                          }]},
                        @{@"userInfo":[NSKeyedArchiver archivedDataWithRootObject:@{
                                                                                    @"mykey":@"as you like",
                                                                                    @"SSO_From" : @"SendMessageToWeiboViewController"
                                                                                    }]
                          },

                        @{@"app":[NSKeyedArchiver archivedDataWithRootObject:@{
                                                                               @"appKey" :[self keyFor:scheme][@"appKey"],
                                                                               @"bundleID" : [self CFBundleIdentifier],
                                                                               @"name" :[self CFBundleDisplayName]
                                                                               }]
                          }
                        ];
    [UIPasteboard generalPasteboard].items=authData;
    [self openURL:[NSString stringWithFormat:@"weibosdk://request?id=%@&sdkversion=003013000",uuid]];
}

#pragma mark - 回调
+ (BOOL)Weibo_handleOpenURL {
    NSURL* url = [self returnedURL];
    if ([url.scheme hasPrefix:@"wb"]) {
        NSArray *items=[UIPasteboard generalPasteboard].items;
        NSMutableDictionary *ret=[NSMutableDictionary dictionaryWithCapacity:items.count];
        for (NSDictionary *item in items) {
            for (NSString *k in item) {
                ret[k]=[k isEqualToString:@"transferObject"]?[NSKeyedUnarchiver unarchiveObjectWithData:item[k]]:item[k];
            }
        }
        NSDictionary *transferObject=ret[@"transferObject"];
        if ([transferObject[@"__class"] isEqualToString:@"WBAuthorizeResponse"]) {
            /// auth
            if ([transferObject[@"statusCode"] intValue]==0) {
                if ([self authSuccessCallback]) {
                    [self authSuccessCallback](transferObject);
                }
            }else{
                if ([self authFailCallback]) {
                    NSError *err=[NSError errorWithDomain:@"weibo_auth_response" code:[transferObject[@"statusCode"] intValue] userInfo:transferObject];
                    [self authFailCallback](transferObject,err);
                }
            }
        }else if ([transferObject[@"__class"] isEqualToString:@"WBSendMessageToWeiboResponse"]) {
            /// 分享回调
            if ([transferObject[@"statusCode"] intValue]==0) {
                if ([self shareSuccessCallback]) {
                    [self shareSuccessCallback]([self message]);
                }
            }else{
                if ([self shareFailCallback]) {
                    NSError *err=[NSError errorWithDomain:@"weibo_share_response" code:[transferObject[@"statusCode"] intValue] userInfo:transferObject];
                    [self shareFailCallback]([self message],err);
                }
            }
        }
        return YES;
    } else{
        return NO;
    }
}

@end
