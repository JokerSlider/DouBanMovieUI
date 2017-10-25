//
//  FinancePhoneNumTableViewCell.m
//  CSchool
//
//  Created by mac on 16/9/6.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "FinancePhoneNumTableViewCell.h"

@implementation FinancePhoneNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _telNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telNum.keyboardType = UIKeyboardTypeNumberPad;
    _telNum.borderStyle = UITextBorderStyleRoundedRect;
    _telNum.placeholder  =@"请填写您的电话";
    if (self.telNum.text.length>11) {
        self.telNum.enabled = NO;
    }else{
        self.telNum.enabled = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
