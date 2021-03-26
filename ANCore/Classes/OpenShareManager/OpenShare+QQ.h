//
//  OpenShare+QQ.h
//  ANCore
//
//  Created by dong an on 2021/3/25.
//  Copyright © 2021 andong. All rights reserved.
//

#import "OpenShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface OpenShare (QQ)

/**
 *  连接QQ平台。可以分享到：qq好友／qq空间。只需要appId：http://op.open.qq.com/index.php?mod=appinfo&act=main&appid=1103194207#mobile|center
 *  需要添加CFBundleURLSchemes：
 *  <array>
 *  <string>tencent1103194207</string>
 *  <string>tencent1103194207.content</string>
 *  <string>QQ41C1685F</string> 16进制表示的appid，可以通过new Number(1103194207).toString(16).toUpperCase()获取。
 *  @param appId 所申请的应用的APP ID
 */
+(void)connectQQWithAppId:(NSString *)appId;
+(BOOL)isQQInstalled;

+(void)shareToQQFriends:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;
+(void)shareToQQZone:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;
+(void)shareToQQFavorites:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;
+(void)shareToQQDataline:(OSMessage*)msg success:(shareSuccess)success fail:(shareFail)fail;
+(void)QQAuth:(NSString*)scope success:(authSuccess)success fail:(authFail)fail;
/**
 *  打开WPA临时会话
 *
 *  @param qqNumber 要聊天的QQ号
 */
+(void)chatWithQQNumber:(NSString*)qqNumber;
/**
 *  打开某个群聊天。QQ客户端登录的QQ号，必须是groupNumber的成员才能聊天。
 *
 *  @param groupNumber 群号码
 */
+(void)chatInQQGroup:(NSString*)groupNumber;

/**
 *  是否能处理这个openUrl，如果能就返回YES，并且按照callback处理，否则返回NO，交给下一个处理。
 *  @return 是否能处理给定的url
 */
+(BOOL)QQ_handleOpenURL;

@end

NS_ASSUME_NONNULL_END
