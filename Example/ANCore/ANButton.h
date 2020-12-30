//
//  ANButton.h
//  ANCore_Example
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    /// 图片在上，文字在下
    ANImagePositionUp = 1,
    
    /// 图片在下, 文字在上
    ANImagePositionDown,
    
    /// 图片在左, 文字在右
    ANImagePositionLeft,
    
    /// 图片在右, 文字在左
    ANImagePositionRight
    
} ANImagePosition;

@interface ANButton : UIButton

/** 图片文字排列样式 */
@property (nonatomic, assign) ANImagePosition style;

/** 文字和图片之间间隔(default 0.0) */
@property (nonatomic, assign) CGFloat margin;

@end

NS_ASSUME_NONNULL_END
