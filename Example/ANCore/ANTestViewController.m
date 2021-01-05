//
//  ANTestViewController.m
//  ANCore_Example
//
//  Created by andong on 2020/12/29.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "ANTestViewController.h"
#import "ANTestRequest.h"

typedef void(^Completion)(NSString *first);
@interface ANTestViewController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) Completion completion;

@end

@implementation ANTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"name:%@",self.name);
    
//    ANTestRequest *request = [[ANTestRequest alloc] initWithTest:@"aaa"];
//    [request netRequestWithSuccess:^(id  _Nonnull response) {
//        
//    } failure:^(NSString * _Nonnull msg) {
//        
//    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.completion(@"111");
    /// 测试弹窗
    [ANAlert alertShowWithParams:^(ANAlert * _Nonnull alert) {
        alert.title(@"关闭页面").actionTitles(@[@"确定"]);
    } handler:^(int index) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
