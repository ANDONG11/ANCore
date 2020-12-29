//
//  ANViewController.m
//  ANCore
//
//  Created by ANDONG11 on 12/24/2020.
//  Copyright (c) 2020 ANDONG11. All rights reserved.
//

#import "ANViewController.h"

#import "ANRouterSpec+ANTest.h"

@interface ANViewController ()

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

    
}

- (void)buttonClick {
    /// 路由
    [ANRouter openURL:KRequestTestURL withUserInfo:@{@"name":@"anan"} completion:^(id  _Nonnull result) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
