//
//  ProgressHUDManager.m
//  Logistics
//
//  Created by 安东 on 19/12/2019.
//  Copyright © 2019 yiside. All rights reserved.
//

#import "ProgressHUDManager.h"
#import "UIColor+StringToRGB.h"
#import "WeakStrongMacro.h"

@interface ProgressHUDManager ()

@property (nonatomic, copy)   NSString          *ad_message;   /// hud上文字
@property (nonatomic, strong) UIView            *ad_inView;    /// hud显示的view
@property (nonatomic, assign) BOOL              ad_animated;   /// 是否动画显示
@property (nonatomic, assign) MBProgressHUDMode ad_hudMode;    /// 弹窗模式
@property (nonatomic, assign) BOOL              ad_autoHidden; /// 自动隐藏
@property (nonatomic, assign) HUDShowStateType  ad_hudState;   /// 全局hud
@property (nonatomic, assign) CGFloat           ad_progressValue;/// 进度
@property (nonatomic, assign) BOOL              ad_userInteractionEnabled; /// 是否可交互 默认为NO

@end

@implementation ProgressHUDManager

#pragma mark - 显示纯文字并自动消失
+ (void)showHUDAutoHiddenWithText:(NSString *)showString {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeText).message(showString).autoHidden(YES);
    }];
}

#pragma mark - 显示纯文字并自动消失(指定view上)
+ (void)showHUDAutoHiddenWithText:(NSString *)showString inView:(UIView *)inView {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeText).inView(inView).message(showString).autoHidden(YES);
    }];
}

#pragma mark - 显示纯文字
+ (void)showHUDWithText:(NSString *)showString {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeText).message(showString).userInteractionEnabled(YES);
    }];
}

#pragma mark - 显示纯文字(指定view)
+ (void)showHUDWithText:(NSString *)showString inView:(UIView *)inView {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeText).message(showString).inView(inView).userInteractionEnabled(YES);
    }];
}

#pragma mark - 显示成功并自动消失
+ (void)showHUDAutoHiddenWithSuccess:(NSString *)showString {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeCustomView).hudState(ProgressHUDTypeSuccess).message(showString).autoHidden(YES);
    }];
}

#pragma mark - 显示成功并自动消失(指定view)
+ (void)showHUDAutoHiddenWithSuccess:(NSString *)showString inView:(UIView *)inView {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeCustomView).hudState(ProgressHUDTypeSuccess).message(showString).autoHidden(YES).inView(inView);
    }];
}

#pragma mark - 显示错误并自动消失
+ (void)showHUDAutoHiddenWithError:(NSString *)showString {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeCustomView).hudState(ProgressHUDTypeError).message(showString).autoHidden(YES);
    }];
}

#pragma mark - 显示警告并自动消失
+ (void)showHUDAutoHiddenWithWarning:(NSString *)showString {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeCustomView).hudState(ProgressHUDTypeWarning).message(showString).autoHidden(YES);
    }];
}

#pragma mark - 只显示菊花不显示文字（指定view）
+ (void)showHUDLoadingWithView:(UIView *)inView {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeIndeterminate).inView(inView).userInteractionEnabled(YES);
    }];
}

#pragma mark - 只显示菊花不显示文字
+ (void)showHUDLoading {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeIndeterminate).autoHidden(NO).userInteractionEnabled(YES);
    }];
}

#pragma mark - 进度条
+ (void)showHUDUploadProgress:(CGFloat)progressValue {
    [ProgressHUDManager showHUDCustom:^(ProgressHUDManager *make) {
        make.hudMode(MBProgressHUDModeDeterminateHorizontalBar).progressValue(progressValue).userInteractionEnabled(YES).message(@"上传中");
    }];
}

