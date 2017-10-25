//
//  PhoneListTableViewCell.m
//  CSchool
//
//  Created by 左俊鑫 on 16/6/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PhoneListTableViewCell.h"

@implementation PhoneListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)phoneCallAction:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
