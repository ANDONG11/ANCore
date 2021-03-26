//
//  OpenShare+Weixin.h
//  ANCore
//
//  Created by dong an on 2021/3/25.
//  Copyright © 2021 andong. All rights reserved.
//

#import "OpenShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenShare (Weixin)

/**
 *  https://open.weixin.qq.com 在这里申请
 *
 *  @param appId AppID
 */
+(void)connectWeixinWithAppId:(NSString *)appId wxminiAppId:(NSString *)wxminiAppId;
+(BOOL)isWeixinInstalled;

+(void)shareToWeixinSession:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;
+(void)shareToWeixinTimeline:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;
+(void)shareToWeixinFavorite:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;
+(void)WeixinAuth:(NSString*)scope success:(authSuccess)success fail:(authFail)fail;
+(void)WeixinPay:(NSString*)link success:(paySuccess)success fail:(payFail)fail;

@end

NS_ASSUME_NONNULL_END
