//
//  WillTableViewCell.m
//  CSchool
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WillTableViewCell.h"

@implementation WillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.willExamState.textColor = Title_Color1;
    self.wiiExamName.textColor = Color_Black;
    self.willExamMethod.textColor = Color_Gray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
