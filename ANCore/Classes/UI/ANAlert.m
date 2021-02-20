//
//  ANAlert.m
//  ANCore
//
//  Created by andong on 2020/12/24.
//  Copyright © 2020 andong. All rights reserved.
//

#import "ANAlert.h"
#import "NSObject+CurrentController.h"

@interface ANAlert () {
    UIAlertControllerStyle _privateStyle;
    NSString  *_privateTitle;
    NSString  *_privateMessage;
    NSArray   *_privateActionTitles;
}

@end

@implementation ANAlert

-(instancetype)init {
    if (self = [super init]) {
        self->_privateStyle = UIAlertControllerStyleAlert;
    }
    return self;
}

+ (void)alertShowWithParams:(void(^)(ANAlert *alert))params handler:(ANAlertHandler)handler {
    ANAlert *alert = [[ANAlert alloc] init];
    params(alert);
    [alert privateShowWithHandler:handler];
}


-(ANAlertStyle)alertStyle {

    return ^ANAlert *(UIAlertControllerStyle style) {
        self->_privateStyle = style;
        return self;
    };
}

-(ANAlertString)title {
    return  ^ANAlert *(NSString * _Nonnull string) {
        self->_privateTitle = string;
        return self;
    };
}

-(ANAlertString)message {
    return  ^ANAlert *(NSString * _Nonnull string) {
        self->_privateMessage = string;
        return self;
    };
}

-(ANAlertActTitles)actionTitles {
    return  ^ANAlert *(NSArray * _Nonnull actTitles) {
        self->_privateActionTitles = actTitles;
        return self;
    };
}

#pragma mark - private
- (void)privateShowWithHandler:(ANAlertHandler)handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self->_privateTitle
                                                                   message:self->_privateMessage
                                                            preferredStyle:self->_privateStyle];
    
    for (int i = 0; i < self->_privateActionTitles.count; i ++) {
        
        @autoreleasepool {
            UIAlertActionStyle style = UIAlertActionStyleDefault;
            if ([self->_privateActionTitles[i] isEqualToString:@"取消"]) {
                style = UIAlertActionStyleCancel;
            }
            
            UIAlertAction *confimAction = [UIAlertAction actionWithTitle:self->_privateActionTitles[i] style:style handler:^(UIAlertAction * _Nonnull action) {
                handler(i);
            }];
            [alert addAction:confimAction];
        }
    }
    [[NSObject currentActiveController] presentViewController:alert animated:YES completion:nil];
}



@end
