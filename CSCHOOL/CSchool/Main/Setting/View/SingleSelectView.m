//
//  SingleSelectView.m
//  CSchool
//
//  Created by 左俊鑫 on 16/1/6.
//  Copyright © 2016年 左俊鑫. All rights reserved.
//

#import "SingleSelectView.h"

@implementation SingleSelectView

- (void)setTitleArr:(NSArray *)titleArr{
    CGFloat width = 100;
    CGFloat space = 20;
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((space+width)*i, 0,width, 30);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = Title_Font;
        [btn setImage:[UIImage imageNamed:@"cs_select_no"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cs_select_yes"] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonClick:(UIButton *)sender{
    for (UIButton *btn in self.subviews) {
        btn.selected = NO;
    }
    sender.selected = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(selectView:didSelectAtIndex:)]) {
        [_delegate selectView:self didSelectAtIndex:sender.tag];
    }
}

- (NSInteger)getSelectIndex{
    for (UIButton *btn in self.subviews) {
        if (btn.selected) {
            return btn.tag;
        }
    }
    return -1;
}

- (void)btnSelectWithTitle:(NSString *)title{
    for (UIButton *btn in self.subviews){
        if ([btn.titleLabel.text isEqualToString:title]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}

- (void)btnSelectAtIndex:(NSInteger)index{
    for (UIButton *btn in self.subviews){
        if (btn.tag == index) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
}

@end
