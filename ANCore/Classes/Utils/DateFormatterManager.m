//
//  DateFormatterManager.m
//  ANCore
//
//  Created by andong on 2021/1/12.
//  Copyright © 2021 andong. All rights reserved.
//

#import "DateFormatterManager.h"

#define D_MINUTE  60
#define D_HOUR    3600
#define D_DAY     86400
#define D_WEEK    604800
#define D_YEAR    31556926

static NSDateFormatter *dateFormatter = nil;

@implementation DateFormatterManager

/**
 缓存dateFormatter对象

 @return dateFormatter对象
 */
+ (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    }
    return dateFormatter;
}

/**
 将时间戳转化为时间
 
 @param timestamp 时间戳
 @param dateFormatter 时间格式  yyyy-MM-dd hh:mm:ss
 @return 时间
 */
+ (NSString *)timestampSwitchTime:(NSString *)timestamp dateFormatter:(NSString *)dateFormatter {
    
    if (!timestamp || [timestamp isEqualToString:@""]) {
        return @"";
    }
    NSDateFormatter *formatter = [DateFormatterManager dateFormatter];
    [formatter setDateFormat:dateFormatter];
    NSDate *confromTimesp;
    if (timestamp.length == 10) {
        /// 10位时间戳 精确到秒级
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    } else {
        /// 13位时间戳 需除以1000  精确到毫秒级
        confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000.0];
    }
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

/// 将时间转为时间戳
/// @param time 时间
+ (NSString *)timeSwitchTimestamp:(NSString *)time  {
    
    NSDateFormatter *formatter = [DateFormatterManager dateFormatter];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:time];
    NSTimeInterval timeInterval = [date timeIntervalSince1970]*1000;//NSTimeInterval本身是个秒级别的double类型数值，小数点后面即毫秒数,*1000.0f即可得到毫秒级别的时间差
    long long dTime = [[NSNumber numberWithDouble:timeInterval] longLongValue]; // 将double转为long long型
    NSString *timeSp = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    return timeSp;
}

/**
 将当前日期转化为星期

 @param currentStr 当前的日期 yyyy-MM-dd
 @return 星期字符串
 */
+ (NSString*)getWeekDay:(NSString*)currentStr {
    
    NSDateFormatter *formatter = [DateFormatterManager dateFormatter];
    [formatter setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *date =[formatter dateFromString:currentStr];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


/**
 获取当前日期后几天的日期
 
 @param date 天数
 @param dateFormatter 日期的格式
 @return 年月日/ -
 */
+ (NSString *)getTheDateWithAfterDate:(NSInteger)date dateFormatter:(NSString *)dateFormatter {
    
    NSInteger dis = date; // 前后的天数
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    // 之后的天数
    theDate = [nowDate initWithTimeIntervalSinceNow: + D_DAY*dis];
    
    NSDateFormatter *formatter = [DateFormatterManager dateFormatter];
    // 设定时间格式,这里可以设置成自己需要的格式
    [formatter setDateFormat:dateFormatter];
    // 用[NSDate date]可以获取系统当前时间
    NSString * currentDateStr = [formatter stringFromDate:theDate];
    return currentDateStr;
}


/// yyyy-MM-dd HH:mm:ss格式时间转换显示格式
/// @param dateString 时间
+ (NSString *)formateDate:(NSString *)dateString {
    
    @try {
        /// 实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [DateFormatterManager dateFormatter];
        /// 这里的格式必须和DateString格式一致
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate * nowDate = [NSDate date];
        
        /// 将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        
        /// 取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        /// 1分钟以内的
        if (time <= D_MINUTE) {
            return @"刚刚";
        }
        
        /// 一个小时以内的
        if(time <= D_HOUR) {
            int mins = time/60;
            return [NSString stringWithFormat:@"%d分钟前",mins];
        }
        
        /// 在24小时以内的
        if (time <= D_DAY) {
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd  = [dateFormatter stringFromDate:nowDate];
            [dateFormatter setDateFormat:@"HH:mm"];
            
            /// 在同一天
            if ([need_yMd isEqualToString:now_yMd]) {
                return [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
            /// 昨天
            return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        /// 在同一年
        if ([yearStr isEqualToString:nowYear]) {
            [dateFormatter setDateFormat:@"MM-dd"];
            return  [dateFormatter stringFromDate:needFormatDate];
        }
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:needFormatDate];
    }
    
    @catch (NSException *exception) {
        return @"";
    }
}

#pragma mark - 计算时间戳是否过期
+ (BOOL)getTimeExpire:(NSTimeInterval )expireTime {
    
    NSDate *nowDate = [NSDate date];//获取当前的时间
    
    NSDate *expireDate = [NSDate dateWithTimeIntervalSince1970:expireTime];
    //对比得到差值
    NSTimeInterval timeInterval = [expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    //以下按自己需要使用
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    dayStr = [NSString stringWithFormat:@"%d",days];
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        
        return NO;
    }
    return YES;
}

@end
