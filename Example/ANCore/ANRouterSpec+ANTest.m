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
        [[NSObject currentActiveController] presentViewController:nav animated:YES completion:nil];
    }];
    
}

@end
