//
//  NSObject+CurrentController.h
//  ANCore
//
//  Created by andong on 2021/1/4.
//  Copyright © 2021 andong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CurrentController)

+ (UIViewController *)currentActiveController;

@end

NS_ASSUME_NONNULL_END
