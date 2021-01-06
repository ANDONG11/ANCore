//
//  ANViewController.m
//  ANCore
//
//  Created by ANDONG11 on 12/24/2020.
//  Copyright (c) 2020 ANDONG11. All rights reserved.
//

#import "ANViewController.h"
#import "ANRouterSpec+ANTest.h"
#import "ANCrashGuardManager.h"

@interface ANViewController () <ANCrashExceptionDelegate>

@end

@implementation ANViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"路由跳转" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(100, 100, 100, 100)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    
    [ANCrashGuardManager openCrashGuard];
    [ANCrashGuardManager registerCrashHandle:self];
    [ANCrashGuardManager printLog:YES];

//    NSArray *arr = @[@"1",@"2"];
//    NSLog(@"arr:%@",arr[3]);
    
}

-(void)handleCrashException:(NSString *)exceptionMessage extraInfo:(NSDictionary *)extraInfo {
    
}



- (void)buttonClick {
    NSString *name = @"name";
    /// 路由
    [ANRouter openURL:KRequestTestURL withUserInfo:@{@"name":name} completion:^(id  _Nonnull result) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
