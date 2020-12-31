//
//  ANViewControllerFactory.m
//  ANCore
//
//  Created by andong on 2020/12/25.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANViewControllerFactory.h"
#import "ANMatchProperty.h"

@implementation ANViewControllerFactory

+ (UIViewController *)viewControllerFromHost:(NSString *)host {
    return [[self class] viewControllerFromHost:host info:nil];
}

+ (UIViewController *)viewControllerFromHost:(NSString *)host info:(NSDictionary *)info {
    if (![host isKindOfClass:[NSString class]] || host.length == 0) {
        return nil;
    }
    /// 首字母大写
    NSString *className = [NSString stringWithFormat:@"%@%@ViewController", [[host substringToIndex:1] uppercaseString], [host substringFromIndex:1]];
    return [[self class] viewControllerFromClassName:className info:info];
}

+ (UIViewController *)viewControllerFromClassName:(NSString *)className info:(NSDictionary *)info {
    if (![className isKindOfClass:[NSString class]] || [className length] == 0) {
        return nil;
    }
    Class vcClass = NSClassFromString(className);
    if (![vcClass isSubclassOfClass:[UIViewController class]]) {
        return nil;
    }
    UIViewController *vc = [vcClass new];
    [[self class] configViper:vc info:info];
    return vc;
}

+ (void)configViper:(UIViewController *)vc info:(NSDictionary *)info {
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
//    BaseViewController *viperVC = (BaseViewController *)vc;
  
    [ANMatchProperty matchProperty:vc params:info];
}

@end
