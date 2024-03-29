//
//  CycleUtil.h
//  ADCore
//
//  Created by dong an on 2021/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CycleViewBlock)(NSInteger index, CGRect rect);

@interface CycleUtil : NSObject

/// 列数 默认3
@property (nonatomic, assign) NSInteger column;

/// 行间距 默认0
@property (nonatomic, assign) CGFloat lineSpace;

/// 列间距 默认0
@property (nonatomic, assign) CGFloat columnSpace;

/// 距左间距 默认0
@property (nonatomic, assign) CGFloat leftSpace;

/// 距上间距 默认0
@property (nonatomic, assign) CGFloat topSpace;

/// 高度 默认50
@property (nonatomic, assign) CGFloat height;

/// 是否是正方形  如果为正方形 宽度等于高度 行间距和列间距设置改为自动计算
@property (nonatomic, assign) BOOL isSquare;

@property (nonatomic, assign) CGFloat backSpace;

/// 循环创建
/// @param count 创建数量
/// @param block 回调
- (void)cycleWithCount:(NSInteger)count cycleViewBlock:(CycleViewBlock)block;

@end

NS_ASSUME_NONNULL_END
