//
//  ProgressHUDManager.h
//  Logistics
//
//  Created by 安东 on 19/12/2019.
//  Copyright © 2019 yiside. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HUDShowStateType) {
    ProgressHUDTypeSuccess = 1,              /// 成功
    ProgressHUDTypeError,                    /// 失败
    ProgressHUDTypeWarning,                  /// 警告
};

@interface ProgressHUDManager : NSObject


/// 显示纯文字并自动消失
/// @param showString 文字
+ (void)showHUDAutoHiddenWithText:(NSString *)showString;

/// 显示纯文字并自动消失(指定view)
/// @param showString 文字
/// @param inView 指定view
+ (void)showHUDAutoHiddenWithText:(NSString *)showString inView:(UIView *)inView;


/// 显示纯文字
/// @param showString 文字
+ (void)showHUDWithText:(NSString *)showString;


/// 显示纯文字(指定view)
/// @param showString 文字
/// @param inView 指定view
+ (void)showHUDWithText:(NSString *)showString inView:(UIView *)inView;


/// 显示成功并自动消失
/// @param showString 文字
+ (void)showHUDAutoHiddenWithSuccess:(NSString *)showString;


/// 显示成功并自动消失(指定view)
/// @param showString 文字
/// @param inView 指定view
+ (void)showHUDAutoHiddenWithSuccess:(NSString *)showString inView:(UIView *)inView;

/// 显示错误并自动消失
/// @param showString 文字
+ (void)showHUDAutoHiddenWithError:(NSString *)showString;


/// 显示警告并自动消失
/// @param showString 文字
+ (void)showHUDAutoHiddenWithWarning:(NSString *)showString;


/// 只显示菊花不显示文字（指定view）
/// @param inView 指定view
+ (void)showHUDLoadingWithView:(UIView *)inView;


/// 只显示菊花不显示文字
+ (void)showHUDLoading;


/// 进度条
/// @param progressValue 进度值
+ (void)uploadProgress:(CGFloat)progressValue;


/// 自定义展示
/// @param block 参数
+ (MBProgressHUD *)showHUDCustom:(void (^)(ProgressHUDManager *make))block;


/// 直接消失
+ (void)dissmissHUDDirect;


/// 直接消失(指定view)
/// @param inView 指定view
+ (void)dissmissHUDDirectInView:(UIView *)inView;





- (ProgressHUDManager *(^)(MBProgressHUDMode))hudMode;

- (ProgressHUDManager *(^)(NSString *))message;

- (ProgressHUDManager *(^)(UIView *))inView;
@end

NS_ASSUME_NONNULL_END
