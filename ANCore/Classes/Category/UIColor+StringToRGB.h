//
//  UIColor+StringToRGB.h
//  ANCore
//
//  Created by andong on 2021/1/4.
//  Copyright © 2021 andong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (StringToRGB)

#pragma 颜色转换成RGB
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

@end

NS_ASSUME_NONNULL_END
