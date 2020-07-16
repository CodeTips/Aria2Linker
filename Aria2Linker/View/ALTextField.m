//
//  ALTextField.m
//  Aria2Linker
//
//  Created by 输入密码引爆电脑 on 2020/7/16.
//  Copyright © 2020 CodeTips. All rights reserved.
//

#import "ALTextField.h"

@implementation ALTextField

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, ymNavBackgroundColor.CGColor);
    CGContextFillRect(context,CGRectMake(0,CGRectGetHeight(self.frame) -0.5,CGRectGetWidth(self.frame),0.5));
}

@end
