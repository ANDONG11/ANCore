//
//  Macros.h
//  ANCore
//
//  Created by andong on 2021/1/4.
//  Copyright © 2021 ANDONG11. All rights reserved.
//

#ifndef Macros_h
#define Macros_h


#define dSCREEN_WIDTH     ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define dSCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define dSCREEN_SIZE     ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)

/// iPhone X适配
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height             /// 获取状态栏的高度
#define KNavBarHeight 44.0      /// 导航栏的高度
#define KTabBarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height > 20?83:49)  /// 根据状态栏的高度判断tabBar的高度
#define KtopHeitht (KStatusBarHeight + KNavBarHeight)    /// 顶部状态栏加导航栏高度
#define KTabSpace  ([[UIApplication sharedApplication] statusBarFrame].size.height > 20?34:0)       /// 底部距安全区距离

#define kstandardWidth   (IsPortrait ? 375.0 : 812.0)
#define kstandardHeight  (IsPortrait ? 812.0 : 375.0)

#define standardWidth   375.0
#define standardHeight  812.0

/// 当前设备大小
#define iPhoneWidth  [UIScreen mainScreen].bounds.size.width
#define iPhoneHeight [UIScreen mainScreen].bounds.size.height

/// 自适应大小;这里使用的基于iphonex 的参考适配，可以修改为se/5s  {320, 568}/ 6s {375, 667}/ iphonX {375, 812}
#define kWidth(width)                 iPhoneWidth  * width / standardWidth
#define kHeight(height)               iPhoneHeight * height / standardHeight
#define kLevelSpace(space)            iPhoneWidth * space / standardWidth    //水平方向距离间距
#define kVertiSpace(space)            iPhoneHeight * space / standardHeight    //垂直方向距离间距

/// 计算平均
#define dSCREENH_AVERAGE_HEIGHT  [UIScreen mainScreen].bounds.size.height/standardHeight
#define dSCREENH_AVERAGE_WIDTH  [UIScreen mainScreen].bounds.size.width/standardWidth


/// 字体适配
#define SCALE_SIZE(value)        AdaptSize(value)
#define FONTSIZE_LIGHT(value)    [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightLight]
#define FONTSIZE_BLOD(value)     [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightBold]
#define FONTSIZE_REGULAR(value)  [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightRegular]
#define FONTSIZE_MEDIUM(value)   [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightMedium]

#define kScaleFit (BR_IS_IPHONE ? ((iPhoneWidth < iPhoneHeight) ? iPhoneWidth / 375.0f : iPhoneWidth / 812.0f) : 1.1f)


/// 获取系统版本
#define dIOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/// 判断是否为iPhone
#define dIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/// 判断是否为iphoneX
#define dIS_IPHONEX ([UIScreen mainScreen].bounds.size.width >= 375.0f && [UIScreen mainScreen].bounds.size.height >= 812.0f)

/// 判断是否为iPad
#define dIS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


/// 判断 iOS 9 或更高的系统版本
#define dIOS_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))


/// log
#ifdef RELEASE
#define NSLog(format, ...)
#else
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#endif



#ifndef PHSharedInstance
#define PHSharedInstance(block) \
{ \
static dispatch_once_t predicate = 0; \
static id sharedInstance = nil; \
dispatch_once(&predicate, ^{ sharedInstance = block(); }); \
return sharedInstance; \
}
#endif

#define kPHSystemVersion [[[UIDevice currentDevice] systemVersion] doubleValue]


static inline BOOL ph_dictionaryContainsKey(NSDictionary *dict, NSString *key) {
    return [dict isKindOfClass:[NSDictionary class]] && dict.allKeys
    && [dict.allKeys count] > 0 && [dict.allKeys containsObject:key];
}

/**
 *  字体适配
 */
static inline CGFloat AdaptSize(CGFloat fontSize){
   if (iPhoneWidth==375){
        return fontSize;
    } else if (iPhoneWidth == 414){
        return fontSize*1.1;
    } else if (iPhoneWidth < 375) {
        return fontSize*0.9;
    }
    return fontSize*1.2;
}

#endif /* Macros_h */
