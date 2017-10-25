//
//  EmployyessCell.m
//  CSchool
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "EmployyessCell.h"

@implementation EmployyessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.emPhoneNum.textColor = RGB(85, 85, 85) ;
    self.emPhoneNum.font = [UIFont systemFontOfSize:13.0f];
    self.emName.textColor = RGB(85, 85, 85);
    self.emName.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16.0f];
    self.callAction.imageView.contentMode = UIViewContentModeCenter;
}

- (IBAction)callNumberAction:(id)sender {
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
