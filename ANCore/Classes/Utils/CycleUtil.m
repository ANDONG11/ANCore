//
//  CycleUtil.m
//  ZBDevice
//
//  Created by dong an on 2021/4/25.
//

#import "CycleUtil.h"

/// 创建多行view

@implementation CycleUtil

- (instancetype)init {
    if (self = [super init]) {
        self.column      = 3;
        self.lineSpace   = 0;
        self.columnSpace = 0;
        self.leftSpace   = 0;
        self.topSpace    = 0;
        self.height      = 50;
    }
    return self;
}

#pragma mark - 循环创建多行多列view  在block回调中创建view
- (void)cycleWithCount:(NSInteger)count cycleViewBlock:(CycleViewBlock)block {
    
    
    NSInteger column    = self.column;
    /// 根据列数和总数算出行数
    NSInteger row       = (count%column==0)?count/column:count/column+1;
    /// 列间距
    CGFloat columnSpace = self.isSquare ? ([UIScreen mainScreen].bounds.size.width-self.height*column)/(column+1) : self.columnSpace;
    /// 行间距
    CGFloat lineSpace   = self.isSquare ? columnSpace: self.lineSpace;
    /// 距左间距
    CGFloat leftSpace   = self.isSquare ? columnSpace: self.leftSpace;
    /// 距上间距
    CGFloat topSpace    = self.topSpace;
    /// 高度
    CGFloat height      = self.height;
    /// 宽度
    CGFloat width       = self.isSquare ? height: ([UIScreen mainScreen].bounds.size.width-leftSpace*2-columnSpace*(column-1))/column;
    

    for (int i = 0; i < row; i++) {
        for (int j = 0; j < column; j++) {
            if (count % column != 0 && i == row-1 && j > count % column - 1) {
                break ;
            }
            @autoreleasepool {
                NSInteger index = column*i+j;
                CGRect rect = CGRectMake((width+columnSpace)*j+leftSpace,
                                         topSpace+(height+lineSpace)*i,
                                         width,
                                         height);
            
                block(index,rect);
            }
        }
    }
}


@end
