//
//  ANTextField.m
//  ZBMOM
//
//  Created by dong an on 2021/8/17.
//

#import "ANTextField.h"
#import "ProgressHUDManager.h"

@interface ANTextField () {
    NSString *_regex;
}

@end

@implementation ANTextField

- (instancetype)init {
    self = [super init];
    if (self) {

        self.delegate = self;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.returnKeyType = UIReturnKeyDone;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.type = ANTextFieldDefault;
        /// 初始化最大值为-1  因为int类型不能赋空
        self.maxValue = -1;
    }
    return self;
}

- (void)setType:(ANTextFieldType)type {
    _type = type;
    switch (type) {
        case ANTextFieldDefault:
        case ANTextFieldDefaultNoSpace:
            _regex = nil;
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case ANTextFieldASCII:
            _regex = @"[^a-zA-Z0-9\u4e00-\u9fa5]";
            self.keyboardType = UIKeyboardTypeDefault;
            break;
        case ANTextFieldNumber:
            self.keyboardType = UIKeyboardTypeNumberPad;
            _regex = @"[^0-9]";
            break;
        case ANTextFieldNumberORLetter:
            self.keyboardType = UIKeyboardTypeASCIICapable;
            _regex = @"[^a-zA-Z0-9]";
            break;
        case ANTextFieldDecimal:
            self.keyboardType = UIKeyboardTypeDecimalPad;
            _regex = @"[^0-9.]";
            break;
            
        default:
            break;
    }
}

- (void)setTextLeftSpace:(CGFloat)textLeftSpace {
    _textLeftSpace = textLeftSpace;
    
    UIView *paddingLeftView = [[UIView alloc] init];
    CGRect frame = self.frame;
    frame.size.width = textLeftSpace;
    paddingLeftView.frame = frame;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = paddingLeftView;
}

#pragma mark - textfield delegate
- (void)textFieldDidChange:(UITextField *)textField {
    
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    /// 高亮选择的字 直接return
    if (selectedRange && position) {
        return;
    }

    NSString *text = textField.text;
    /// 如果配置了正则 则按照正则的规则过滤
    if (_regex) {
        textField.text = [self filterCharactor:textField.text withRegex:_regex];
    }
    
    int limitInt = self.limit;
    /// 判断当前如果类型为浮点数 并且输入小数 限制位数不包含小数位
    if (self.type == ANTextFieldDecimal && [textField.text containsString:@"."]) {
        NSRange range = [textField.text rangeOfString:@"."];
        if (range.location == 8) {
            limitInt += 3;
        }
        if (range.location == 7) {
            limitInt += 2;
        }
        if (range.location == 6) {
            limitInt += 1;
        }
    }
    /// 限制输入位数 多余位数直接截取掉 并提示
    if (limitInt && textField.text.length > limitInt) {
        textField.text = [textField.text substringToIndex:limitInt];
        if (!self.promptText) {
            self.promptText = [NSString stringWithFormat:@"最大只能输入%d位",limitInt];
        }
        [ProgressHUDManager showHUDAutoHiddenWithWarning:self.promptText];
        return;
    }
    /// 限制输入最大数量 多余数直接截取掉 并提示
    if (self.maxValue >= 0 && [textField.text integerValue] > self.maxValue) {
        textField.text = [textField.text substringToIndex:(textField.text.length-1)];
        if (!self.promptText) {
            self.promptText = [NSString stringWithFormat:@"最大输入不能超过%ld",(long)self.maxValue];
        }
        [ProgressHUDManager showHUDAutoHiddenWithWarning:self.promptText];
        return;
    }
    /// 如果文本未改变直接返回
    if (![text isEqualToString:textField.text]) {
        return;
    }
    
    /// 文本改变回调
    if (self.changeBlock) {
        self.changeBlock(textField.text);
    }
}

/// 过滤字符串中的非汉字、字母、数字
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    return result;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    /// 默认类型直接返回
    if (self.type == ANTextFieldDefault) {
        return YES;
    }
    
    /// 去除空格类型 默认截取空格并替换
    if (self.type == ANTextFieldDefaultNoSpace) {
        if ([string isEqualToString:@" "]) {
//            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            return NO;
        }
    }
    
    /// 解决当双击切换标点时误删除正常文字 bug
    NSString *punctuateSring = @"，。？！._@/#-";
    if (self.type == ANTextFieldDecimal) {
        punctuateSring = @"，。？！_@/#-";
    }
    
    if (range.length == 0 && string.length == 1 && [punctuateSring containsString:string]) {
        return NO;
    }
    
    /// 输入浮点数类型 默认只能输入一个小数点 并且小数点不能在第一位
    /// 小数点后默认两位小数  
    if (self.type == ANTextFieldDecimal) {
        /// 只允许输入一个小数点
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
            return NO;
        }
        /// 小数点不能为第一位
        if (textField.text.length == 0 && [string isEqualToString:@"."]) {
            return NO;
        }
        /// 限制小数点后只能输两位数字
        NSArray * arrStr = [[textField.text stringByAppendingString:string] componentsSeparatedByString:@"."];
        if (arrStr.count > 1) {
            NSString *str1 = arrStr.lastObject;
            if (str1.length > 2) {
                return NO;
            }
        }
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.endBlock) {
        self.endBlock(textField.text);
    }
}

@end
