//
//  NSObject+CurrentController.m
//  ANCore
//
//  Created by andong on 2021/1/4.
//  Copyright © 2021 andong. All rights reserved.
//

#import "NSObject+CurrentController.h"

@implementation NSObject (CurrentController)

+ (UIViewController *)currentActiveController {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activeVC = nil;
        
    while (true) {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            activeVC = [(UINavigationController *)rootVC visibleViewController];
        } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
            activeVC = [(UITabBarController *)rootVC selectedViewController];
        } else if (rootVC.presentedViewController) {
            activeVC = rootVC.presentedViewController;
        } else if (rootVC.childViewControllers.count > 0) {
            activeVC = [rootVC.childViewControllers lastObject];
        } else {
            break;
        }
        rootVC = activeVC;
    }
    
    return activeVC;
}

@end
