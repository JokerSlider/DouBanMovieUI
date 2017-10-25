//
//  LBTextField.m
//  CSchool
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "LBTextField.h"

@implementation LBTextField

- (void)customWithPlaceholder: (NSString *)placeholder color: (UIColor *)color font: (UIFont *)font {
    
        self.placeholder = placeholder;
        [self setValue:color forKeyPath:@"_placeholderLabel.color"];
        [self setValue:font forKeyPath:@"_placeholderLabel.font"];
}
// 重写这个方法是为了使Placeholder居中，如果不写会出现类似于下图中的效果，文字稍微偏上了一些
- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(0, self.bounds.size.height * 0.5, 0, 0)];
}
@end
