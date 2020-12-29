//
//  ANRouterSpec+ANTest.m
//  ANCore_Example
//
//  Created by andong on 2020/12/29.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "ANRouterSpec+ANTest.h"

NSString *const KRequestTestURL  = @"AN://test/" ;

@implementation ANRouterSpec (ANTest)

+ (void)load {
    [ANRouter registerURLPattern:KRequestTestURL toHandler:^(NSDictionary * _Nonnull routerParameters) {
//        NSDictionary *info = routerParameters[ANRouterParameterUserInfo];
        
        NSMutableDictionary *info = [routerParameters[ANRouterParameterUserInfo] mutableCopy];
        [info setObject:routerParameters[ANRouterParameterCompletion] forKey:@"completion"];
        
        UIViewController *vc = [ANViewControllerFactory viewControllerFromHost:@"ANTest" info:info];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[ANRouterSpec topmostViewController] presentViewController:nav animated:YES completion:nil];
    }];

}

+ (UIViewController * __nullable)topmostViewController {
    UIViewController *topViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if (topViewController == nil) {
        return nil;
    }
    
    while (true) {
        if (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)topViewController;
            topViewController = navi.topViewController;
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    
    return topViewController;
}
@end
