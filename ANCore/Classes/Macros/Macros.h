//
//  Macros.h
//  ANCore
//
//  Created by andong on 2021/1/4.
//  Copyright © 2021 ANDONG11. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/// 获取app的info.plist详细信息
#define dVersion       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]  /// build 版本号
#define dShortVersion  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] /// version 版本号
#define dPackage       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] /// 包名
#define dDisplayName   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] /// 应用显示的名称
#define dBundleName    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] /// 工程名


/// iPhone X适配
#define KStatusBarHeight [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height             /// 获取状态栏的高度
#define KNavBarHeight 44.0      /// 导航栏的高度
#define KTabBarHeight  (KStatusBarHeight > 20?83:49)  /// 根据状态栏的高度判断tabBar的高度
#define KtopHeitht (KStatusBarHeight + KNavBarHeight)    /// 顶部状态栏加导航栏高度
#define KTabSpace  (KStatusBarHeight > 20?34:0)       /// 底部距安全区距离

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


#define SCALE_SIZE(value)        AdaptSize(value)

/// 字体
#define FONTSIZE_LIGHT(value)    [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightLight]
#define FONTSIZE_BLOD(value)     [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightBold]
#define FONTSIZE_REGULAR(value)  [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightRegular]
#define FONTSIZE_MEDIUM(value)   [UIFont systemFontOfSize:AdaptSize(value) weight:UIFontWeightMedium]

#define dScaleFit (BR_IS_IPHONE ? ((iPhoneWidth < iPhoneHeight) ? iPhoneWidth / 375.0f : iPhoneWidth / 812.0f) : 1.1f)

/// 线的高度
#define dSINGLE_LINE_WIDTH          (1 / [UIScreen mainScreen].scale)

/// 获取系统版本
#define dIOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/// 判断是否为iPhone
#define dIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/// 判断是否为iphoneX
#define dIS_IPHONEX ([UIScreen mainScreen].bounds.size.width >= 375.0f && [UIScreen mainScreen].bounds.size.height >= 812.0f)

/// 判断是否为iPad
#define dIS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


/// 判断 iOS 9 或更高的系统版本
#define dIOS_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))


/// log
#ifdef RELEASE
#define NSLog(format, ...)
#else
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#endif



#define dSINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)sharedInstance;

#define dSINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
static dispatch_once_t pred; \
dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
return shared##classname; \
}


static inline BOOL ph_dictionaryContainsKey(NSDictionary *dict, NSString *key) {
    return [dict isKindOfClass:[NSDictionary class]] && dict.allKeys
    && [dict.allKeys count] > 0 && [dict.allKeys containsObject:key];
}

/**
 *  字体适配
 */
static inline CGFloat AdaptSize(CGFloat fontSize){
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return fontSize*1.3;
    }
    if (iPhoneWidth < 414) {
        return fontSize;
    }
    return fontSize*1.1;
}

#endif /* Macros_h */
