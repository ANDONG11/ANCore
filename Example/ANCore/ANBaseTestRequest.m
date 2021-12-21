//
//  ANBaseTestRequest.m
//  ANCore_Example
//
//  Created by andong on 2021/1/11.
//  Copyright © 2021 ANDONG11. All rights reserved.
//

#import "ANBaseTestRequest.h"

@implementation ANBaseTestRequest

-(NSString *)baseUrl {
    return @"http://baseurl";
}
/// 设置基本参数
-(id)requestArgument {
    NSMutableDictionary *params = [[super requestArgument] mutableCopy];
    return params;
}

- (void)successWithResponse:(id)response success:(void (^)(id _Nonnull))success error:(nonnull void (^)(void))error {
    /// 数据输出日志
#ifdef DEBUG
    NSLog(@"\nurl:%@%@\nparams:%@\nheaders:%@\nbody:%@",[self baseUrl],[self requestUrl],[self requestArgument],[self requestHeaderFieldValueDictionary],response);
#else
#endif
    int code = [response[@"code"] intValue];
    if (code == 200) {
        /// 请求成功
        success(response);
    } else {
        /// 服务器请求失败
        error();
        [self showMsgWithCode:code msg:response[@"msg"]];
    }
}


-(void)errorWithResponse:(NSError *)error failure:(void (^)(NSString * _Nonnull))failure {
//    NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//    NSString * text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    /// 数据输出日志
#ifdef DEBUG
    
    NSLog(@"\nurl:%@%@\nparams:%@\nbody:%@",[self baseUrl],[self requestUrl],[self requestArgument],error);
#else
#endif
//    if ([NSString checkStringIsValided:text]) {
//      NSDictionary *dic = [ZBBaseRequest dictionaryWithJsonString:text];
//      text = [NSString stringWithFormat:@"远程服务器连接失败，错误码%@",dic[@"status"]];
//    } else {
//      text = error.localizedDescription;
//    }
//    [ProgressHUDManager showHUDAutoHiddenWithError:text];
    failure(@"请求失败");
}

- (void)showMsgWithCode:(int)code msg:(NSString *)msg {
    if (code == 399) {
        /// 登录失效状态
        [ANAlert alertShowWithParams:^(ANAlert * _Nonnull alert) {
            alert.title(@"登录失效").actionTitles(@[@"重新登录"]);
        } handler:^(int index) {
            /// 退出登录
//            [ZBUserManager clear];
            Class class = NSClassFromString(@"ZBLoginViewController");
            if (class) {
              UIViewController *ctrl = class.new;
              UIApplication.sharedApplication.delegate.window.rootViewController = ctrl;
            }
        }];
        return;
    }
    if (msg) {
        /// 服务器正常返回错误显示
 
    } else {
        /// 服务器异常报错显示
      
    }
}

/**
 json字符串转字典

 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
  if (jsonString == nil) {
    return nil;
  }
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  if(err) {
    NSLog(@"json解析失败：%@",err);
    return nil;
  }
  return dic;
}

@end
