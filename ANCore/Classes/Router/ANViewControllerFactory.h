//
//  ANViewControllerFactory.h
//  Practice
//
//  Created by andong on 2020/12/25.
//  Copyright © 2020 andong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANViewControllerFactory : NSObject

+ (UIViewController *)viewControllerFromHost:(NSString *)host;
+ (UIViewController *)viewControllerFromHost:(NSString *)host info:(NSDictionary *__nullable)info;

@end

NS_ASSUME_NONNULL_END
