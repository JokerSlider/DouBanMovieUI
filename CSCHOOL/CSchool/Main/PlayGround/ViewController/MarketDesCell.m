//
//  MarketDesCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MarketDesCell.h"

@implementation MarketDesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    CGFloat height = 120;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, height)];
    _textView.font = Title_Font;
    _selImageView = [[XGImageSelView alloc] initWithFrame:CGRectMake(10, height+10, kScreenWidth-20, VIEW_WITH)];
    [self.contentView addSubview:_textView];
    [self.contentView addSubview:_selImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
