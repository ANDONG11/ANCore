//
//  DateFormatterManager.h
//  ANCore
//
//  Created by andong on 2021/1/12.
//  Copyright © 2021 andong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateFormatterManager : NSObject

/**
 将时间戳转化为时间
 
 @param timestamp 时间戳
 @param dateFormatter 时间格式  yyyy-MM-dd hh:mm:ss
 @return 时间
 */
+ (NSString *)timestampSwitchTime:(NSString *)timestamp dateFormatter:(NSString *)dateFormatter;

/**
 将当前日期转化为星期
 
 @param currentStr 当前的日期 yyyy-MM-dd
 @return 星期字符串
 */
+ (NSString*)getWeekDay:(NSString*)currentStr;

/**
 获取当前日期后几天的日期
 
 @param date 天数
 @param dateFormatter 日期的格式
 @return 年月日/ -
 */
+ (NSString *)getTheDateWithAfterDate:(NSInteger)date dateFormatter:(NSString *)dateFormatter;

/// yyyy-MM-dd HH:mm:ss格式时间转换显示格式
/// @param dateString 时间
+ (NSString *)formateDate:(NSString *)dateString;

/// 计算时间戳是否过期
/// @param expireTime 过期时间戳  NO过期
+ (BOOL)getTimeExpire:(NSTimeInterval )expireTime;

@end

NS_ASSUME_NONNULL_END
