//
//  MarketTitleCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/10/11.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MarketTitleCell.h"
#import "SDAutoLayout.h"

@implementation MarketTitleCell

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
    _textFiled = [[UITextField alloc] init];
    _textFiled.font = Title_Font;
    [self.contentView addSubview:_textFiled];
    _textFiled.placeholder = @"起个有吸引力的标题吧";
    
    _textFiled.sd_layout
    .leftSpaceToView(self.contentView, 14)
    .topSpaceToView(self.contentView,5)
    .rightSpaceToView(self.contentView,5)
    .bottomSpaceToView(self.contentView,5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
