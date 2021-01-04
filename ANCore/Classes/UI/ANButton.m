//
//  ANButton.m
//  ANCore
//
//  Created by andong on 2020/12/30.
//  Copyright © 2020 ANDONG11. All rights reserved.
//

#import "ANButton.h"

@implementation ANButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 这是系统的默认状态(如果是系统默认状态就不处理了)
    if (self.style == ANImagePositionLeft && self.margin == 0) { return; }
    
    CGFloat image_w = self.imageView.bounds.size.width;
    CGFloat image_h = self.imageView.bounds.size.height;
    CGFloat label_w = self.titleLabel.bounds.size.width;
    CGFloat label_h = self.titleLabel.bounds.size.height;
    
    switch (self.style) {
        case ANImagePositionUp:
            self.imageEdgeInsets = UIEdgeInsetsMake(-label_h / 2.0 - self.margin / 2.0, label_w / 2.0, label_h / 2.0 + self.margin / 2.0, -label_w / 2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(image_h / 2.0 + self.margin / 2.0, -image_w / 2.0, -image_h / 2.0 - self.margin / 2.0, image_w / 2.0);
            break;
        case ANImagePositionDown:
            self.imageEdgeInsets = UIEdgeInsetsMake(label_h / 2.0 + self.margin / 2.0, label_w / 2.0, -label_h / 2.0 - self.margin / 2.0, -label_w / 2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(-image_h / 2.0 - self.margin / 2.0, -image_w / 2.0, image_h / 2.0 + self.margin / 2.0, image_w / 2.0);
            break;
        case ANImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -self.margin / 2.0, 0, self.margin / 2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, self.margin / 2.0, 0, -self.margin / 2.0);
            break;
        case ANImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, label_w + self.margin / 2.0, 0, -label_w - self.margin / 2.0);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -image_w - self.margin / 2.0, 0, image_w + self.margin / 2.0);
            break;
        default:
            break;
    }
}

@end
