//
//  ANMatchProperty.h
//  ANCore
//
//  Created by andong on 2020/12/25.
//  Copyright © 2020 andong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANMatchProperty : NSObject


/// 运行时匹配属性并赋值
/// @param obj 对该对象进行属性赋值
/// @param params 要赋值的参数
+ (void)matchProperty:(id)obj params:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
