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
        
    }
    return self;
}

- (void)setType:(ANTextFieldType)type {
    _type = type;
    switch (type) {
        case ANTextFieldDefault:
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
    
    /// 限制输入位数 多余位数直接截取掉 并提示
    if (self.limit && textField.text.length > self.limit) {
        textField.text = [textField.text substringToIndex:self.limit];
        if (!self.promptText) {
            self.promptText = [NSString stringWithFormat:@"最大只能输入%d位",self.limit];
        }
        [ProgressHUDManager showHUDAutoHiddenWithWarning:self.promptText];
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

    if (self.type == ANTextFieldDefault) {
        return YES;
    }
    /// 解决当双击切换标点时误删除正常文字 bug
    NSString *punctuateSring = @"，。？！._@/#-";
    if (range.length == 0 && string.length == 1 && [punctuateSring containsString:string]) {
        return NO;
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
