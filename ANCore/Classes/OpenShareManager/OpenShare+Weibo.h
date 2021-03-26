//
//  OpenShare+Weibo.h
//  ANCore
//
//  Created by dong an on 2021/3/25.
//  Copyright © 2021 andong. All rights reserved.
//

#import "OpenShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenShare (Weibo)

/**
*  可以点击「编辑」修改Bundle ID，要和这里的一致，否则auth的时候会返回error_code=21338
*
*  @param appKey 申请到的appKey
*/
+ (void)connectWeiboWithAppKey:(NSString *)appKey;
+ (void)connectWeiboWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURI:(NSString *)redirectURI;

/// 是否安装微博
+ (BOOL)isWeiboInstalled;

/**
 *  分享到微博，微博只支持三种类型：文本／图片／链接。根据OSMessage自动判定想分享的类型。
 *
 *  @param msg     要分享的msg
 *  @param success 分享成功回调
 *  @param fail    分享失败回调
 */
+ (void)shareToWeibo:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;

/**
 *  微博登录OAuth
 *
 *  @param scope       scope，如果不填写，默认是all
 *  @param redirectURI 必须填写，可以通过http://open.weibo.com/apps/402180334/info/advanced编辑(后台不验证，但是必须填写一致)
 *  @param success     登录成功回调
 *  @param fail        登录失败回调
 */
+ (void)weiboAuth:(NSString*)scope redirectURI:(NSString*)redirectURI success:(authSuccess)success fail:(authFail)fail;

@end

NS_ASSUME_NONNULL_END
