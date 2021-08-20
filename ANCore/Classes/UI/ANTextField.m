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
        self.keyboardType = UIKeyboardTypeDefault;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.type = ANTextFieldASCII;
        
    }
    return self;
}

- (void)setType:(ANTextFieldType)type {
    _type = type;
    switch (type) {
        case ANTextFieldDefault:
            _regex = nil;
            break;
        case ANTextFieldASCII:
            _regex = @"[^a-zA-Z0-9\u4e00-\u9fa5]";
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

#pragma mark - textfield delegate
- (void)textFieldDidChange:(UITextField *)textField {
    
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position && _regex) {
        NSString *text = textField.text;
        /// 没有高亮选择的字
        /// 过滤非汉字、字母、数字字符
        textField.text = [self filterCharactor:textField.text withRegex:_regex];
        /// 限制输入位数
        if (self.limit && textField.text.length > self.limit) {
            textField.text = [textField.text substringToIndex:self.limit];
            [ProgressHUDManager showHUDAutoHiddenWithWarning:[NSString stringWithFormat:@"最大只能输入%d位",self.limit]];
        }
        if ( ![text isEqualToString:textField.text]) {
            return;
        }
        if (self.changeBlock) {
            self.changeBlock(textField.text);
        }
    } else {
        /// 有高亮选择的字 不做任何操作
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

    if (self.type != ANTextFieldDefault) {
        /// 解决当双击切换标点时误删除正常文字 bug
        NSString *punctuateSring = @"，。？！._@/#-";
        if (range.length == 0 && string.length == 1 && [punctuateSring containsString:string]) {
            return NO;
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
