//
//  ANAlert.h
//  Practice
//
//  Created by andong on 2020/12/24.
//  Copyright © 2020 andong. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^ANAlertHandler)(int index);

@interface ANAlert : NSObject

typedef ANAlert*__nullable(^ANAlertStyle)(UIAlertControllerStyle style);
typedef ANAlert*__nullable(^ANAlertString)(NSString *string);
typedef ANAlert*__nullable(^ANAlertActTitles)(NSArray *actTitles);

/// alert类型
@property (nonatomic, copy, readonly) ANAlertStyle alertStyle;

/// 标题
@property (nonatomic, copy, readonly) ANAlertString title;

/// 描述信息
@property (nonatomic, copy, readonly) ANAlertString message;

/// 点击按钮标题数组 @[@“确定”,@"取消"];
@property (nonatomic, copy, readonly) ANAlertActTitles actionTitles;


/// 弹出
/// @param params 配置参数  使用时在block中调用（alert.title(@"测试")）
/// @param handler 点击返回
+ (void)alertShowWithParams:(void(^)(ANAlert *alert))params handler:(ANAlertHandler)handler;

@end

NS_ASSUME_NONNULL_END
