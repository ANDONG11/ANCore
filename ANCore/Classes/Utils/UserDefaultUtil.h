//
//  UserDefaultUtil.h
//  ANCore
//
//  Created by andong on 2021/1/20.
//  Copyright © 2021 andong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultUtil : NSObject

+ (void)setUserDefaults:(NSDictionary *)dic;

+ (void)setUserDefaultsObject:(id)obj forKey:(NSString *)key;

+ (id)userDefaultsObject:(NSString *)key;

+ (void)removeUserDefaults:(NSString *)key;

+ (void)removeUserDefaultsKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END
