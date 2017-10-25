//
//  InfoTabView.m
//  CSchool
//
//  Created by mac on 16/4/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "InfoTabViewCell.h"

@implementation InfoTabViewCell

- (void)awakeFromNib {

    self.timeLabel.textColor = Color_Gray;
    self.addressLabel.textColor = Color_Gray;
    self.examTime.textColor = Color_Gray;
    self.examAdddress.textColor = Color_Gray;
    self.examState.textColor = Color_Gray;
    self.examMethod.textColor =Color_Gray;
    self.examName.textColor = Color_Black;
//    self.se
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