+ (MBProgressHUD *)showHUDCustom:(void (^)(ProgressHUDManager *make))block {
    
    ProgressHUDManager *makeObj = [[ProgressHUDManager alloc] init];
    if (makeObj) {
        block(makeObj);
    }
    
    __block MBProgressHUD *hud = [MBProgressHUD HUDForView:makeObj.ad_inView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!hud) {
            hud = [ProgressHUDManager configHUDWithMakeObj:makeObj];
        }
        hud.mode                   = makeObj.ad_hudMode;
        hud.detailsLabel.text      = makeObj.ad_message;
        hud.userInteractionEnabled = makeObj.ad_userInteractionEnabled;
        hud.bezelView.style        = MBProgressHUDBackgroundStyleBlur;
        
        switch (makeObj.ad_hudMode) {
            case MBProgressHUDModeIndeterminate:
                /// 菊花样式
                hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                break;
            case MBProgressHUDModeDeterminate:
                /// 圆形指示器
                break;
            case MBProgressHUDModeDeterminateHorizontalBar:
                /// 水平进度条
                hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
                hud.progress = makeObj.ad_progressValue;
                break;
            case MBProgressHUDModeAnnularDeterminate:
                /// 圆形指示器
                break;
            case MBProgressHUDModeCustomView:
            {
                /// 自定义视图
                NSString *imageStr = @"";
                if (makeObj.ad_hudState == ProgressHUDTypeSuccess) {
                    imageStr = @"ZBCore.bundle/hudSuccess@3x.png";
                } else if (makeObj.ad_hudState == ProgressHUDTypeError) {
                    imageStr = @"ZBCore.bundle/hudError@3x.png";
                } else {
                    imageStr = @"ZBCore.bundle/hudInfo@3x.png";
                }
                if (![imageStr isEqualToString:@""]) {
                    hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                }
            }
                break;
            case MBProgressHUDModeText:
                /// 文本
                break;
            default:
                break;
                
        }
        if (makeObj.ad_autoHidden) {
            [hud hideAnimated:makeObj.ad_animated afterDelay:2];
        }
    });
    return hud;
}

#pragma mark - 直接消失
+ (void)dissmissHUDDirect {
    [ProgressHUDManager dissmissHUD:nil];
}

#pragma mark - 直接消失（指定view）
+ (void)dissmissHUDDirectInView:(UIView *)inView {
    [ProgressHUDManager dissmissHUD:^(ProgressHUDManager *make) {
        make.inView(inView);
    }];
}

+ (void)dissmissHUD:(void (^)(ProgressHUDManager *make))block {
    ProgressHUDManager *makeObj = [[ProgressHUDManager alloc] init];
    if (block) {
        block(makeObj);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block MBProgressHUD *hud = [MBProgressHUD HUDForView:makeObj.ad_inView];
        [hud hideAnimated:makeObj.ad_animated];
    });
}

+ (MBProgressHUD *)configHUDWithMakeObj:(ProgressHUDManager *)makeObj {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:makeObj.ad_inView animated:makeObj.ad_animated];
    hud.detailsLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightLight];
    hud.contentColor = [UIColor hexStringToColor:@"#333333"];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.offset = CGPointMake(0, -[[UIApplication sharedApplication] statusBarFrame].size.height-35);
    hud.margin = 16;
    hud.bezelView.layer.cornerRadius = 5;
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleLight;
    return hud;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {//这里可以设置一些默认的属性
        _ad_inView   = [UIApplication sharedApplication].keyWindow;
        _ad_animated = YES;
        _ad_hudMode  = MBProgressHUDModeIndeterminate;
        _ad_userInteractionEnabled = NO;
    }
    return self;
}


- (ProgressHUDManager *(^)(NSString *))message {
    @weakify(self);
    return ^ProgressHUDManager *(NSString *message) {
        @strongify(self);
        self.ad_message = message;
        return self;
    };
}

- (ProgressHUDManager *(^)(UIView *))inView {
    @weakify(self);
    return ^ProgressHUDManager *(id obj) {
        @strongify(self);
        self.ad_inView = obj;
        return self;
    };
}

- (ProgressHUDManager *(^)(BOOL))animated {
    @weakify(self);
    return ^ProgressHUDManager *(BOOL animated) {
        @strongify(self);
        self.ad_animated = animated;
        return self;
    };
}

- (ProgressHUDManager *(^)(MBProgressHUDMode))hudMode {
    @weakify(self);
    return ^ProgressHUDManager *(MBProgressHUDMode hudMode) {
        @strongify(self);
        self.ad_hudMode = hudMode;
        return self;
    };
}

- (ProgressHUDManager *(^)(BOOL))autoHidden {
    @weakify(self);
    return ^ProgressHUDManager *(BOOL autoHidden) {
        @strongify(self);
        self.ad_autoHidden = autoHidden;
        return self;
    };
}

- (ProgressHUDManager *(^)(HUDShowStateType))hudState {
    @weakify(self);
    return ^ProgressHUDManager *(HUDShowStateType hudState) {
        @strongify(self);
        self.ad_hudState = hudState;
        return self;
    };
}

- (ProgressHUDManager *(^)(CGFloat))progressValue {
    @weakify(self);
    return ^ProgressHUDManager *(CGFloat progressValue) {
        @strongify(self);
        self.ad_progressValue = progressValue;
        return self;
    };
}

- (ProgressHUDManager *(^)(BOOL))userInteractionEnabled {
    @weakify(self);
    return ^ProgressHUDManager *(BOOL userInteractionEnabled) {
        @strongify(self);
        self.ad_userInteractionEnabled = userInteractionEnabled;
        return self;
    };
}

@end
