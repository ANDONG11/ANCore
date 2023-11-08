//
//  ANTextField.h
//  ZBMOM
//
//  Created by dong an on 2021/8/17.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    /// 数字 字母 汉字
    ANTextFieldASCII,
    
    /// 默认 全部字符包含特殊字符和表情
    ANTextFieldDefault,
    
    /// 默认 除去空格
    ANTextFieldDefaultNoSpace,
    
    /// 纯数字
    ANTextFieldNumber,
    
    /// 数字和字母
    ANTextFieldNumberORLetter,
    
    /// 浮点数 最多输入两位小数
    ANTextFieldDecimal,
    
} ANTextFieldType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextFieldBlock)(NSString *text);

@interface ANTextField : UITextField <UITextFieldDelegate>

/// 输入时回调
@property (nonatomic, copy) TextFieldBlock changeBlock;
/// 输入结束时回调
@property (nonatomic, copy) TextFieldBlock endBlock;
/// textField类型
@property (nonatomic, assign) ANTextFieldType type;
/// 最大限制位数
@property (nonatomic, assign) int limit;
/// 最大限制数值 正整数
@property (nonatomic, assign) int maxValue;
/// 限制位数和限制最大输入默认提示  可自定义修改
@property (nonatomic, copy) NSString *promptText;
/// 文字距离左侧距离
@property (nonatomic, assign) CGFloat textLeftSpace;

@end

NS_ASSUME_NONNULL_END
