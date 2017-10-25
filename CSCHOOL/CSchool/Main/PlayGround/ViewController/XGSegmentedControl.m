//
//  XGSegmentedControl.m
//  CSchool
//
//  Created by 左俊鑫 on 2017/9/15.
//  Copyright © 2017年 Joker. All rights reserved.
//

#import "XGSegmentedControl.h"
#import "UIButton+BackgroundColor.h"

@implementation XGSegmentedControl
{
    NSArray *_items;
    NSArray *_btnArray;
}

-(instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        _items = items;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.frame = CGRectMake(0, 0, kScreenWidth-60, 30);
    self.backgroundColor = RGB(234,234,234);
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 15;
    CGFloat with = (kScreenWidth - 60)/3;
    self.userInteractionEnabled = YES;
    for (int i=0; i<_items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_items[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i*with, 0, with, 30);
        btn.layer.cornerRadius = 15;
        btn.clipsToBounds = YES;
        [btn setBackgroundColor:Base_Orange forState:UIControlStateSelected];
        [btn setBackgroundColor:RGB(234,234,234) forState:UIControlStateNormal];
        [btn setTitleColor:Color_Gray forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if (i==0) {
            btn.selected = YES;
        }
        [self addSubview:btn];
    }
    
}

- (void)itemsClick:(UIButton *)sender{

    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.selected = NO;
        }
    }
    
    sender.selected = YES;
    
    if (_segmentItemClick) {
        _segmentItemClick(sender.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
