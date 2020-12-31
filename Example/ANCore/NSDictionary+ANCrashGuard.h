//
//  NSDictionary+ANCrashGuard.h
//  ANCore_Example
//
//  Created by andong on 2020/12/31.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ANCrashGuard)

/**
 * 支持防护
 * +(instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt  快速创建方式
 * +(instancetype)dictionaryWithObject:(ObjectType)object forKey:(KeyType <NSCopying>)key;
 * -(instancetype)initWithObjects:(const ObjectType _Nonnull [_Nullable])objects forKeys:(const KeyType <NSCopying> _Nonnull [_Nullable])keys count:(NSUInteger)cnt
 */
+ (void)openCrashGuard;

@end

NS_ASSUME_NONNULL_END
