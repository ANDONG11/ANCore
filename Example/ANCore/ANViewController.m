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
#import "ANTestRequest.h"

@interface ANViewController () <ANCrashExceptionDelegate>

@end

@implementation ANViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *array = @[@"路由跳转",@"网络请求",@"分享到QQ好友",@"微博授权"];
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(100, 50*(i+1), 200, 50)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [self.view addSubview:button];
    }
    
    
    /// 崩溃防护
    [ANCrashGuardManager openCrashGuard];
    [ANCrashGuardManager registerCrashHandle:self];
    [ANCrashGuardManager printLog:YES];

    
}

-(void)handleCrashException:(NSString *)exceptionMessage extraInfo:(NSDictionary *)extraInfo {
    
}



- (void)buttonClick:(UIButton *)button {
    switch (button.tag-100) {
        case 0:
        {
            NSString *name = @"name";
            /// 路由
            [ANRouter openURL:KRequestTestURL withUserInfo:@{@"name":name} completion:^(id  _Nonnull result) {
                NSLog(@"%@",result);
            }];
        }
            break;
        case 1:
        {
            ANTestRequest *request = [[ANTestRequest alloc] initWithTest:@"aaa"];
            [request netRequestWithSuccess:^(id  _Nonnull response) {
                
            } error:^{
                
            }  failure:^(NSString * _Nonnull msg) {
                
            }];
        }
            break;
        case 2:
        {
            OSMessage *message = [[OSMessage alloc] init];
        //    message.image =  [self convertViewToImage:self.shareView];
            message.title = @"";
            message.desc  = @"";
        //    message.link = nil;
            
            [OpenShare shareToQQFriends:message success:^(OSMessage * _Nonnull message) {
                
            } fail:^(OSMessage * _Nonnull message, NSError * _Nonnull error) {
                
            }];
        }
            break;
        case 3:
        {
            [OpenShare weiboAuth:@"all" redirectURI:@"http://account.test.ttbye.com/ada/account/auth/weibo/authorize" success:^(NSDictionary * _Nonnull message) {
                
            } fail:^(NSDictionary * _Nonnull message, NSError * _Nonnull error) {
                
            }];
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
